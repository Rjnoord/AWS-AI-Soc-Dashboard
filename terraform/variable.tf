variable "aws_region" {
  description = "region"
  default     = "us-east-1"
  type        = string

}

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

variable "alert_phone_number" {
  description = "phone number to receive alerts"
  type        = string
  default     = null
  nullable    = true
}
