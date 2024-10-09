variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function"
  type        = string
}

variable "additional_execution_policy_arns" {
  description = "The ARNs of the additional IAM policies for the Lambda function"
  type        = list(string)
  default     = []
}

variable "src_dir" {
  description = "The source directory for the Lambda function"
  type        = string
}

variable "output_path" {
  description = "The output path for the Lambda function zip package"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
}
variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "architectures" {
  description = "The architectures for the Lambda function"
  type        = list(string)
  default     = ["arm64"]
}

variable "timeout" {
  description = "The timeout for the Lambda function"
  type        = number
  default     = 5
}

variable "memory_size" {
  description = "The memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "The environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_layer_arns" {
  description = "The ARNs of the Lambda layers for the Lambda function"
  type        = list(string)
  default     = []
}