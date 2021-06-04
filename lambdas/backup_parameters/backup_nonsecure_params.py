import boto3, os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    ssm = boto3.client('ssm')

    # Enumerate all non-SecureString parameters
    response = ssm.describe_parameters(
        ParameterFilters=[{
            'Key': 'Type',
            'Values': ['String', 'StringList']
        }]
    )['Parameters']

    # Get Parameter names, types, and values
    names = [item['Name'] for item in response]
    params = ssm.get_parameters(Names=names,WithDecryption=False)['Parameters']
    types = [param['Type'] for param in params]
    values = [param['Value'] for param in params]

    # Put parameters from primary region to DR region
    ssm_dr = boto3.client('ssm', region_name=os.environ['DR_REGION'])
    for n,t,v in zip(names,types,values):
        try:
            ssm_dr.put_parameter(
                Name=n, Value=v, Type=t,
                Tags = [{'Key': 'ProjectTeam','Value': 'datalake'},{'Key': 'Environment','Value': 'dev'}]
            )
        except ClientError as e:
            if e.response['Error']['Code'] == 'ParameterAlreadyExists':
                ssm_dr.put_parameter(
                    Name=n, Value=v, Type=t, Overwrite=True
                )
