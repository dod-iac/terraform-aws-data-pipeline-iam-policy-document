<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an IAM policy document for use in a data pipeline.

```hcl
module "data_pipeline_iam_policy_document" {
  source = "dod-iac/data-pipeline-iam-policy-document/aws"

  s3_buckets_read  = [module.s3_bucket_source.arn]
  s3_buckets_write = [module.s3_bucket_destination.arn]
}
```

## Testing

Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  Use `TT_TEST_NAME` to run a specific test by name.

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_athena_buckets_results"></a> [athena\_buckets\_results](#input\_athena\_buckets\_results) | The ARNs of the AWS S3 buckets that store the results of Athena queries. Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| <a name="input_athena_buckets_source"></a> [athena\_buckets\_source](#input\_athena\_buckets\_source) | The ARNs of the AWS S3 buckets that store the data being queried through Athena. Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| <a name="input_athena_tables_exec"></a> [athena\_tables\_exec](#input\_athena\_tables\_exec) | A list of the Glue tables that can be read from during execution of Athena queries.  Use ["*"] to allow all tables. | <pre>list(object({<br>    database = string<br>    table    = string<br>  }))</pre> | `[]` | no |
| <a name="input_athena_workgroups_exec"></a> [athena\_workgroups\_exec](#input\_athena\_workgroups\_exec) | The ARNs of the AWS Athena workgroups that can be executed.  Use ["*"] to allow all workgroups. | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_log_groups_write"></a> [cloudwatch\_log\_groups\_write](#input\_cloudwatch\_log\_groups\_write) | The ARNs of the AWS CloudWatch log groups that events can be written into.  Use ["*"] to allow all log groups. | `list(string)` | `[]` | no |
| <a name="input_codecommit_repos_pull"></a> [codecommit\_repos\_pull](#input\_codecommit\_repos\_pull) | The ARNs of the AWS CodeCommit repos that can be pulled.  Use ["*"] to allow all repos. | `list(string)` | `[]` | no |
| <a name="input_codecommit_repos_push"></a> [codecommit\_repos\_push](#input\_codecommit\_repos\_push) | The ARNs of the AWS CodeCommit repos that can be pushed.  Use ["*"] to allow all repos. | `list(string)` | `[]` | no |
| <a name="input_ec2_networkinterfaces_manage"></a> [ec2\_networkinterfaces\_manage](#input\_ec2\_networkinterfaces\_manage) | Allows creating, deleting, and attaching network interfaces. | `bool` | `false` | no |
| <a name="input_ecr_repos_read"></a> [ecr\_repos\_read](#input\_ecr\_repos\_read) | The ARNs of the AWS ECR repos that can be read from.  Use ["*"] to allow all repos. | `list(string)` | `[]` | no |
| <a name="input_ecr_repos_write"></a> [ecr\_repos\_write](#input\_ecr\_repos\_write) | The ARNs of the AWS ECR repos that can be written to.  Use ["*"] to allow all repos. | `list(string)` | `[]` | no |
| <a name="input_ecs_tasks_run"></a> [ecs\_tasks\_run](#input\_ecs\_tasks\_run) | The list of ARNs for ECS task definitions and the ECS clusters where they can be run.  Either clusters or task\_definitions can be set to ["*"] to allow all. | <pre>list(object({<br>    clusters         = list(string)<br>    task_definitions = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_glue_tables_add"></a> [glue\_tables\_add](#input\_glue\_tables\_add) | List of Glue tables that partitions can be added to. | <pre>list(object({<br>    database = string<br>    table    = string<br>  }))</pre> | `[]` | no |
| <a name="input_iam_roles_pass"></a> [iam\_roles\_pass](#input\_iam\_roles\_pass) | The ARNs of the IAM roles that can be passed.  Use ["*"] to allow all roles to be passed. | `list(string)` | `[]` | no |
| <a name="input_kms_keys_decrypt"></a> [kms\_keys\_decrypt](#input\_kms\_keys\_decrypt) | The ARNs of the AWS KMS keys that can be used to decrypt data.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| <a name="input_kms_keys_encrypt"></a> [kms\_keys\_encrypt](#input\_kms\_keys\_encrypt) | The ARNs of the AWS KMS keys that can be used to encrypt data.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| <a name="input_s3_buckets_read"></a> [s3\_buckets\_read](#input\_s3\_buckets\_read) | The ARNs of the AWS S3 buckets that can be read from.  Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| <a name="input_s3_buckets_write"></a> [s3\_buckets\_write](#input\_s3\_buckets\_write) | The ARNs of the AWS S3 buckets that can be written to.  Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| <a name="input_sqs_queues_receive"></a> [sqs\_queues\_receive](#input\_sqs\_queues\_receive) | The ARNs of the AWS SQS queues that messages can be received from.  Also grants the permission to delete messages.  Use ["*"] to allow all queues. | `list(string)` | `[]` | no |
| <a name="input_sqs_queues_send"></a> [sqs\_queues\_send](#input\_sqs\_queues\_send) | The ARNs of the AWS S3 queues that messages can be sent to.  Use ["*"] to allow all queues. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_json"></a> [json](#output\_json) | The rendered JSON of the policy document. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
