terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_iam_policy" "costExplorerCostAndUsageReport" {
  name = "CostExplorerCostAndUsageReport"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ce:GetCostAndUsage"
        ],
        Resource = "*"
      }
    ]
  })
}

module "tempoExportFunction" {
  depends_on = [aws_iam_policy.costExplorerCostAndUsageReport]
  source     = "./modules/lambda_function"

  function_name                    = "exportCostExplorerCostAndUsageReportToTempo"
  cloudwatch_log_group_name        = "/aws/lambda/exportCostExplorerCostAndUsageReportToTempo"
  additional_execution_policy_arns = [aws_iam_policy.costExplorerCostAndUsageReport.arn]
  src_dir                          = "../exportCostAndUsageReportFunction"
  output_path                      = "../dist/exportCostAndUsageReportFunction"
  handler                          = "index.handler"
  runtime                          = "nodejs20.x"
  architectures                    = ["arm64"]
  timeout                          = 15
  environment_variables = {
    TEMPO_API_TOKEN = var.tempo_api_token
    TEMPO_PROJECT_ID = var.tempo_project_id
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eventBridgeLambdaInvoke" {
  name = "EventBridgeLambdaInvoke"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition : {
          StringEquals : {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ]
  })
}
data "aws_iam_policy_document" "eventBridgeLambdaInvoke" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      module.tempoExportFunction.arn,
      "${module.tempoExportFunction.arn}:*"
    ]
  }
}
resource "aws_iam_role_policy" "eventBridgeLambdaInvoke" {
  name   = "EventBridgeLambdaInvoke"
  role   = aws_iam_role.eventBridgeLambdaInvoke.name
  policy = data.aws_iam_policy_document.eventBridgeLambdaInvoke.json
}

resource "aws_scheduler_schedule" "exportCostExplorerCostAndUsageReportToTempo" {
  name        = "ExportCostExplorerCostAndUsageReportToTempo"
  description = "Schedule to export the Cost Explorer cost and usage report to Tempo"
  group_name  = "default"

  flexible_time_window {
    mode                      = "FLEXIBLE"
    maximum_window_in_minutes = 60
  }

  schedule_expression = var.monthly_run_cron_expression

  target {
    arn      = module.tempoExportFunction.arn
    role_arn = aws_iam_role.eventBridgeLambdaInvoke.arn
    input    = jsonencode({})
  }
}