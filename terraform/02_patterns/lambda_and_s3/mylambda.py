import json

def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "This Lambda function was triggered by S3",
        }),
    }