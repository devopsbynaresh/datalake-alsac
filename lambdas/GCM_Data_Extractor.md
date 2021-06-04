# GCM Data Extractor

The GCM Data Extractor is a set of AWS Lambdas for extracting data from Google's Campaign Manager into the ALSAC AWS Data Lake.  It uses a configured Google Service Account to access the Campaign Manager APIs.

## Project Setup

GCM Data Extractor is written in Python.  It is recommended you set up a Virtual Environment for doing development.  A `requirements_gcm.txt` is include with required libraries for development, and the currently in use libraries are listed in `freeze_gcm.txt`.

1. Git clone to your development environment, and `cd` to project directory.
1. Create the Python Virtual Environment.  The second `venv` is the folder to hold your VEnv.

    ```console
    $ py -m venv venv
    ```

1. Activate the VEnv.

    ```console
    $ .\venv\Scripts\activate
    ```

1. Install required libraries.  To install exactly the same libraries as previously developed with, use `freeze_gcm.txt` instead of `requirements_gcm.txt`.

    ```console
    $ pip install --upgrade -r requirements.txt
    ```

1. (Optional) Update current libraries saved.

    ```console
    $ pip freeze > freeze.txt
    ```

## Configuration.py

Most environment configuration occurs in this file.  The `DEPLOYED` constant allows you to test locally by changing from `AWS` to `LOCAL`.

When running the application locally for testing, all parameters and downloads will be stored in the `resources` folder.  You will need to put the Service Account's JSON credentials in `resources\parameters\service-account.json`.

## Lambdas

All Lambdas are able to be invoked locally for testing through the `main` methods, and by the Lambda runtime through the `lambda_handler` methods.

### Monitor

Monitor is responsible for loading available reports from the GCM API.  It is scheduled to run hourly through AWS CloudWatch.  Any newly available reports will be sent to the Download Lambda via SNS. 

### Download

Download is responsible for downloading report files from GCM to Lambda-local temp space, uploading them to AWS S3 Buckets for landing, then moving them from the landing area to the raw area.

### Process

Process is responsible for converting the raw GCM report files into curated, partitioned, compressed parquet files.  It is triggered by a raw S3 bucket notification sent to an SNS topic. It reads the GCM CSV report files, stripping out headers and footers, validates the report matches the expected schema, and saves the parquet files to Lambda-local temp space.  Once the entire report is validated and converted, Process uploads them to the structured staging area, removes existing updated partitions, and moves newly created partitions into place. 

### Extract

Extract is run manually to set up the required information for the GCM Data Extractor.  It takes in two values: the name you'd like to give to the extracted dataset, and the GCM report ID you'd like to use as a template.  When run, Extract will:

1. Check if a dataset with this name already exists, and fail if so.
1. Load the existing report as a template.
1. Make a copy of the template, changing the date range to be a day ~1.5 weeks in the past.
1. Run this new initial report.
1. Wait for up to 5 minutes for the report to complete.  If the report does not complete in time, rerunning the Extract Lambda with the same parameters will pick up here.
1. Download this initial report, saving ONLY the schema as a parameter.  All future reports will be validated against this schema during Processing.
1. Update the initial report to do a history pull, starting on Jan/01/2020, and execute this report once.
1. Copy the initial report a second time, setting it up to run on the last two weeks of data, and scheduling it to run daily.
1. Finally, the two new report IDs will be saved in the parameter used by the Monitor Lambda to pick up new data.

## Additional Support files

### Test.py

Test.py is useful for local testing of curated data.  Given a dataset, it loads all parquet data into a single dataframe, prints out the number of entries per Date, and dumps all data into a single CSV file with the same name as the dataset.

### Delete_report.py

Delete_report.py is useful for deleting GCM report copies created during testing.  Given a report ID, it will load all current reports, then attempt to delete the ID given.

## Deployment

AWS Lambdas for the GCM data ingestion are packaged in the same .zip file.  Use the provided `compress_lambda_packages.sh` or `compress_lambda_packages.bat` to package the source code files.

The Terraform scripts included will cover the initial deployment of code, and the Extract lambda can be used to set up datasets to be extracted.  **Terraform will NOT create the required service-account parameter.**

## Deployed Info

### Parameters

In AWS, parameters are stored in the AWS Parameter Store (SSM) under the hierarchy `/data-lake/data-extractor/gcm/`.  Locally, parameters are stored in files under `resources\parameters\`.

#### service-account

This is the JSON credentials for the Google Service Account.  **This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a SecureString in Parameter Store, and is only a dummy file in the Git Repo.

#### report-info

This parameter stores the dataset name to report IDs for Monitor Lambda to check for available report files.  It is updated by the Extract Lambda.

#### \<dataset>-dtypes

This parameter stores the schema to validate against for the Process Lambda.  It is created by the Extract Lambda.

### Storage Folder structure

#### AWS
* `<RAW>:temp/gcm/<dataset>/<report_file>`
* `<RAW>:gcm/<dataset>/<report_file>`
* `<STRUCTURED>:temp/gcm/<dataset>/<UUID>/date=<partition>/<parquet_files>`
* `<STRUCTURED>:gcm/<dataset>/date=<partition>/<parquet_files>`

#### Local
* `resources\downloads\landing\<dataset>\<report_file>`
* `resources\downloads\raw\<dataset>\<report_file>`
* `resources\downloads\curated\staging\<dataset>\<UUID>\Date=<partition>\<parquet_files>`
* `resources\downloads\curated\<dataset>\Date=<partition>\<parquet_files>`
