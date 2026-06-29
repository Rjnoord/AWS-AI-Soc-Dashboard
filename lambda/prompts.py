def build_prompt(parsed, severity, risk_score, mitre):
    return f"""
You are a cloud security operations analyst working in a defensive monitoring environment.

Create a safe, defensive incident summary for an authorized AWS security monitoring system.
Do not provide offensive instructions, exploit steps, evasion techniques, or attack guidance.

Return the response in this format:

Executive Summary:
Briefly explain what happened.

Technical Analysis:
Explain the AWS event in defensive terms.

Business Impact:
Explain why the organization should review this activity.

Recommended Defensive Actions:
- Verify whether the activity was authorized.
- Review CloudTrail history for the user.
- Confirm least-privilege permissions.
- Review MFA and access key usage.
- Escalate to the security team if unauthorized.

Event Details:
Event Name: {parsed["event_name"]}
Severity: {severity}
Risk Score: {risk_score}
MITRE Reference: {mitre}
User: {parsed["user"]}
Source IP: {parsed["source_ip"]}
Region: {parsed["region"]}
Service: {parsed["service"]}
Event Time: {parsed["event_time"]}
"""
