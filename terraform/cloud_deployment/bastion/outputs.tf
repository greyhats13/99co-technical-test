
output "compute_ec2_arn" {
  value = module.ec2.ec2_arn
}

output "compute_ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "compute_ec2_private_ip" {
  value = module.ec2.ec2_private_ip
}

output "compute_ec2_public_dns" {
  value = module.ec2.ec2_public_dns
}