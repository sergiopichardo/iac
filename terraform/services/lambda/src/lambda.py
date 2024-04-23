import json
print("loading function")

def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    print("value 1 = " + event['key1'])
    print("value 2 = " + event['key2'])
    print("value 3 = " + event['key3'])
    return event['key1']     # Echo back the first key value
    # raise Exception('Something went wrong') 