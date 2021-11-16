data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "${var.unit}-${var.env}-storage-s3-terraform"
    key     = "${var.unit}-network-${var.env}.tfstate"
    region  = var.region
    profile = "${var.unit}-${var.env}"
  }
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature}-subnet-group"
  subnet_ids = data.terraform_remote_state.network.outputs.network_cache_subnet_id
}
