<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

This example is used by the `TestTerraformEncryptedExample` test in `test/terrafrom_aws_encrypted_test.go`.

## Terraform Version

This test was created for Terraform 1.0.8.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_task_role_iam_policy_document"></a> [ecs\_task\_role\_iam\_policy\_document](#module\_ecs\_task\_role\_iam\_policy\_document) | ../../ | n/a |
| <a name="module_s3_bucket_destination"></a> [s3\_bucket\_destination](#module\_s3\_bucket\_destination) | dod-iac/s3-bucket/aws | 1.0.1 |
| <a name="module_s3_bucket_source"></a> [s3\_bucket\_source](#module\_s3\_bucket\_source) | dod-iac/s3-bucket/aws | 1.0.1 |
| <a name="module_s3_kms_key"></a> [s3\_kms\_key](#module\_s3\_kms\_key) | dod-iac/s3-kms-key/aws | 1.0.1 |
| <a name="module_task_role"></a> [task\_role](#module\_task\_role) | dod-iac/ecs-task-role/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.ecs_task_role_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_test_name"></a> [test\_name](#input\_test\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
| <a name="output_test_name"></a> [test\_name](#output\_test\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
