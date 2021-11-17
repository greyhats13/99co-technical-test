data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-k8s-cluster-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

provider "kubernetes" {
  host  = data.terraform_remote_state.k8s.outputs.do_k8s_endpoint
  token = data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.cluster_ca_certificate
  )
  experiments {
    manifest_resource = true
  }
}

resource "kubernetes_manifest" "manifest" {
  manifest = yamldecode(var.manifest)
}




