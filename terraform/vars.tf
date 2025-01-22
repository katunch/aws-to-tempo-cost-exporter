variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "tempo_api_token" {
  description = "The Tempo API token"
  type        = string
}

variable "tempo_project_id" {
  description = "The Tempo project ID"
  type        = string
}

variable "monthly_run_cron_expression" {
  description = "The cron expression for the monthly run"
  type        = string
  default     = "cron(20 4 2 * ? *)"
}

variable "tempo_expense_category" {
  description = "The Tempo expense category"
  type        = string
  default     = "AWS"
}

variable "tempo_expense_description" {
  description = "The Tempo expense description, Month and Year will be appended to this"
  type        = string
  default     = "AWS cost report"
}