import os
import boto3
import botocore.exceptions

def create_access_key(user_name):
    try:
        # Retrieve AWS credentials from environment variables
        aws_access_key_id = os.environ.get('AWS_ACCESS_KEY_ID')
        aws_secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY')
        aws_region_name = os.environ.get('AWS_REGION')

        # Initialize the IAM client
        iam_client = boto3.client('iam', aws_access_key_id=aws_access_key_id,
                                aws_secret_access_key=aws_secret_access_key,
                                region_name=aws_region_name)

        # Create the access key for the specified IAM user
        response = iam_client.create_access_key(UserName=user_name)

        # Return the access key details
        return response['AccessKey']['AccessKeyId'], response['AccessKey']['SecretAccessKey']
    except botocore.exceptions.ClientError as e:
        error_code = e.response['Error']['Code']
        error_message = e.response['Error']['Message']
        print(f"Error occurred: {error_code} - {error_message}")
        return None, None

if __name__ == "__main__":
    user_name = os.environ.get('AWS_DEFAULT_USERNAME')  
    access_key_id, secret_access_key = create_access_key(user_name)
    if access_key_id and secret_access_key:
        print("Access Key ID:", access_key_id)
        print("Secret Access Key:", secret_access_key)
    else:
        print("Failed to create access key.")
