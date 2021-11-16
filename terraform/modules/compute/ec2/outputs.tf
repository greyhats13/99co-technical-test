
output "ec2_arn" {
  value = aws_instance.ec2.arn
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.ec2.private_ip
}

output "ec2_public_dns" {
  value = aws_instance.ec2.private_dns
}