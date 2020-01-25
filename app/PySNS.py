import boto3
import configparser
import requests

def create_client():

    r = requests.get('http://169.254.169.254/latest/meta-data/iam/security-credentials/AllowSNS_AllowSSM')

    session = boto3.Session(aws_access_key_id = r.json()['AccessKeyId'], aws_secret_access_key = r.json()['SecretAccessKey'], aws_session_token = r.json()['Token'], region_name = 'us-east-2')
    sns_client = session.client('sns')

    return sns_client
