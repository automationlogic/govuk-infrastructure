output "github_ecr_user_access_key" {
  value       = aws_iam_access_key.github_ecr_user.id
  description = "AWS_ACCESS_KEY for Github actions publish to ECR user"
}

output "github_ecr_user_secret_key" {
  value       = aws_iam_access_key.github_ecr_user.encrypted_secret
  description = "AWS_SECRET_ACCESS_KEY for Github actions publish to ECR user"
  sensitive   = true
}
