variable "athena_buckets_source" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that store the data being queried through Athena. Use [\"*\"] to allow all buckets."
  default     = []
}

variable "athena_buckets_results" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that store the results of Athena queries. Use [\"*\"] to allow all buckets."
  default     = []
}

variable "athena_tables_exec" {
  type = list(object({
    database = string
    table    = string
  }))
  description = "A list of the Glue tables that can be read from during execution of Athena queries.  Use [\"*\"] to allow all tables."
  default     = []
}

variable "athena_workgroups_exec" {
  type        = list(string)
  description = "The ARNs of the AWS Athena workgroups that can be executed.  Use [\"*\"] to allow all workgroups."
  default     = []
}

variable "cloudwatch_log_groups_write" {
  type        = list(string)
  description = "The ARNs of the AWS CloudWatch log groups that events can be written into.  Use [\"*\"] to allow all log groups."
  default     = []
}

variable "codecommit_repos_pull" {
  type        = list(string)
  description = "The ARNs of the AWS CodeCommit repos that can be pulled.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "codecommit_repos_push" {
  type        = list(string)
  description = "The ARNs of the AWS CodeCommit repos that can be pushed.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "ec2_networkinterfaces_manage" {
  type        = bool
  description = "Allows creating, deleting, and attaching network interfaces."
  default     = false
}

variable "ecr_repos_read" {
  type        = list(string)
  description = "The ARNs of the AWS ECR repos that can be read from.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "ecr_repos_write" {
  type        = list(string)
  description = "The ARNs of the AWS ECR repos that can be written to.  Use [\"*\"] to allow all repos."
  default     = []
}

variable "ecs_tasks_run" {
  type = list(object({
    clusters         = list(string)
    task_definitions = list(string)
  }))
  description = "The list of ARNs for ECS task definitions and the ECS clusters where they can be run.  Either clusters or task_definitions can be set to [\"*\"] to allow all."
  default     = []
}

variable "glue_tables_add" {
  type = list(object({
    database = string
    table    = string
  }))
  description = "List of Glue tables that partitions can be added to."
  default     = []
}

variable "iam_roles_pass" {
  type        = list(string)
  description = "The ARNs of the IAM roles that can be passed.  Use [\"*\"] to allow all roles to be passed."
  default     = []
}

variable "kms_keys_decrypt" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys that can be used to decrypt data.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "kms_keys_encrypt" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys that can be used to encrypt data.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "s3_buckets_write" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that can be written to.  Use [\"*\"] to allow all buckets."
  default     = []
}

variable "s3_buckets_read" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that can be read from.  Use [\"*\"] to allow all buckets."
  default     = []
}

variable "sqs_queues_send" {
  type        = list(string)
  description = "The ARNs of the AWS S3 queues that messages can be sent to.  Use [\"*\"] to allow all queues."
  default     = []
}

variable "sqs_queues_receive" {
  type        = list(string)
  description = "The ARNs of the AWS SQS queues that messages can be received from.  Also grants the permission to delete messages.  Use [\"*\"] to allow all queues."
  default     = []
}
