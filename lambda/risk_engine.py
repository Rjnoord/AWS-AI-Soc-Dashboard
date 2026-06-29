HIGH_EVENTS = [
    "CreateAccessKey",
    "DeleteTrail",
    "StopLogging",
    "UpdateAssumeRolePolicy",
    "AttachRolePolicy"
]

MEDIUM_EVENTS = [
    "CreateUser",
    "DeleteUser",
    "CreateRole",
    "DeleteRole",
    "AttachUserPolicy"
]


def calculate_risk(event_name):

    if event_name in HIGH_EVENTS:
        return "HIGH",95

    if event_name in MEDIUM_EVENTS:
        return "MEDIUM",70

    return "LOW",30