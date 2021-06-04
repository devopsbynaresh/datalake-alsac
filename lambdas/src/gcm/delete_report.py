import argparse
import sys

import config
import monitor

# Declare command-line flags.
argparser = argparse.ArgumentParser(add_help=False)
argparser.add_argument(
    'report_id',
    help='The report ID to delete.')


def main(argv):
    # Retrieve command line arguments.
    parser = argparse.ArgumentParser(
            description=__doc__,
            formatter_class=argparse.RawDescriptionHelpFormatter,
            parents=[argparser])
    flags = parser.parse_args(argv[1:])

    report_id = flags.report_id

    # Build the DFA Reporting service
    service = config.get_dfareporting_service()

    # Load profile ID
    profile_id = monitor.load_profile_id(service)

    # List remaining reports
    list_report_request = service.reports().list(profileId=profile_id)
    list_report_response = list_report_request.execute()
    existing_reports = set()
    for report in list_report_response['items']:
        existing_reports.add(report['id'])
    print('Existing reports: ' + str(existing_reports))

    # Print monitored reports
    monitored_reports = set()
    for report_info in config.get_dataset_to_report_info().values():
        for monitored_report_id in report_info.values():
            monitored_reports.add(monitored_report_id)
    print('LOCALLY monitored reports: ' + str(monitored_reports))

    # Print orphaned reports
    print('LOCALLY orphaned reports (not monitored): ' + str(existing_reports.difference(monitored_reports)))
    print('LOCALLY orphaned reports (no longer exist): ' + str(monitored_reports.difference(existing_reports)))

    if report_id != '-1':
        # Delete report
        delete_report_request = service.reports().delete(profileId=profile_id, reportId=report_id)
        delete_report_request.execute()


if __name__ == '__main__':
    main(sys.argv)
