output "json" {
  description = "The rendered JSON of the policy document."
  value       = data.aws_iam_policy_document.main.json
}
