# Input variables for the single-dev-environment SOC lab deployment.

variable "aws_region" {
  description = "region"
  default     = "us-east-1"
  type        = string

}

# Prefix applied to resource names/tags so this lab's resources are
# identifiable and don't collide with RJ's other AWS lab projects.
variable "project_name" {
  description = "soc-dashboard"
  type        = string
  default     = "soc-dashboard-lab"
}

variable "environment" {
  description = "environment name"
  type        = string
  default     = "dev"
}

# Optional email subscriber for SNS alerts; left null means no email
# subscription is created (see count in sns.tf).
variable "alert_email" {
  type        = string
  description = "email for sns email alerts"
  default     = null
  nullable    = true
}

variable "owner" {
  description = "Resource Owner"
  type        = string
  default     = "rjnoord"
}

# Optional SMS subscriber for SNS alerts; left null means no SMS
# subscription is created (see count in sns.tf).
variable "alert_phone_number" {
  description = "phone number to receive alerts"
  type        = string
  default     = null
  nullable    = true
}
