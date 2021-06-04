import argparse, sys, json, os
from datetime import datetime, timedelta
import pandas as pd
import boto3, botocore
from os import path

# Process 10k rows at a time
CHUNK_SIZE = 10_000

# Partition data by date column
PARTITION_NAME = "date"

# Convert "Date" column to lowercase "date" to support partition format
def lowercase_date(bucket, s3_key):
    s3_client = boto3.client("s3")
    s3_client.download_file(bucket, s3_key, "/tmp/temp.csv")
    data = open("/tmp/temp.csv", "r")
    # data = ''.join([re.sub(r'\bGrand Total.*','',i) for i in data]).replace("Date","date")
    data = "".join([i for i in data]).replace("Date", "date")
    f = open("/tmp/temp.csv", "w")
    f.writelines(data)
    f.close()


def extract_dataset_filename_from_s3_key(key):
    split = key[len("gcm/") :].split("/", 1)
    return (split[0], split[1])


"""
def load_dataset_types(dataset):
    return load_json_parameter(dataset + '-dtypes')

def load_json_parameter(name):
    param_name = '/data-lake/data-extractor/gcm/' + name
    parameter_store = boto3.client('ssm')

    param = parameter_store.get_parameter(
        Name=param_name,
        WithDecryption=True)
    if param:
        param = param.get('Parameter')
        if param:
            param = param.get('Value')
            if param:
                param = json.loads(param)

    if not param:
        param = {}
    return param
"""

# Main function
def main(bucket, s3_key):
    lowercase_date(bucket, s3_key)
    dataset, filename = extract_dataset_filename_from_s3_key(s3_key)
    print("Processing raw data for dataset %s, filename %s" % (dataset, filename))
    process(dataset, filename)


# Skip header lines in report file
def skipHeaders(in_file):
    line = in_file.readline()
    while not line.startswith("Report Fields") and line != "":
        line = in_file.readline()


# Convert .csv file to .parquet
# def process(dataset, filename):
#     # expected_dtypes = load_dataset_types(dataset)
#     with open("/tmp/temp.csv","r") as file:
#         skipHeaders(file)
#         csv_stream = pd.read_csv(file, chunksize=CHUNK_SIZE)
#         offset = 0
#         for chunk in csv_stream:
#             chunk = chunk[:-1] # Remove last 'Grand Total' row

#             for col in chunk.columns:
#                 if col != PARTITION_NAME:
#                     # Get datatypes for each row value in the column
#                     dtypes = [str(x).replace("<class '", "").replace("'>","") for x in chunk[col].apply(type)]
#                     # Default datatype is string
#                     real_dtype = 'str'

#                     # Find non-NULL values in column and check their datatype
#                     for row in range(len(chunk[col])):
#                         i = row + offset
#                         if pd.notnull(chunk[col][i]):
#                             if col == 'ZIP/Postal Code': # Zip code appears as integer, but hard-code to string type for now
#                                 real_dtype = 'str'
#                             elif 'conversion' in col.lower():
#                                 real_dtype = 'Int64'
#                             elif 'int' not in dtypes[row] and 'float' not in dtypes[row]: # If value is not automatically detected as an int or float, check if the value is a number
#                                 if chunk[col][i].isnumeric() and 'None' not in chunk[col].values:
#                                     real_dtype = 'Int64' # Because it was not detected automatically as a float, it should be Int64
#                             else:
#                                 real_dtype = dtypes[row]
#                             break

#                     # Force real datatype onto columns that have missing data
#                     if real_dtype == 'str':
#                         chunk[col] = chunk[col].fillna('')
#                         chunk[col] = chunk[col].astype(real_dtype)
#                     elif real_dtype == 'Int64':
#                         chunk[col] = chunk[col].astype('float').astype(real_dtype)

#             # Convert chunk to Parquet file
#             chunk.to_parquet(path='/tmp/output', engine='pyarrow', partition_cols=[PARTITION_NAME], compression='Snappy')

#             # Update offset because each chunk is 10k rows
#             offset += 10000

# Convert .csv file to .parquet
def process(dataset, filename):
    # expected_dtypes = load_dataset_types(dataset)
    s3 = boto3.resource("s3")
    bucket = s3.Bucket(os.environ["UPLOAD_BUCKET"])
    with open("/tmp/temp.csv", "r") as file:
        skipHeaders(file)
        csv_stream = pd.read_csv(file, header=0, iterator=True, chunksize=CHUNK_SIZE)
        dtype_int64 = [
            "Activity ID",
            "Campaign ID",
            "Placement ID",
            "Site ID (DCM)",
            "Ad ID",
            "Creative ID",
            "Click Count",
            "Impression Count",
            "Path Length",
            "Total Conversions",
            "Video First Quartile Completions",
            "Video Midpoints",
            "Video Third Quartile Completions",
            "Video Completions",
            "Paid Search Ad Group ID",
            "Paid Search Clicks",
            "Paid Search Impressions",
            "Donation Complete : Donation Complete - Monthly: Paid Search Transactions",
            "Donation Complete : Donation Complete - One Time: Paid Search Transactions",
        ]

        dtype_double = [
            "Total Revenue",
            "Click-through Revenue",
            "View-through Revenue",
            "Paid Search Cost",
            "Donation Complete : Donation Complete - One Time: Paid Search Revenue",
            "Donation Complete : Donation Complete - Monthly: Paid Search Revenue",
            "Media Cost",
        ]
        dtype_int = ["Click-through Conversions", "View-through Conversions"]
        dtype_string = [
            "Activity",
            "Activity Group",
            "Campaign",
            "Site (DCM)",
            "Placement",
            "Creative",
            "Floodlight Attribution Type",
            "Interaction Channel",
            "Interaction Type",
            "Path Type",
            "ORD Value",
            "Audience Targeted",
            "Browser/Platform",
            "Operating System",
            "Platform Type",
            "Ad",
            "Ad Type",
            "Advertiser",
            "Advertiser Group",
            "Creative Type",
            "Creative Pixel Size",
            "City",
            "Country",
            "Designated Market Area (DMA)",
            "State/Region",
            "ZIP/Postal Code",
            "Days Since Attributed Interaction",
            "Days Since First Interaction",
            "Hours Since Attributed Interaction",
            "Paid Search Ad Group",
            "Paid Search Campaign",
        ]
        dtype_datetime = ["Activity Date/Time"]

        for chunk in csv_stream:
            chunk = chunk[:-1]

            for col in chunk.columns:
                if col != PARTITION_NAME:
                    if col in dtype_int64:
                        chunk[col] = chunk[col].astype("float").astype("Int64")

                    elif col in dtype_double:
                        chunk[col] = chunk[col].astype("double")

                    elif col in dtype_int:
                        chunk[col] = chunk[col].astype("int")

                    elif col in dtype_string:
                        chunk[col] = chunk[col].astype("str").fillna("")
                        chunk[col] = chunk[col].replace("nan", "")

                        # BIDM-1602:    Add hyphen after the first character to "ORD Value" if missing
                        #               Format should match "1-2345678"
                        if col == 'ORD Value':
                            for row in chunk[col]:
                                if row.isdigit():
                                    row_with_hyphen = row[:1] + '-' + row[1:]
                                    chunk[col] = chunk[col].replace(row, row_with_hyphen)

            #            for col in dtype_datetime:
            #                chunk[col] = chunk[col].astype('datetime64[ns]')
            #     test_chunk.astype({exp: expected_dtypes[exp]}).dtypes
            #     print(exp, curr)
            # chunk = chunk[:-1].astype(expected_dtypes)

            chunk.to_parquet(
                path="/tmp/output",
                engine="pyarrow",
                partition_cols=[PARTITION_NAME],
                compression="Snappy",
            )
