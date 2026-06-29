def build_prompt(parsed,risk,score,mitre):

    return f"""

You are a Senior Cloud Security Analyst.

Create an enterprise incident report.

Executive Summary

Technical Analysis

Business Impact

Recommended Actions

Cloud Event

{parsed}

Severity

{risk}

Risk Score

{score}

MITRE

{mitre}

"""