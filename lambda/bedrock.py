import json
import os
import boto3

bedrock = boto3.client(
    "bedrock-runtime",
    region_name=os.environ.get("AWS_REGION", "us-east-1")
)

MODEL_ID = os.environ.get(
    "MODEL_ID",
    "amazon.nova-lite-v1:0"
)


def invoke_bedrock(prompt):

    response = bedrock.invoke_model(
        modelId=MODEL_ID,
        body=json.dumps({
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "text": prompt
                        }
                    ]
                }
            ]
        })
    )

    body = json.loads(response["body"].read())

    return body["output"]["message"]["content"][0]["text"]