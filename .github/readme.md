# 🛡️ AI-Powered AWS SOC Dashboard
> Event-Driven Cloud Security Monitoring with Terraform, EventBridge, CloudTrail, Lambda, Amazon Bedrock, SNS, and GitHub Actions

---

# Project Overview

This project demonstrates how to build a fully automated cloud-native Security Operations Center (SOC) monitoring platform inside AWS using Infrastructure as Code (Terraform), serverless computing, and generative AI.

Instead of manually reviewing CloudTrail logs for suspicious IAM activity, this solution continuously monitors AWS account activity, detects high-value security events in real time, enriches those events with MITRE ATT&CK mappings and AI-generated incident summaries, and automatically notifies security analysts via Amazon SNS.

The entire environment is deployed using Terraform and validated through a GitHub Actions CI/CD pipeline.

This project demonstrates many of the same architectural patterns used by enterprise cloud security teams.

---

# Architecture

```
                AWS CloudTrail
                       │
                       ▼
          IAM API Activity (CreateUser, DeleteUser, etc.)
                       │
                       ▼
               Amazon EventBridge
               Event Pattern Filter
                       │
                       ▼
                AWS Lambda Function
        ┌────────────────────────────────────┐
        │                                    │
        │ Parse CloudTrail Event             │
        │ MITRE ATT&CK Mapping               │
        │ Risk Scoring                       │
        │ Amazon Bedrock AI Summary          │
        │ Create Incident Report             │
        │ Publish Notification               │
        │                                    │
        └────────────────────────────────────┘
                       │
                       ▼
                  Amazon SNS
                       │
                       ▼
               Email Notification

```

---

# Technologies Used

| Service | Purpose |
|----------|----------|
| Terraform | Infrastructure as Code |
| AWS Lambda | Serverless incident processor |
| Amazon EventBridge | Event routing |
| AWS CloudTrail | API activity logging |
| Amazon SNS | Security notifications |
| Amazon Bedrock | AI-generated incident summaries |
| IAM | Security permissions |
| CloudWatch Logs | Lambda logging |
| GitHub Actions | CI/CD pipeline |
| Python | Lambda runtime |
| JSON | Event processing |

---

# Project Objectives

The goal of this project was to automate AWS security monitoring by building a cloud-native SOC workflow capable of:

- Detecting privileged IAM activity
- Parsing CloudTrail events
- Assigning risk scores
- Mapping events to MITRE ATT&CK
- Generating AI incident summaries
- Sending real-time security alerts
- Deploying everything with Terraform
- Validating infrastructure through CI/CD

---

# Infrastructure Provisioned with Terraform

Terraform provisions the complete environment including:

## IAM

- Lambda Execution Role
- IAM Policies
- Bedrock permissions
- SNS permissions
- CloudWatch permissions

---

## CloudTrail

CloudTrail captures management events including:

- CreateUser
- DeleteUser
- CreateAccessKey
- DeleteAccessKey
- AttachUserPolicy
- DetachUserPolicy
- PutRolePolicy
- DeleteRolePolicy

These events become the foundation of the SOC monitoring platform.

---

## S3

CloudTrail logs are securely stored inside an S3 bucket configured with:

- Versioning
- Server-side encryption
- Public access block
- Bucket policies

---

## EventBridge

EventBridge continuously monitors CloudTrail events and filters only high-value IAM activity.

Example Event Pattern:

```json
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventName": [
      "CreateUser",
      "DeleteUser",
      "CreateAccessKey",
      "DeleteAccessKey",
      "AttachUserPolicy",
      "DetachUserPolicy"
    ]
  }
}
```

---

## Lambda

The Lambda function performs several security automation tasks.

### Step 1

Receive EventBridge event

↓

### Step 2

Extract CloudTrail fields

↓

### Step 3

Determine severity

↓

### Step 4

Calculate risk score

↓

### Step 5

Map MITRE ATT&CK technique

↓

### Step 6

Generate AI Incident Report

↓

### Step 7

Publish notification to SNS

---

# Python Components

The Lambda package consists of several Python modules.

## app.py

Primary Lambda handler.

Responsibilities:

- Receive EventBridge event
- Coordinate processing
- Generate final report
- Publish notification

---

## parser.py

Responsible for parsing CloudTrail events.

Extracts:

- Event Name
- User
- Source IP
- Region
- Event Time
- AWS Service
- Request Parameters

---

## risk_engine.py

Assigns severity levels and numerical risk scores.

Example:

| Event | Severity | Score |
|---------|-----------|---------|
| CreateUser | Medium | 70 |
| DeleteUser | High | 90 |
| CreateAccessKey | Critical | 95 |

---

## mitre.py

Maps AWS IAM activity to MITRE ATT&CK.

Example:

| AWS Event | MITRE Technique |
|------------|----------------|
| CreateUser | T1136 Create Account |
| CreateAccessKey | T1098 Account Manipulation |
| AttachUserPolicy | T1098 Account Manipulation |

---

## bedrock.py

Communicates with Amazon Bedrock.

Responsibilities:

- Build AI prompt
- Send prompt
- Receive AI summary
- Return defensive incident report

---

## notifier.py

Formats security alerts and publishes them through Amazon SNS.

---

## prompts.py

Contains carefully designed prompts instructing Amazon Bedrock to generate defensive cloud security incident reports.

---

# AI Incident Summary

Amazon Bedrock generates:

- Executive Summary
- Technical Analysis
- Business Impact
- Defensive Recommendations

Rather than returning offensive security guidance, the prompts were intentionally engineered to focus on:

- Incident response
- Security operations
- Compliance
- Defensive cloud security

---

# CI/CD Pipeline

Every push to GitHub automatically executes:

```
Checkout Repository

↓

Package Lambda

↓

Terraform Format

↓

Terraform Init

↓

Terraform Validate

↓

Terraform Plan
```

This ensures infrastructure changes are validated before deployment.

---

# Security Features

## Automated Threat Detection

Detects:

- New IAM Users
- Deleted Users
- New Access Keys
- Deleted Access Keys
- Policy Changes
- Privilege Escalation Indicators

---

## AI Incident Reporting

Instead of manually reviewing JSON CloudTrail logs, analysts receive:

- Human-readable summaries
- Risk scores
- MITRE mappings
- Defensive recommendations

---

## Real-Time Email Alerts

Amazon SNS distributes security notifications immediately after detection.

Example:

```
[MEDIUM] AWS Security Alert

Event:
CreateUser

Severity:
Medium

Risk Score:
70

MITRE:
T1136 Create Account

User:
john-admin

Source IP:
24.xxx.xxx.xxx

Region:
us-east-1

AI Summary:
An IAM user was created.
Verify authorization, review CloudTrail history,
validate least privilege, and investigate if unexpected.
```

---

# Lessons Learned

This project provided hands-on experience with:

- Event-driven architecture
- Infrastructure as Code
- Terraform modules
- IAM permissions
- CloudTrail event structure
- EventBridge rule creation
- Lambda deployment
- Packaging Python applications
- GitHub Actions CI/CD
- Amazon Bedrock integration
- SNS notifications
- CloudWatch logging
- Security automation
- Incident response workflows

One of the biggest challenges involved debugging EventBridge triggers, Lambda packaging, Terraform resource dependencies, and SNS notification delivery. Working through each issue reinforced the importance of iterative testing, log analysis, and understanding how AWS services communicate within an event-driven architecture.

---

# Future Improvements

Potential enhancements include:

- Slack integration
- Microsoft Teams notifications
- Security Hub integration
- GuardDuty findings ingestion
- DynamoDB incident storage
- Incident history dashboard
- Analyst web interface
- Multi-account monitoring
- AWS Organizations support
- OpenSearch log analytics
- Step Functions orchestration
- Automated ticket creation
- SOAR playbooks
- SIEM integration
- Security score dashboards

---

# Skills Demonstrated

- AWS
- Terraform
- Infrastructure as Code
- Python
- Cloud Security
- IAM
- EventBridge
- CloudTrail
- Lambda
- Amazon SNS
- Amazon Bedrock
- GitHub Actions
- CI/CD
- CloudWatch
- Security Automation
- MITRE ATT&CK
- Incident Response
- Serverless Architecture
- Event-Driven Design

---

# Key Takeaways

This project demonstrates how modern cloud security teams can automate incident detection and response using AWS native services.

Rather than relying on manual log review, the platform continuously monitors privileged IAM activity, enriches events with contextual intelligence, generates AI-powered incident summaries, and delivers actionable alerts to security analysts in near real time. By combining Infrastructure as Code, serverless computing, event-driven architecture, and generative AI, the solution showcases practical cloud security engineering skills aligned with enterprise DevSecOps and Security Operations Center (SOC) workflows.