output "helm_metadata" {
  value = helm_release.helm.metadata
}

data "kubernetes_service" "helm_ingress_service" {
  count = var.chart == "ingress-nginx" ? 1 : 0
  metadata {
    name = !var.no_env ? "${var.unit}-${var.code}-${var.feature}-${var.env}-ingress-nginx-controller":"${var.unit}-${var.code}-${var.feature}-ingress-nginx-controller"
    namespace = var.override_namespace != null ? var.override_namespace : (
      var.env == "prd" ? "evermos" : var.env
    )
  }

  depends_on = [helm_release.helm]
}

# output "helm_nginx_loadbalancer_id" {
#   value = length(data.kubernetes_service.helm_ingress_service) > 0 ? data.kubernetes_service.helm_ingress_service.0.metadata.0.annotations["kubernetes.digitalocean.com/load-balancer-id"]:null
# }

output "helm_nginx_loadbalancer_ip" {
  value = length(data.kubernetes_service.helm_ingress_service) > 0 ? data.kubernetes_service.helm_ingress_service.0.status.0.load_balancer.0.ingress.0.ip : null
}
