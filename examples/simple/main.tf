/**
 * ## Usage
 *
 * This example is used by the `TestTerraformSimpleExample` test in `test/terrafrom_aws_simple_test.go`.
 *
 * ## Terraform Version
 *
 * This test was created for Terraform 1.0.8.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

module "s3_bucket_source" {
  source  = "dod-iac/s3-bucket/aws"
  version = "1.0.1"

  name = format("test-src-%s", var.test_name)
  tags = var.tags
}

module "s3_bucket_destination" {
  source  = "dod-iac/s3-bucket/aws"
  version = "1.0.1"

  name = format("test-dst-%s", var.test_name)
  tags = var.tags
}

module "ecs_task_role_iam_policy_document" {
  source = "../../"

  s3_buckets_read  = [module.s3_bucket_source.arn]
  s3_buckets_write = [module.s3_bucket_destination.arn]
}

resource "aws_iam_policy" "ecs_task_role_iam_policy" {
  name        = format("test-ecs-task-role-%s", var.test_name)
  description = format("The policy for %s.", var.test_name)
  policy      = module.ecs_task_role_iam_policy_document.json
}

module "task_role" {
  source  = "dod-iac/ecs-task-role/aws"
  version = "1.0.0"

  name = format("test-%s", var.test_name)
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "task_role" {
  role       = module.task_role.name
  policy_arn = module.ecs_task_role_iam_policy.arn
}
