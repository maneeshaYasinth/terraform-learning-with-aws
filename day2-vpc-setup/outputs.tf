output "ec2_public_ip" {
  value = aws_instance.day2_ec2.public_ip
}