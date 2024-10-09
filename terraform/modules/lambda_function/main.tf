resource "aws_cloudwatch_log_group" "lambda" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 7
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "LambdaExecutionRole" {
  name               = "${var.function_name}LambdaExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "LambdaPolicy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "LambdaRolePolicy" {
  role   = aws_iam_role.LambdaExecutionRole.id
  policy = data.aws_iam_policy_document.LambdaPolicy.json
}

resource "aws_iam_role_policy_attachment" "additional_policies" {
  count      = length(var.additional_execution_policy_arns)
  role       = aws_iam_role.LambdaExecutionRole.name
  policy_arn = var.additional_execution_policy_arns[count.index]
}

// zip package
data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = var.src_dir
  output_path = "${var.output_path}/${var.function_name}.zip"
}

// lambda function
resource "aws_lambda_function" "fn" {
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  function_name    = var.function_name
  role             = aws_iam_role.LambdaExecutionRole.arn
  handler          = var.handler
  runtime          = var.runtime
  architectures    = var.architectures
  timeout          = var.timeout
  memory_size      = var.memory_size
  environment {
    variables = var.environment_variables
  }
  logging_config {
    log_format = "JSON"
    log_group  = aws_cloudwatch_log_group.lambda.name
  }
  layers = var.lambda_layer_arns
}