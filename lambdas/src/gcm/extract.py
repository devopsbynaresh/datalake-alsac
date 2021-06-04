import argparse
from datetime import date
from datetime import timedelta
import sys
import time
import os
import json
import config
from gcm import download
from gcm import monitor
import pandas as pd
from gcm import process

# Declare command-line flags.
argparser = argparse.ArgumentParser(add_help=False)
argparser.add_argument("dataset", help="The dataset name.")
argparser.add_argument("report_id", help="The report ID to set up for extraction.")

# Date configuration; we've heard two stories of which of these is true; going with safest case for now
# Can't run reports older than 2 years
HISTORY_START_DATE = "2019-07-01"
DAILY_SCHEDULE_END_DATE = "2100-01-01"

# 48 hours to finalization of config
# DAYS_AGO = 5
# DAILY_RANGE = 'LAST_7_DAYS'

# 8 days to finalization of config
DAYS_AGO = 11
DAILY_RANGE = "LAST_14_DAYS"


def main(argv):
    # Retrieve command line arguments.
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        parents=[argparser],
    )
    flags = parser.parse_args(argv[1:])

    dataset = flags.dataset
    report_id = flags.report_id
    extract(dataset, report_id)


def lambda_handler(event, context):
    dataset = event["dataset"]
    report_id = event["report_id"]
    print(
        "Setting up data extraction for dataset %s, report_id %s, Request ID %s"
        % (dataset, report_id, context.aws_request_id)
    )
    return extract(dataset, report_id)


def select_criteria(type):
    # returns correct criteria key based on report type

    criteria = os.environ.get("CRITERIA")
    criteria = str(criteria).replace("'", '"')
    criteria = json.loads(criteria)

    return criteria[type]


def extract(dataset, report_id):
    # Build the DFA Reporting service
    service = config.get_dfareporting_service()

    # Load profile ID
    profile_id = monitor.load_profile_id(service)

    # Load existing dataset/reportIDs
    dataset_to_report_info = config.get_dataset_to_report_info()
    report_info = dataset_to_report_info.get(dataset)
    if report_info:
        # Report info already exists for this dataset
        daily = report_info.get(monitor.DAILY)
        if daily:
            raise ValueError(
                "Dataset %s already exists (with Daily report ID of %s)"
                % (dataset, daily)
            )
        else:
            ret = restart_initial_report_handling(
                dataset, service, profile_id, report_info
            )
    else:
        # Start from scratch
        ret = add_new_dataset(
            dataset, report_id, service, profile_id, dataset_to_report_info
        )

    if not ret:
        ret = (
            "Dataset %s initial run exceeded deadline; will need to re-run extraction after report completes"
            % dataset
        )

    print(ret)
    return ret


def add_new_dataset(dataset, report_id, service, profile_id, dataset_to_report_info):
    # Load existing report
    report_request = service.reports().get(profileId=profile_id, reportId=report_id)
    report_response = report_request.execute()
    report = report_response

    # Build initial report
    build_initial_report(dataset, report_id, report)

    # Insert initial report
    initial_report_request = service.reports().insert(profileId=profile_id, body=report)
    initial_report_response = initial_report_request.execute()
    initial_report_id = initial_report_response["id"]

    # Execute initial report
    report_file = (
        service.reports()
        .run(profileId=profile_id, reportId=initial_report_id)
        .execute()
    )
    file_id = report_file["id"]

    # Save Report Info
    dataset_to_report_info[dataset] = {monitor.INITIAL: initial_report_id}
    config.save_dataset_to_report_info(dataset_to_report_info)

    # Wait for initial report to complete
    report_file = wait_initial_report_completion(
        dataset, service, initial_report_id, file_id
    )
    if report_file:
        # Process initial report
        raw_filename = monitor.get_raw_report_filename(report_file)
        return process_initial_report_and_complete_setup(
            dataset,
            service,
            profile_id,
            initial_report_response,
            initial_report_id,
            file_id,
            raw_filename,
        )
    else:
        return None


def wait_initial_report_completion(dataset, service, initial_report_id, file_id):
    # Wait for completion, up to 5 minutes to ensure processing can complete
    for _ in range(0, 5):
        report_file = (
            service.files().get(reportId=initial_report_id, fileId=file_id).execute()
        )

        status = report_file["status"]
        if status == "REPORT_AVAILABLE":
            return report_file
        elif status != "PROCESSING":
            raise ValueError(
                "Dataset %s failed to run initial report (with Initial report ID of %s)"
                % (dataset, initial_report_id)
            )

        print("Dataset %s initial run in process; sleeping 1min" % dataset)
        time.sleep(60)

    return None


def restart_initial_report_handling(dataset, service, profile_id, report_info):
    # Load initial report file id
    _, _, file_id, raw_filename = monitor.get_report_file_info(
        service, profile_id, dataset, report_info, True
    )

    # Load initial report
    initial_report_id = report_info[monitor.INITIAL]
    initial_report_request = service.reports().get(
        profileId=profile_id, reportId=initial_report_id
    )
    initial_report = initial_report_request.execute()

    # Process initial report
    return process_initial_report_and_complete_setup(
        dataset,
        service,
        profile_id,
        initial_report,
        initial_report_id,
        file_id,
        raw_filename,
    )


def process_initial_report_and_complete_setup(
    dataset,
    service,
    profile_id,
    initial_report,
    initial_report_id,
    file_id,
    raw_filename,
):
    # Download initial report file
    download.download_to_landing(
        dataset, initial_report_id, file_id, raw_filename, service
    )

    # Extract and save expected Data Types for Schema
    # with config.get_download_landing_file_for_reading(dataset, raw_filename) as in_file:
    #     process.skipHeaders(in_file)
    #     csv_stream = pd.read_csv(in_file, header=0, skipfooter=1, engine='python')
    #     expected_dtypes = csv_stream.dtypes
    #     config.save_dataset_types(dataset, expected_dtypes.astype(str).to_dict())

    # Delete initial report file
    config.delete_download_landing_file(dataset, raw_filename)

    # Patch Initial report to History and execute
    history_patch = build_history_report_patch(dataset, initial_report)
    history_report_request = service.reports().patch(
        profileId=profile_id, reportId=initial_report_id, body=history_patch
    )
    history_report_request.execute()
    service.reports().run(profileId=profile_id, reportId=initial_report_id).execute()

    # Create Daily report
    build_daily_report(dataset, initial_report)
    daily_report_request = service.reports().insert(
        profileId=profile_id, body=initial_report
    )
    daily_report_response = daily_report_request.execute()
    daily_report_id = daily_report_response["id"]

    # Re-Load existing dataset/reportIDs
    dataset_to_report_info = config.get_dataset_to_report_info()
    dataset_to_report_info[dataset] = {
        monitor.HISTORY: initial_report_id,
        monitor.DAILY: daily_report_id,
    }
    config.save_dataset_to_report_info(dataset_to_report_info)

    return "Dataset %s extraction created successfully; report_info: %s" % (
        dataset,
        dataset_to_report_info[dataset],
    )


def filter_report_for_copying(report):
    # Remove unnecessary fields from report copy
    report.pop("kind", None)
    report.pop("id", None)
    report.pop("etag", None)
    report.pop("lastModifiedTime", None)
    report.pop("ownerProfileId", None)
    report.pop("accountId", None)
    report.pop("schedule", None)
    report.pop("delivery", None)


def build_initial_report(dataset, report_id, report):
    filter_report_for_copying(report)
    type = report["type"]
    criteria = select_criteria(type)

    # Add/update existing fields
    report["format"] = "CSV"
    report["fileName"] = (
        dataset
        + "_Initial_"
        + report_id
        + "__"
        + (report["fileName"] or report["name"])
    )
    report["name"] = (
        dataset + " - Initial; Copied from " + report_id + " (" + report["name"] + ")"
    )

    today = date.today()
    initial_date = today - timedelta(days=DAYS_AGO)
    initial_date_str = initial_date.strftime("%Y-%m-%d")
    report[criteria]["dateRange"] = {
        "startDate": initial_date_str,
        "endDate": initial_date_str,
    }


def build_history_report_patch(dataset, initial_report):
    type = initial_report["type"]
    criteria = select_criteria(type)
    end_date = date.today() - timedelta(days=DAYS_AGO)

    # if floodlight report, then history date must be 60 days ago
    if "floodlight" in dataset:
        historyDate = date.today() - timedelta(days=60)
        historyStartDate = historyDate.strftime("%Y-%m-%d")

    else:
        historyStartDate = HISTORY_START_DATE  # the above if statement causes a scoping issue when previously overwriting HISTORY_START_DATE
        # so assigning HISTORY_START_DATE to a new variable in the else condition fixes that.

    patch = {
        "fileName": dataset
        + "_History"
        + initial_report["fileName"][len(dataset + "_Initial") :],
        "name": dataset
        + " - History"
        + initial_report["name"][len(dataset + " - Initial") :],
        criteria: {
            "dateRange": {
                "startDate": historyStartDate,
                "endDate": end_date.strftime("%Y-%m-%d"),
            }
        },
    }

    return patch


def build_daily_report(dataset, initial_report):
    filter_report_for_copying(initial_report)
    type = initial_report["type"]
    criteria = select_criteria(type)

    # Add/update existing fields
    initial_report["fileName"] = (
        dataset + "_Daily" + initial_report["fileName"][len(dataset + "_Initial") :]
    )
    initial_report["name"] = (
        dataset + " - Daily" + initial_report["name"][len(dataset + " - Initial") :]
    )

    initial_report[criteria]["dateRange"] = {"relativeDateRange": DAILY_RANGE}

    initial_report["schedule"] = {
        "active": True,
        "startDate": date.today().strftime("%Y-%m-%d"),
        "expirationDate": DAILY_SCHEDULE_END_DATE,
        "repeats": "DAILY",
        "every": 1,
    }


if __name__ == "__main__":
    main(sys.argv)
