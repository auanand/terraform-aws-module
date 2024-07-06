output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ec2_instance[*].id
}

output "security_group_ids" {
  description = "ID of the security group"
  value       = aws_security_group.instance_sg.id
}