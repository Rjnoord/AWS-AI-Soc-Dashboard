import os

# ==============================
# AWS Configuration
# ==============================

AWS_REGION = os.environ.get("AWS_REGION", "us-east-1")

MODEL_ID = os.environ.get(
    "MODEL_ID",
    "amazon.nova-lite-v1:0"
)

SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")


# ==============================
# Risk Scores
# ==============================

RISK_SCORES = {
    "HIGH": 95,
    "MEDIUM": 70,
    "LOW": 30
}


# ==============================
# High Severity Events
# ==============================

HIGH_RISK_EVENTS = [
    "CreateAccessKey",
    "DeleteTrail",
    "StopLogging",
    "UpdateAssumeRolePolicy",
    "AttachRolePolicy",
    "PutRolePolicy",
    "CreatePolicyVersion",
    "SetDefaultPolicyVersion",
    "DeletePolicyVersion",
    "CreateLoginProfile",
    "ConsoleLogin"
]


# ==============================
# Medium Severity Events
# ==============================

MEDIUM_RISK_EVENTS = [
    "CreateUser",
    "DeleteUser",
    "CreateRole",
    "DeleteRole",
    "AttachUserPolicy",
    "DetachUserPolicy",
    "DetachRolePolicy",
    "CreatePolicy",
    "DeletePolicy",
    "UpdateUser",
    "UpdateRole"
]


# ==============================
# Low Severity Events
# ==============================

LOW_RISK_EVENTS = [
    "ListUsers",
    "ListRoles",
    "GetUser",
    "GetRole"
]


# ==============================
# MITRE ATT&CK Mapping
# ==============================

MITRE_MAP = {

    "CreateAccessKey": "T1098 - Account Manipulation",

    "AttachRolePolicy": "T1098 - Account Manipulation",

    "AttachUserPolicy": "T1098 - Account Manipulation",

    "UpdateAssumeRolePolicy": "T1098 - Account Manipulation",

    "CreateUser": "T1136 - Create Account",

    "DeleteUser": "T1531 - Account Access Removal",

    "DeleteTrail": "T1562 - Impair Defenses",

    "StopLogging": "T1562 - Impair Defenses",

    "CreatePolicyVersion": "T1484 - Domain or Policy Modification",

    "SetDefaultPolicyVersion": "T1484 - Domain or Policy Modification",

    "ConsoleLogin": "T1078 - Valid Accounts"
}


# ==============================
# Dashboard Metadata
# ==============================

PROJECT_NAME = "AWS AI SOC Dashboard"

VERSION = "1.0.0"

AUTHOR = "Robert Noord Jr."


# ==============================
# Bedrock Prompt Configuration
# ==============================

MAX_RESPONSE_TOKENS = 1000

TEMPERATURE = 0.2

TOP_P = 0.9