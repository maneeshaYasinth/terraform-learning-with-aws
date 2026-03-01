output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the Bastion Host"
  value       = aws_instance.bastion.public_dns
}

output "private_instance_private_ip" {
  description = "Private IP of the Private Web Server"
  value       = aws_instance.private_web.private_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_id" {
  description = "ID of the Private Subnet"
  value       = aws_subnet.private_subnet.id
}