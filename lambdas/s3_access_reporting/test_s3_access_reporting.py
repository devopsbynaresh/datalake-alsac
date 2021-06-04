# To be run via pytest

from datetime import datetime, timedelta

import boto3  # type: ignore
from botocore.stub import Stubber  # type: ignore

import s3_access_reporting as reporting
from unittest import mock


def test_database_creation():
    athena_session = boto3.client("athena", region_name="us-east-1")
    stubber = Stubber(athena_session)

    bucket = "cloudtrail_logs"
    database = "s3_access_reporting"
    query_result_config = {
        "OutputLocation": f"s3://{bucket}/athena-queries/",
        "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
    }

    expected_response = {
        "QueryExecutionId": "aa85d0f6-0169-4e6b-94d3-0630b4da5fef",
        "ResponseMetadata": {
            "RequestId": "b8601614-d636-495d-a51e-24118c3f78d5",
            "HTTPStatusCode": 200,
            "HTTPHeaders": {
                "content-type": "application/x-amz-json-1.1",
                "date": "Sat, 04 Jul 2020 03:33:35 GMT",
                "x-amzn-requestid": "b8601614-d636-495d-a51e-24118c3f78d5",
                "content-length": "59",
                "connection": "keep-alive",
            },
            "RetryAttempts": 0,
        },
    }
    expected_params = {
        "QueryString": f"CREATE DATABASE IF NOT EXISTS {database}",
        "ResultConfiguration": {
            "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
            "OutputLocation": f"s3://{bucket}/athena-queries/",
        },
    }
    stubber.add_response("start_query_execution", expected_response, expected_params)
    with stubber:
        response = reporting.conditionally_create_database(
            athena_session, query_result_config, database
        )

    assert expected_response == response


def test_table_creation():
    athena_session = boto3.client("athena", region_name="us-east-1")
    stubber = Stubber(athena_session)

    bucket = "cloudtrail_logs"
    database = "s3_access_reporting"
    account = "123456789012"
    query_result_config = {
        "OutputLocation": f"s3://{bucket}/athena-queries/",
        "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
    }

    expected_response = {
        "QueryExecutionId": "4ed31011-01aa-4edd-a765-e213c1ec8ccd",
        "ResponseMetadata": {
            "RequestId": "027d2058-5630-4ede-beb0-00e4c4c38de2",
            "HTTPStatusCode": 200,
            "HTTPHeaders": {
                "content-type": "application/x-amz-json-1.1",
                "date": "Sun, 05 Jul 2020 16:03:01 GMT",
                "x-amzn-requestid": "027d2058-5630-4ede-beb0-00e4c4c38de2",
                "content-length": "59",
                "connection": "keep-alive",
            },
            "RetryAttempts": 0,
        },
    }
    expected_params = {
        "QueryString": fr"CREATE EXTERNAL TABLE {database}.{database}_{account} (eventversion STRING,useridentity STRUCT< type:STRING,principalid:STRING,arn:STRING,accountid:STRING,invokedby:STRING,accesskeyid:STRING,userName:STRING,sessioncontext:STRUCT< attributes:STRUCT< mfaauthenticated:STRING,creationdate:STRING>,sessionissuer:STRUCT< type:STRING,principalId:STRING,arn:STRING,accountId:STRING,userName:STRING>>>,eventtime STRING,eventsource STRING,eventname STRING,awsregion STRING,sourceipaddress STRING,useragent STRING,errorcode STRING,errormessage STRING,requestparameters STRING,responseelements STRING,additionaleventdata STRING,requestid STRING,eventid STRING,resources ARRAY<STRUCT< ARN:STRING,accountId:STRING,type:STRING>>,eventtype STRING,apiversion STRING,readonly STRING,recipientaccountid STRING,serviceeventdetails STRING,sharedeventid STRING,vpcendpointid STRING ) PARTITIONED BY (region string, year string, month string, day string) ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde' STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat' LOCATION 's3://{bucket}/AWSLogs/{account}/CloudTrail/';",
        "ResultConfiguration": {
            "EncryptionConfiguration": {"EncryptionOption": "SSE_S3"},
            "OutputLocation": f"s3://{bucket}/athena-queries/",
        },
    }
    stubber.add_response("start_query_execution", expected_response, expected_params)
    with stubber:
        response = reporting.conditionally_create_table(
            athena_session, query_result_config, bucket, database, account
        )[1]

    assert expected_response == response


def test_day_chunks_1():
    days = [
        "2020/06/13",
        "2020/06/12",
        "2020/06/11",
        "2020/06/10",
        "2020/06/09",
        "2020/06/08",
        "2020/06/07",
        "2020/06/06",
        "2020/06/05",
        "2020/06/04",
        "2020/06/03",
        "2020/06/02",
        "2020/06/01",
    ]
    chunk_size = 5
    day_chunks = [
        days[index : index + chunk_size] for index in range(0, len(days), chunk_size)
    ]
    assert day_chunks == [
        ["2020/06/13", "2020/06/12", "2020/06/11", "2020/06/10", "2020/06/09"],
        ["2020/06/08", "2020/06/07", "2020/06/06", "2020/06/05", "2020/06/04"],
        ["2020/06/03", "2020/06/02", "2020/06/01"],
    ]


def test_day_chunks_2():
    days = [
        "2020/06/13",
        "2020/06/12",
        "2020/06/11",
        "2020/06/10",
        "2020/06/09",
        "2020/06/08",
        "2020/06/07",
    ]
    chunk_size = 3
    day_chunks = [
        days[index : index + chunk_size] for index in range(0, len(days), chunk_size)
    ]
    assert day_chunks == [
        ["2020/06/13", "2020/06/12", "2020/06/11"],
        ["2020/06/10", "2020/06/09", "2020/06/08"],
        ["2020/06/07"],
    ]


def test_day_chunks_3():
    base = datetime.strptime("2020/06/30", "%Y/%m/%d")
    days = [(base - timedelta(days=x)).strftime("%Y/%m/%d") for x in range(90)]
    chunk_size = 50
    day_chunks = [
        days[index : index + chunk_size] for index in range(0, len(days), chunk_size)
    ]
    assert len(day_chunks[0]) == 50
    assert len(day_chunks[1]) == 40


def test_datetime_sunday():
    date = "2020/06/14"  # This date is a Sunday
    assert datetime.strptime(date, "%Y/%m/%d").weekday() == 6


def test_get_eligible_report_sundays_1():
    base = datetime.strptime("2020/06/30", "%Y/%m/%d")
    logged_days = [(base - timedelta(days=x)).strftime("%Y/%m/%d") for x in range(90)]
    assert sorted(reporting.get_eligible_report_sundays(logged_days)) == [
        "2020/04/05",
        "2020/04/12",
        "2020/04/19",
        "2020/04/26",
        "2020/05/03",
        "2020/05/10",
        "2020/05/17",
        "2020/05/24",
        "2020/05/31",
        "2020/06/07",
        "2020/06/14",
        "2020/06/21",
        "2020/06/28",
    ]


def test_get_eligible_report_sundays_2():
    logged_days = [
        "2020/05/01",
        "2020/05/02",
        "2020/05/03",
        "2020/05/04",
        "2020/05/05",
        "2020/05/06",
        "2020/05/07",
        "2020/05/08",
        "2020/05/09",
    ]
    assert sorted(reporting.get_eligible_report_sundays(logged_days)) == ["2020/05/03"]


def test_get_eligible_report_sundays_3():
    logged_days = [
        "2020/05/01",
        "2020/05/02",
        "2020/05/03",
        "2020/05/04",
        "2020/05/05",
        "2020/05/06",
        "2020/05/07",
        "2020/05/08",
        "2020/05/09",
        "2020/05/10",
    ]
    assert sorted(reporting.get_eligible_report_sundays(logged_days)) == [
        "2020/05/03",
        "2020/05/10",
    ]


def test_get_missing_report_sundays():
    actual_sundays = {
        "2020/06/14",
        "2020/06/28",
    }
    eligible_sundays = {"2020/06/14", "2020/06/21", "2020/06/28", "2020/07/05"}
    assert reporting.get_missing_report_sundays(actual_sundays, eligible_sundays) == {
        "2020/06/21",
        "2020/07/05",
    }


def test_get_missing_report_sundays_empty_actual():
    actual_sundays = {}
    eligible_sundays = {"2020/06/14", "2020/06/21", "2020/06/28", "2020/07/05"}
    assert reporting.get_missing_report_sundays(actual_sundays, eligible_sundays) == {
        "2020/06/14",
        "2020/06/21",
        "2020/06/28",
        "2020/07/05",
    }


def test_get_missing_report_sundays_empty_eligible():
    actual_sundays = {"2020/06/14", "2020/06/21", "2020/06/28", "2020/07/05"}
    eligible_sundays = set()
    assert (
        reporting.get_missing_report_sundays(actual_sundays, eligible_sundays) == set()
    )


def test_get_dates_from_sunday():
    sunday = "2020/07/05"
    expected_dates = [
        "2020/07/04",
        "2020/07/03",
        "2020/07/02",
        "2020/07/01",
        "2020/06/30",
        "2020/06/29",
        "2020/06/28",
    ]
    assert expected_dates == reporting.get_dates_from_sunday(sunday)
