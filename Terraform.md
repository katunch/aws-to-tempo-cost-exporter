## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tempoExportFunction"></a> [tempoExportFunction](#module\_tempoExportFunction) | ./modules/lambda_function | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.costExplorerCostAndUsageReport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eventBridgeLambdaInvoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eventBridgeLambdaInvoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_scheduler_schedule.exportCostExplorerCostAndUsageReportToTempo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eventBridgeLambdaInvoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"eu-central-1"` | no |
| <a name="input_monthly_run_cron_expression"></a> [monthly\_run\_cron\_expression](#input\_monthly\_run\_cron\_expression) | The cron expression for the monthly run | `string` | `"cron(20 4 2 * ? *)"` | no |
| <a name="input_tempo_api_token"></a> [tempo\_api\_token](#input\_tempo\_api\_token) | The Tempo API token | `string` | n/a | yes |
| <a name="input_tempo_project_id"></a> [tempo\_project\_id](#input\_tempo\_project\_id) | The Tempo project ID | `string` | n/a | yes |

## Outputs

No outputs.
