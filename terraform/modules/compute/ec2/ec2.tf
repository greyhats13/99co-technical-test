provider "aws" {
  region  = var.region
  profile = "${var.unit}-${var.env}"
}

data "aws_availability_zones" "az" {}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-network-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "private" {
  key_name   = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}-private-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "aws_instance" "ec2" {
  instance_type               = var.instance_type
  ami                         = var.ami
  key_name                    = aws_key_pair.private.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.network_public_subnet_id[0]
  vpc_security_group_ids      = [aws_security_group.sg.id]
  availability_zone           = data.aws_availability_zones.az.names[0]
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}
