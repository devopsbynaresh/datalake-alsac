from gcm import config

# Report Types
INITIAL = 'Initial'
HISTORY = 'History'
DAILY = 'Daily'


def lambda_handler(event, context):
    print('Running monitor, event ID %s, Request ID %s' % (event['id'], context.aws_request_id))
    main()


def main():
    # Build the DFA Reporting service
    service = config.get_dfareporting_service()

    # Load profile ID
    profile_id = load_profile_id(service)

    # List report files
    dataset_to_report_info = config.get_dataset_to_report_info()
    file_infos = []
    for dataset, report_info in dataset_to_report_info.items():
        file_info = get_report_file_info(service, profile_id, dataset, report_info, False)
        if file_info:
            file_infos.append(file_info)

    # Invoke downloader
    for dataset, report_id, file_id, raw_filename in file_infos:
        print('Downloading dataset %s / report id %s / file id %s to: %s' % (dataset, report_id, file_id, raw_filename))
        config.begin_download(dataset, report_id, file_id, raw_filename)


def load_profile_id(service):
    profile_request = service.userProfiles().list()
    profile_response = profile_request.execute()
    return profile_response['items'][0]['profileId']


def get_report_file_info(service, profile_id, dataset, report_info, download_initial):
    for report_type, report_id in report_info.items():
        if download_initial or report_type != INITIAL:
            file_list_request = service.reports().files().list(
                profileId=profile_id,
                reportId=report_id,
                maxResults=10,
                fields='items(id,status,fileName,dateRange(startDate,endDate),lastModifiedTime,format)')
            file_list_response = file_list_request.execute()

            files = file_list_response['items']
            for file in reversed(files):
                if file['status'] == "REPORT_AVAILABLE":
                    raw_filename = get_raw_report_filename(file)
                    if not config.report_already_exists(dataset, raw_filename):
                        # Only download one report per dataset per run
                        return (dataset, report_id, file['id'], raw_filename)

    return None


def get_raw_report_filename(file):
    """Generates a report file name based on the file metadata."""
    # If no filename is specified, use the file ID instead.
    file_name = file['fileName'] or file['id']
    start = '_' + file['dateRange']['startDate']
    end = '_' + file['dateRange']['endDate']
    last = '_' + file['lastModifiedTime']
    extension = '.csv' if file['format'] == 'CSV' else '.xml'
    return file_name + start + end + last + extension


def extract_start_end_from_filename(filename):
    split = filename.rsplit('_', 3)
    return (split[1], split[2])


if __name__ == '__main__':
    main()
