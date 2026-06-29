import boto3
import os

sns = boto3.client("sns")

SNS_TOPIC = os.environ["SNS_TOPIC_ARN"]


def send_notification(result):

    subject = f"[{result['severity']}] AWS Security Alert"

    message = f"""
🚨 AWS AI SOC Alert

Event:
{result['event_name']}

Severity:
{result['severity']}

Risk Score:
{result['risk_score']}

MITRE Technique:
{result['mitre']}

User:
{result['user']}

Source IP:
{result['source_ip']}

Region:
{result['region']}

AI Incident Report

{result['ai_summary']}
"""

    sns.publish(
        TopicArn=SNS_TOPIC,
        Subject=subject,
        Message=message
    )
    