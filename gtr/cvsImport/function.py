import os
import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    redis_server = os.environ['DS_ADDR']
    redis_pass = os.environ['DS_PASS']
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        data = response['Body'].read().decode('utf-8')
        strings = data.split("\n")
        for s in strings:
            a = s.split(';')
            k = a[0]
            v = a[1:].join(';')

    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
