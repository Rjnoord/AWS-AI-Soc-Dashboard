import json

from parser import parse_event
from risk_engine import calculate_risk
from mitre import get_mitre
from prompts import build_prompt
from bedrock import invoke_bedrock
from notifier import send_notification


def lambda_handler(event, context):

    parsed = parse_event(event)

    severity, risk_score = calculate_risk(
        parsed["event_name"]
    )

    mitre = get_mitre(
        parsed["event_name"]
    )

    prompt = build_prompt(
        parsed,
        severity,
        risk_score,
        mitre
    )

    ai_summary = invoke_bedrock(prompt)

    result = {

        "event_name": parsed["event_name"],

        "severity": severity,

        "risk_score": risk_score,

        "mitre": mitre,

        "user": parsed["user"],

        "source_ip": parsed["source_ip"],

        "region": parsed["region"],

        "ai_summary": ai_summary

    }

    print(json.dumps(result, indent=4))

    send_notification(result)

    return {

        "statusCode": 200,

        "body": json.dumps(result)

    }