output "security_group_id" {
  value       = aws_security_group.service.id
  description = "ID of the security group created by the module, containing the app."
}