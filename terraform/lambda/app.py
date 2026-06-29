import json
import os


def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "SOC incident processor placeholder",
                "sns_topic_arn": os.getenv("SNS_TOPIC_ARN", ""),
                "received_event": event,
            }
        ),
    }
