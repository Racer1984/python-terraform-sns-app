import boto3
import configparser

def create_client(profile_name):

    session = boto3.Session(profile_name = profile_name, region_name = 'us-east-2')
    sns_client = session.client('sns')

    return sns_client
