output "do_helm_metadata" {
  value = module.helm.helm_metadata
}

# output "do_helm_nginx_loadbalancer_id" {
#   value = module.helm.helm_nginx_loadbalancer_id
# }

output "do_helm_nginx_loadbalancer_ip" {
  value = module.helm.helm_nginx_loadbalancer_ip
}