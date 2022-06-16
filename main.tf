/**
 * ## Usage
 *
 * Creates an IAM policy document for use in a data pipeline.
 *
 * ```hcl
 * module "data_pipeline_iam_policy_document" {
 *   source = "dod-iac/data-pipeline-iam-policy-document/aws"
 *
 *   s3_buckets_read  = [module.s3_bucket_source.arn]
 *   s3_buckets_write = [module.s3_bucket_destination.arn]
 * }
 * ```
 *
 * ## Testing
 *
 * Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  Use `TT_TEST_NAME` to run a specific test by name.
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "main" {

  #
  # EC2 / Manage Network Interfaces
  #

  dynamic "statement" {
    for_each = var.ec2_networkinterfaces_manage ? [1] : []
    content {
      sid = "ManageNetworkInterface"
      actions = [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ]
      resources = ["*"]
    }
  }

  #
  # ECS / Run Task
  #

  dynamic "statement" {
    for_each = length(var.ecs_tasks_run) > 0 ? [1] : []
    content {
      sid = "RunTask"
      actions = [
        "ecs:RunTask"
      ]
      resources = contains(var.ecs_tasks_run[count.index].task_definitions, "*") ? ["*"] : var.ecs_tasks_run[count.index].task_definitions
      dynamic "condition" {
        for_each = contains(var.ecs_tasks_run[count.index].ecs_clusters, "*") ? [] : [1]
        content {
          test     = "ArnEquals"
          variable = "ecs:Cluster"
          values   = var.ecs_tasks_run[count.index].ecs_clusters
        }
      }
    }
  }

  #
  # IAM / Pass Role
  #

  dynamic "statement" {
    for_each = length(var.iam_roles_pass) > 0 ? [1] : []
    content {
      sid = "PassRole"
      actions = [
        "iam:PassRole"
      ]
      resources = var.iam_roles_pass
    }
  }

  #
  # KMS / DecryptObjects
  #

  dynamic "statement" {
    for_each = length(var.kms_keys_decrypt) > 0 ? [1] : []
    content {
      sid = "DecryptObjects"
      actions = [
        "kms:ListAliases",
        "kms:Decrypt",
      ]
      effect    = "Allow"
      resources = var.kms_keys_decrypt
    }
  }

  #
  # KMS / EncryptObjects
  #

  dynamic "statement" {
    for_each = length(var.kms_keys_encrypt) > 0 ? [1] : []
    content {
      sid = "EncryptObjects"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      effect    = "Allow"
      resources = var.kms_keys_encrypt
    }
  }

  #
  # S3 / ListBucket
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.s3_buckets_read, var.s3_buckets_write]))) > 0 ? [1] : []
    content {
      sid = "ListBucket"
      actions = [
        "s3:GetBucketLocation",
        "s3:GetBucketRequestPayment",
        "s3:GetEncryptionConfiguration",
        "s3:ListBucket",
      ]
      effect = "Allow"
      resources = sort(distinct(flatten([
        var.s3_buckets_read,
        var.s3_buckets_write
      ])))
    }
  }

  #
  # S3 / GetObject
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_read) > 0 ? [1] : []
    content {
      sid = "GetObject"
      actions = [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:GetObjectVersion",
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.s3_buckets_read)
    }
  }

  #
  # S3 / ListBucketMultipartUploads
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_write) > 0 ? [1] : []
    content {
      sid = "ListBucketMultipartUploads"
      actions = [
        "s3:ListBucketMultipartUploads",
      ]
      effect    = "Allow"
      resources = var.s3_buckets_write
    }
  }

  #
  # S3 / PutObject
  #

  dynamic "statement" {
    for_each = length(var.s3_buckets_write) > 0 ? [1] : []
    content {
      sid = "PutObject"
      actions = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.s3_buckets_write)
    }
  }

  #
  # Glue / CreatePartition
  #

  dynamic "statement" {
    for_each = length(var.glue_tables_add) > 0 ? [1] : []
    content {
      sid = "CreatePartition"
      actions = [
        "glue:BatchCreatePartition",
        "glue:CreatePartition"
      ]
      effect = "Allow"
      resources = flatten([
        formatlist(
          format(
            "arn:%s:glue:%s:%s:table/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id,
          ),
          sort([for table in var.glue_tables_add : format("%s/%s", table.database, table.table)])
        ),
        formatlist(
          format(
            "arn:%s:glue:%s:%s:database/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id,
          ),
          sort(distinct([for table in var.glue_tables_add : table.database]))
        ),
        format(
          "arn:%s:glue:%s:%s:catalog",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id,
        )
      ])
    }
  }

  #
  # Athena / GetTable
  #

  dynamic "statement" {
    for_each = length(var.athena_tables_exec) > 0 ? [1] : []
    content {
      sid = "GetTable"
      actions = [
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetPartitions",
        "glue:GetPartition"
      ]
      effect = "Allow"
      resources = sort(flatten([
        [
          format("arn:%s:glue:%s:%s:catalog",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id
          )
        ],
        formatlist(
          format("arn:%s:glue:%s:%s:database/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id
          ),
          sort(distinct([for table in var.athena_tables_exec : table.database]))
        ),
        formatlist(
          format("arn:%s:glue:%s:%s:table/%%s",
            data.aws_partition.current.partition,
            data.aws_region.current.name,
            data.aws_caller_identity.current.account_id
          ),
          sort([for table in var.athena_tables_exec : format("%s/%s", table.database, table.table)])
        )
      ]))
      condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:CalledVia"
        values   = ["athena.amazonaws.com"]
      }
    }
  }

  #
  # Athena / AthenaExecuteQuery
  #

  dynamic "statement" {
    for_each = length(var.athena_workgroups_exec) > 0 ? [1] : []
    content {
      sid = "AthenaExecuteQuery"
      actions = [
        # Submit Query and Retrieve Results
        "athena:GetQueryExecution",
        "athena:GetQueryResults",
        "athena:GetQueryResultsStream",
        "athena:StartQueryExecution",
        "athena:StopQueryExecution",
        # List previous queries for the workgroup
        "athena:ListQueryExecutions",
        "athena:BatchGetQueryExecution", # used by History tab
        # List saved queries
        "athena:ListNamedQueries",
        "athena:BatchGetNamedQuery", # used by Saved queries tab
        "athena:GetNamedQuery",      # used by Saved queries tab
        # Create a named query
        "athena:CreateNamedQuery"
      ]
      effect    = "Allow"
      resources = var.athena_workgroups_exec
    }
  }

  #
  # Athena / AthenaCheckBucket
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.athena_buckets_source, var.athena_buckets_results]))) > 0 ? [1] : []
    content {
      sid = "AthenaCheckBucket"
      actions = [
        "s3:GetBucketLocation",
        "s3:GetBucketRequestPayment",
        "s3:GetEncryptionConfiguration"
      ]
      effect    = "Allow"
      resources = distinct(flatten([var.athena_buckets_source, var.athena_buckets_results]))
      condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:CalledVia"
        values   = ["athena.amazonaws.com"]
      }
    }
  }

  #
  # Athena / AthenaListSourceBucket
  #

  dynamic "statement" {
    for_each = length(var.athena_buckets_source) > 0 ? [1] : []
    content {
      sid = "AthenaListSourceBucket"
      actions = [
        "s3:ListBucket",
      ]
      effect    = "Allow"
      resources = var.athena_buckets_source
      condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:CalledVia"
        values   = ["athena.amazonaws.com"]
      }
    }
  }

  #
  # Athena / AthenaGetObject
  #

  dynamic "statement" {
    for_each = length(var.athena_buckets_source) > 0 ? [1] : []
    content {
      sid = "AthenaGetObject"
      actions = [
        "s3:GetObject",
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.athena_buckets_source)
      condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:CalledVia"
        values   = ["athena.amazonaws.com"]
      }
    }
  }

  #
  # Athena / AthenaPutResults
  #

  dynamic "statement" {
    for_each = length(var.athena_buckets_results) > 0 ? [1] : []
    content {
      sid = "AthenaPutResults"
      actions = [
        "s3:PutObject",
        "s3:AbortMultipartUpload"
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.athena_buckets_results)
      condition {
        test     = "ForAnyValue:StringEquals"
        variable = "aws:CalledVia"
        values   = ["athena.amazonaws.com"]
      }
    }
  }

  #
  # Athena / AthenaGetResults
  #

  dynamic "statement" {
    for_each = length(var.athena_buckets_results) > 0 ? [1] : []
    content {
      sid = "AthenaGetResults"
      actions = [
        "s3:GetObject",
      ]
      effect    = "Allow"
      resources = formatlist("%s/*", var.athena_buckets_results)
    }
  }

  #
  # CodeCommit / GitPull
  #

  dynamic "statement" {
    for_each = length(var.codecommit_repos_pull) > 0 ? [1] : []
    content {
      sid = "GitPull"
      actions = [
        "codecommit:GitPull",
      ]
      effect    = "Allow"
      resources = var.codecommit_repos_pull
    }
  }

  #
  # GitPush
  #

  dynamic "statement" {
    for_each = length(var.codecommit_repos_push) > 0 ? [1] : []
    content {
      sid = "GitPush"
      actions = [
        "codecommit:GitPush",
      ]
      effect    = "Allow"
      resources = var.codecommit_repos_push
    }
  }

  #
  # GetAuthorizationToken
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.ecr_repos_read, var.ecr_repos_write]))) > 0 ? [1] : []
    content {
      sid = "GetAuthorizationToken"
      actions = [
        "ecr:GetAuthorizationToken"
      ]
      resources = ["*"]
    }
  }

  #
  # GetImage
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.ecr_repos_read, var.ecr_repos_write]))) > 0 ? [1] : []
    content {
      sid = "GetImage"
      actions = [
        "ecr:ListImages",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
      ]
      resources = distinct(flatten([var.ecr_repos_read, var.ecr_repos_write]))
    }
  }

  #
  # PutImage
  #

  dynamic "statement" {
    for_each = length(var.ecr_repos_write) > 0 ? [1] : []
    content {
      sid = "PutImage"
      actions = [
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ]
      resources = var.ecr_repos_write
    }
  }

  #
  # CloudWatch / PutEvents
  #

  dynamic "statement" {
    for_each = length(var.cloudwatch_log_groups_write) > 0 ? [1] : []
    content {
      sid = "CloudWatchPutEvents"
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = var.cloudwatch_log_groups_write
    }
  }

  #
  # SQS / GetQueueAttributes
  #

  dynamic "statement" {
    for_each = length(distinct(flatten([var.sqs_queues_receive, var.sqs_queues_send]))) > 0 ? [1] : []
    content {
      sid = "GetQueueAttributes"
      actions = [
        "sqs:GetQueueAttributes"
      ]
      resources = distinct(flatten([var.sqs_queues_receive, var.sqs_queues_send]))
    }
  }

  #
  # SQS / Receive Message
  #

  dynamic "statement" {
    for_each = length(var.sqs_queues_receive) > 0 ? [1] : []
    content {
      sid = "ReceiveMessage"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
      ]
      resources = var.sqs_queues_receive
    }
  }

  #
  # SQS / Send Message
  #

  dynamic "statement" {
    for_each = length(var.sqs_queues_send) > 0 ? [1] : []
    content {
      sid = "SendMessage"
      actions = [
        "sqs:SendMessage"
      ]
      resources = var.sqs_queues_send
    }
  }

}
