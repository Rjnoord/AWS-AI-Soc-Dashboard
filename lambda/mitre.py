MITRE_MAP = {

    "CreateAccessKey":"T1098 Account Manipulation",

    "CreateUser":"T1136 Create Account",

    "DeleteTrail":"T1562 Impair Defenses",

    "StopLogging":"T1562 Impair Defenses",

    "AttachRolePolicy":"T1098 Account Manipulation"

}

def get_mitre(event):

    return MITRE_MAP.get(event,"Unknown")