import json
print("loading function")

def lambda_handler(event, context):
    print("Event:", event)
    print("Context:", context.invoked_function_arn, context.memory_limit_in_mb)
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
        }),
    }