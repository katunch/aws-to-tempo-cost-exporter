AWS Cost Exporter to Tempo Financial Manager
==========================
![Overview](./docs/overview.jpg#gh-dark-mode-only)
![Overview](./docs/overview-light.jpg#gh-light-mode-only)


This project automates the export of AWS account costs for the previous month, leveraging AWS Lambda and EventBridge Scheduler. It simplifies cost tracking by integrating with Tempo’s Financial Manager (Cost Tracker), allowing you to effortlessly post your AWS expenses each month.

## How It Works

1.	**Monthly Automation**: An AWS Lambda function is triggered once a month by EventBridge Scheduler.
2.	**Cost Retrieval**: The function uses the AWS Cost Explorer API to retrieve the total costs from the previous month.
3.	**Data Sync**: Once the cost is fetched, it’s automatically posted to the Tempo API, streamlining your expense management.

Built with Terraform for seamless infrastructure provisioning, this solution is ideal for anyone looking to automate AWS cost tracking and integrate it with Tempo’s financial tools.

# Prerequisites

- [Terraform](https://terraform.io)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Of course one or more AWS Accounts to deploy this solution
- [Tempo API Key](https://help.tempo.io/timesheets/latest/using-rest-api-integrations)
- Cost Tracker Project ID
- [NodeJs 20.x](https://nodejs.org/en/download/package-manager)

# Installation

1. Clone this repo and `cd` into it.
2. Open the folder with your favourite Code editor.
3. Create a file `terraform/terraform.tfvars` and fill all [needed Variables](./Terraform.md#inputs)
4. `cd exportCostAndUsageReportFunction && npm i --omit=dev && cd ..`
5. `cd terraform`
6. If you feel confident run `terraform apply -auto-approve`. (Not recommended!)



