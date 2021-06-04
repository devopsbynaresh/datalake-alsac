import argparse
import json
import sys

from googleapiclient import http

from gcm import config

# Download chunk size; 32MB
CHUNK_SIZE = 32 * 1024 * 1024

# Declare command-line flags.
argparser = argparse.ArgumentParser(add_help=False)
argparser.add_argument(
    'dataset',
    help='The dataset this download belongs to.')
argparser.add_argument(
    'report_id',
    help='The report ID to download a report file from.')
argparser.add_argument(
    'file_id',
    help='The report file ID to download.')
argparser.add_argument(
    'filename',
    help='The filename to save report file to.')


def main(event):
    s3_files = []
    for record in event['Records']:
        download_request = json.loads(record['Sns']['Message'])
        dataset = download_request['dataset']
        report_id = download_request['report_id']
        file_id = download_request['file_id']
        filename = download_request['filename']
        print('Downloading landing data for dataset %s, report_id %s, file_id %s, filename %s' % (dataset, report_id, file_id, filename))
        s3_key = download(dataset, report_id, file_id, filename)
        s3_files.append(s3_key)
    return s3_files

def download(dataset, report_id, file_id, filename):
    # Build the DFA Reporting service
    service = config.get_dfareporting_service()

    download_to_landing(dataset, report_id, file_id, filename, service)

    # Move successful download to raw
    raw_key = config.move_successful_download(dataset, filename)
    return raw_key


def download_to_landing(dataset, report_id, file_id, filename, service):
    # Download report file to landing
    with config.get_download_landing_file_for_writing(dataset, filename) as report_file:
        request = service.files().get_media(reportId=report_id, fileId=file_id)
        downloader = http.MediaIoBaseDownload(report_file, request, chunksize=CHUNK_SIZE)

        download_finished = False
        while download_finished is False:
            _, download_finished = downloader.next_chunk()
