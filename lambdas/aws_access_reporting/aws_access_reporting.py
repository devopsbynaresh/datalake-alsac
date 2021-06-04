#!/usr/bin/python3
# aws_access_reporting.py

"""AWS Access Reporting Module.

This module takes an S3 bucket name as input and, with the right permissions in place,
uses Athena to process CloudTrail data and create AWS access reports for new
and historical log data.

It is meant to be invoked as an AWS Lambda function triggered by a CloudWatch event.
The handler(event, context) function is the module entrypoint.
"""

__version__ = "0.1.0"

import os
import time
from datetime import datetime, timedelta
from typing import List, Set

import boto3  # type: ignore


def conditionally_create_database(
    athena_session, query_result_config: dict, database: str
) -> dict:
    """Creates an Athena database to hold CloudTrail log data if one does not
    already exist.

    Args:
        athena_session (botocore.client.Athena): An Athena session to run queries against.
        query_result_config (dict): Result configuration for the Athena query.
        database (str): Name of the database to be created.

    Returns:
        dict: The response from the database creation query execution.
    """

    query = f"CREATE DATABASE IF NOT EXISTS {database}"
    response = athena_session.start_query_execution(
        QueryString=query, ResultConfiguration=query_result_config
    )
    print("Conditionally created an Athena database for AWS access reporting.")
    return response


def conditionally_create_table(
    athena_session, query_result_config: dict, bucket: str, database: str, account: str
) -> tuple:
    """Creates an Athena table for the specified account if one does not
    already exist.

    Args:
        athena_session (botocore.client.Athena): An Athena session to run queries against.
        query_result_config (dict): Result configuration for the Athena query.
        bucket (str): The name of the bucket holding the CloudTrail logs.
        database (str): Name of the database to add tables to.
        account (str): The account the table is being created for.

    Returns:
        tuple: The table name and response from the table creation query execution.
    """
    table_name = f"{database}_{account}"
    query = fr"CREATE EXTERNAL TABLE {database}.{table_name} (eventversion STRING,useridentity STRUCT< type:STRING,principalid:STRING,arn:STRING,accountid:STRING,invokedby:STRING,accesskeyid:STRING,userName:STRING,sessioncontext:STRUCT< attributes:STRUCT< mfaauthenticated:STRING,creationdate:STRING>,sessionissuer:STRUCT< type:STRING,principalId:STRING,arn:STRING,accountId:STRING,userName:STRING>>>,eventtime STRING,eventsource STRING,eventname STRING,awsregion STRING,sourceipaddress STRING,useragent STRING,errorcode STRING,errormessage STRING,requestparameters STRING,responseelements STRING,additionaleventdata STRING,requestid STRING,eventid STRING,resources ARRAY<STRUCT< ARN:STRING,accountId:STRING,type:STRING>>,eventtype STRING,apiversion STRING,readonly STRING,recipientaccountid STRING,serviceeventdetails STRING,sharedeventid STRING,vpcendpointid STRING ) PARTITIONED BY (region string, year string, month string, day string) ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde' STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' LOCATION 's3://{bucket}/AWSLogs/{account}/CloudTrail/';"
    response = athena_session.start_query_execution(
        QueryString=query, ResultConfiguration=query_result_config
    )
    print(f"Conditionally created an Athena table for account {account}")
    return table_name, response


def get_list_of_accounts(bucket: str) -> List[str]:
    """Returns a list of accounts that have logs associated with them.

    Iterates through each subdirectory under the AWSLogs prefix in the specified S3
    bucket to determine which accounts have logs.

    Args:
        bucket (str): The name of the bucket holding the CloudTrail logs.

    Returns:
        list: A list of accounts that have logs associated with them.
    """
    client = boto3.client("s3")
    prefix = f"AWSLogs/"

    accounts = []
    for page in client.get_paginator("list_objects_v2").paginate(
        Bucket=bucket, Prefix=prefix, Delimiter="/"
    ):
        for prefix in page.get("CommonPrefixes", []):
            accounts.append(prefix.get("Prefix").split("/")[-2])
    print(f"Accounts in the S3 bucket: {accounts}")
    return accounts


def get_list_of_regions(bucket: str, account: str) -> List[str]:
    """Returns a list of regions that have logs associated with them for the
    specified account.

    Iterates through each subdirectory under the account prefix in the specified S3
    bucket to determine which regions have logs.

    Args:
        bucket (str): The name of the bucket holding the CloudTrail logs.
        account (str): The targeted account.

    Returns:
        list: A list of regions that have logs associated with them.
    """
    client = boto3.client("s3")
    prefix = f"AWSLogs/{account}/CloudTrail/"

    regions = []
    for page in client.get_paginator("list_objects_v2").paginate(
        Bucket=bucket, Prefix=prefix, Delimiter="/"
    ):
        for prefix in page.get("CommonPrefixes", []):
            regions.append(prefix.get("Prefix").split("/")[-2])
    print(f"Regions in account {account}: {regions}")
    return regions


def get_sorted_list_of_logged_days(bucket: str, account: str, region: str) -> List[str]:
    """Returns a sorted list of logged days for the specified region and
    account.

    Iterates through each subdirectory under the region prefix for an account to
    determine the dates that have logs associated with them. Appends each date to
    a list and returns a sorted copy of that list.

    Args:
        bucket (str): The name of the bucket holding the CloudTrail logs.
        account (str): The targeted account.
        region (str): The targeted region.

    Returns:
        list: A sorted list of days that have logs associated with them.
    """
    client = boto3.client("s3")
    prefix = f"AWSLogs/{account}/CloudTrail/{region}/"

    years = set()
    for page in client.get_paginator("list_objects_v2").paginate(
        Bucket=bucket, Prefix=prefix, Delimiter="/"
    ):
        for prefix in page.get("CommonPrefixes", []):
            years.add(prefix.get("Prefix").split("/")[-2])

    years_months = set()
    for year in years:
        prefix = f"AWSLogs/{account}/CloudTrail/{region}/{year}/"
        for page in client.get_paginator("list_objects_v2").paginate(
            Bucket=bucket, Prefix=prefix, Delimiter="/"
        ):
            for prefix in page.get("CommonPrefixes", []):
                years_months.add(f"{year}/{prefix.get('Prefix').split('/')[-2]}")

    years_months_days = set()
    for year_month in years_months:
        prefix = f"AWSLogs/{account}/CloudTrail/{region}/{year_month}/"
        for page in client.get_paginator("list_objects_v2").paginate(
            Bucket=bucket, Prefix=prefix, Delimiter="/"
        ):
            for prefix in page.get("CommonPrefixes", []):
                years_months_days.add(
                    f"{year_month}/{prefix.get('Prefix').split('/')[-2]}"
                )
    sorted_days = sorted(years_months_days)
    print(f"Days in region {region} in account {account}: {sorted_days}")
    return sorted_days


def conditionally_create_partitions(
    athena_session,
    query_result_config: dict,
    database: str,
    table: str,
    bucket: str,
    account: str,
    region: str,
    days: List[str],
) -> dict:
    """Create Athena partitions for the logged days if partitions don't exist.

    Args:
        athena_session (botocore.client.Athena): An Athena session to run queries against.
        query_result_config (dict): Result configuration for the Athena query.
        database (str): Name of the database to add partitions to.
        table (str): Name of the table to add partitions to.
        bucket (str): The name of the bucket holding the CloudTrail logs.
        account (str): The account the partitions are being created for.
        region (str): The region the partitions are being created for.
        days (list): A sorted list of logged days in the specified region and account.

    Returns:
        dict: The response from the partition creation query execution.
    """
    # Chunking solves a problem related to the max query length in Athena.
    chunk_size = 50
    day_chunks = [
        days[index : index + chunk_size] for index in range(0, len(days), chunk_size)
    ]

    for chunk in day_chunks:
        query = fr"ALTER TABLE {database}.{table} ADD IF NOT EXISTS"
        for day in chunk:
            split_day = day.split("/")
            query += fr" PARTITION (region='{region}', year='{split_day[0]}', month='{split_day[1]}', day='{split_day[2]}') LOCATION 's3://{bucket}/AWSLogs/{account}/CloudTrail/{region}/{split_day[0]}/{split_day[1]}/{split_day[2]}/'"
        response = athena_session.start_query_execution(
            QueryString=query, ResultConfiguration=query_result_config
        )
        execution_id = response["QueryExecutionId"]
        state = "RUNNING"
        while state in ["RUNNING", "QUEUED"]:
            response = athena_session.get_query_execution(QueryExecutionId=execution_id)
            if (
                "QueryExecution" in response
                and "Status" in response["QueryExecution"]
                and "State" in response["QueryExecution"]["Status"]
            ):
                state = response["QueryExecution"]["Status"]["State"]

            # Sleep before re-checking query execution state to prevent race condition.
            time.sleep(1)
    print(
        f"Conditionally created partitions for all logged days in region {region} in account {account}."
    )
    return response


def get_eligible_report_sundays(days: List[str]) -> Set[str]:
    """Returns a set of eligible report Sundays from a sorted list of days.

    An eligible report Sunday is a Sunday whose previous week – from Sunday at midnight
    UTC to Saturday at 11:59:59 – has logs to process in a report.

    The first Sunday is considered an eligible report Sunday, though it may not have a
    full week's worth of data.

    Args:
        days (list): A sorted list of logged days in the specified region and account.

    Returns:
        set: A set of eligible report Sundays.
    """
    set_of_sundays = set()
    for day in days:
        if datetime.strptime(day, "%Y/%m/%d").weekday() == 6:
            set_of_sundays.add(day)
    print(f"Eligible Sundays for report generation: {set_of_sundays}")
    return set_of_sundays


def get_existing_report_sundays(bucket: str, account: str) -> Set[str]:
    """Returns a set of Sundays for the specified account that already have an
    existing report generated for them.

    Args:
        bucket (str): The name of the bucket holding the CloudTrail logs.
        account (str): The account the reports are being created for.

    Returns:
        set: A set of Sundays with existing reports.
    """

    client = boto3.client("s3")
    prefix = f"reports/aws-account-access/{account}"
    report_sundays = set()
    for page in client.get_paginator("list_objects_v2").paginate(
        Bucket=bucket, Prefix=prefix
    ):
        for obj in page.get("Contents", []):
            report_sundays.add("/".join(obj["Key"].split("/")[3:6]))
    print(f"Existing report Sundays in account {account}: {report_sundays}")
    return report_sundays


def get_missing_report_sundays(
    existing_sundays: Set[str], eligible_sundays: Set[str]
) -> Set[str]:
    """Returns a set of Sundays that do not have an existing report.

    Args:
        existing_sundays (set): A set of Sundays with existing reports.
        eligible_sundays (set): A set of Sundays eligible for reporting.

    Returns:
        set: A set of eligible Sundays without an existing report.
    """
    missing_sundays = eligible_sundays.difference(existing_sundays)
    print(f"Missing report Sundays: {missing_sundays}")
    return missing_sundays


def get_dates_from_sunday(sunday: str) -> List[str]:
    """Returns a list of dates corresponding to a report's terminating Sunday.

    Args:
        sunday (str): The Sunday to generate a list of dates for.

    Returns:
        list: A list of dates.
    """
    dates = []
    sunday_datetime = datetime.strptime(sunday, "%Y/%m/%d")
    for num in range(1, 8):
        dates.append((sunday_datetime - timedelta(days=num)).strftime("%Y/%m/%d"))

    print(f"Dates from Sunday {sunday}: {dates}")
    return dates


def generate_report(
    athena_session,
    database: str,
    table: str,
    bucket: str,
    account: str,
    sunday: str,
    regions: List[str],
) -> dict:
    """Generate a report for the specified Sunday.

    Args:
        athena_session (botocore.client.Athena): An Athena session to run queries against.
        database (str): Name of the database to run the query against.
        table (str): Name of the table to run the query against.
        bucket (str): The name of the bucket holding the CloudTrail logs.
        account (str): The account to create the report for.
        sunday (str): The Sunday to create the report for.
        regions (list): The regions with logs associated with them.

    Returns:
        dict: The response from the query execution.
    """
    dates = get_dates_from_sunday(sunday)
    query = fr"SELECT useridentity.principalId as Requester, sourceipaddress as SourceIP, count(*) as NumRequests FROM {database}.{table} WHERE region in ("
    for index, region in enumerate(regions):
        region_length = len(regions)
        if index != region_length - 1:
            query += fr"'{region}', "
        else:
            query += fr"'{region}') AND ("

    for index, date in enumerate(dates):
        split_date = date.split("/")
        if index != 0:
            query += fr" or (year = '{split_date[0]}' and month = '{split_date[1]}' and day = '{split_date[2]}')"
        else:
            query += fr"(year = '{split_date[0]}' and month = '{split_date[1]}' and day = '{split_date[2]}')"
    query += fr") GROUP BY useridentity.principalId, sourceipaddress ORDER BY useridentity.principalId"
    report_output_location = (
        f"s3://{bucket}/reports/aws-account-access/{account}/{sunday}/"
    )
    query_result_config = {
        "OutputLocation": report_output_location,
        "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
    }

    response = athena_session.start_query_execution(
        QueryString=query, ResultConfiguration=query_result_config
    )
    return response


def handler(event: dict, context: dict):
    """Lambda handler for AWS access report generation.

    Args:
        event (dict): Event data from the event that triggered the Lambda function
        context (dict): Information about the function, function invocation, and the run
    """
    bucket = os.environ.get("BUCKET_NAME")
    database = os.environ.get("DATABASE_NAME")

    default_query_result_config = {
        "OutputLocation": f"s3://{bucket}/athena-queries/",
        "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
    }
    athena_session = boto3.client("athena")
    conditionally_create_database(athena_session, default_query_result_config, database)

    accounts = get_list_of_accounts(bucket)
    for account in accounts:
        table = conditionally_create_table(
            athena_session, default_query_result_config, bucket, database, account
        )[0]
        regions = get_list_of_regions(bucket, account)
        all_days = set()
        for region in regions:
            days = get_sorted_list_of_logged_days(bucket, account, region)
            conditionally_create_partitions(
                athena_session,
                default_query_result_config,
                database,
                table,
                bucket,
                account,
                region,
                days,
            )
            all_days = all_days.union(days)
        eligible_sundays = get_eligible_report_sundays(all_days)
        existing_sundays = get_existing_report_sundays(bucket, account)
        missing_report_sundays = get_missing_report_sundays(
            existing_sundays, eligible_sundays
        )
        for sunday in missing_report_sundays:
            success = False
            while success != True:
                try:
                    generate_report(
                        athena_session,
                        database,
                        table,
                        bucket,
                        account,
                        sunday,
                        regions,
                    )
                except:
                    print("Ran out of queries. Sleeping and trying again.")
                    time.sleep(3)
                else:
                    success = True


if __name__ == "__main__":
    handler(None, None)
