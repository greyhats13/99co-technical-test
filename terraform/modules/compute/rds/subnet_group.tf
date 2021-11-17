data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-network-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}-db-subnet-group"
  subnet_ids  = data.terraform_remote_state.network.outputs.network_db_subnet_id
  description = "DB subnet group for ${var.unit}-${var.env}-${var.code}-${var.feature}"
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-db-subnet-group"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}