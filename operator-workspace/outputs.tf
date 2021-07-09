output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.vault_server.id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.vault_server.public_ip
}