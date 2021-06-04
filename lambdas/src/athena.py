import boto3

def handler(event, context):
    # Get S3 datastore, Glue database, and Glue table from event passed from the Process Lambda
    s3_location = event['s3_location']
    database = event['database']
    table = event['table']
    output_location = event['output_location']

    # Run repair query to load partition metadata into Glue table
    athena = boto3.client('athena')
    config = {'OutputLocation': output_location, 'EncryptionConfiguration': {'EncryptionOption': 'SSE_S3'}}
    sql = 'MSCK REPAIR TABLE ' + database + '.' + table
    context = {'Database': database}
    athena.start_query_execution(QueryString = sql, QueryExecutionContext = context, ResultConfiguration = config)
    return "Partitions loaded in " + database + "." + table + "successfully."

