terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-ec2-bastion-prd.tfstate"
    profile = "99c-prd"
  }
}

module "ec2" {
  source                      = "../../modules/compute/ec2"
  region                      = "ap-southeast-1"
  unit                        = "99c"
  env                         = "prd"
  code                        = "compute"
  feature                     = "ec2"
  instance_type               = "t3.small"
  ami                         = "ami-0210560cedcb09f07"
  associate_public_ip_address = true
  volume_type                 = "gp3"
  volume_size                 = 20
}
