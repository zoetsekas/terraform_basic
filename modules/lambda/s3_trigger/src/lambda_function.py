import os
import json
import boto3

business_kinesis = os.environ["business_stream"]
operational_kinesis = os.environ["operational_stream"]


def lambda_handler(event, context):
    data_response = serialize_event_data(event)
    html_body=json.dumps(data_response)

    client = boto3.client('kinesis')

    response = client.put_record(
    StreamName=business_kinesis,
    Data=html_body,
    PartitionKey="partitionkey")

    response2 = client.put_record(
    StreamName=operational_kinesis,
    Data=html_body,
    PartitionKey="partitionkey")


def serialize_event_data(json_data):
    """
    Extract data from s3 event
    Args:
        json_data ([type]): Event JSON Data
    """
    bucket = json_data["Records"][0]["s3"]["bucket"]["name"]
    timestamp = json_data["Records"][0]["eventTime"]
    s3_key = json_data["Records"][0]["s3"]["object"]["key"]
    s3_data_size = json_data["Records"][0]["s3"]["object"]["size"]
    ip_address = json_data["Records"][0]["requestParameters"][
        "sourceIPAddress"]
    event_type = json_data["Records"][0]["eventName"]
    owner_id = json_data["Records"][0]["s3"]["bucket"]["ownerIdentity"][
        "principalId"]
    
    return_json_data = {
        "event_timestamp": timestamp,
        "bucket_name": bucket,
        "object_key": s3_key,
        "object_size": s3_data_size,
        "source_ip": ip_address,
        "event_type": event_type,
        "owner_identity": owner_id
    }

    return return_json_data