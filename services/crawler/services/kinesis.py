import json
import uuid
from typing import List, Dict, Any
import os
import logging

from concurrent.futures import ThreadPoolExecutor

import boto3
# from aws_xray_sdk.core import patch_all

logger = logging.getLogger(__name__)
if os.getenv('STAGE') == 'dev':
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.INFO)


client = boto3.client('kinesis', region_name='eu-west-1')
# apply the XRay handler to all clients.
# patch_all()


def put_records_kinesis(records: List[Dict[str, Any]]):
    return client.put_records(
        Records=[{
            'Data': json.dumps(records),
            'PartitionKey': str(uuid.uuid4())
        } for record in records],
        StreamName=os.getenv('KINESIS_POSTS_STREAM_NAME', 'reddit-crawler-prod-posts-stream')
    )


def put_record(record: Dict[str, Any]):
    return client.put_record(
        StreamName=os.getenv('KINESIS_POSTS_STREAM_NAME', 'reddit-crawler-prod-posts-stream'),
        Data=json.dumps(record),
        PartitionKey=str(uuid.uuid4())
    )
