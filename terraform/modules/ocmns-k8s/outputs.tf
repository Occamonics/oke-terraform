# modules/ocmns-k8s/outputs.tf
output "ingress_ip" {
  description = "The public IP of the OKE Ingress"
  value       = data.kubernetes_service.ingress-nginx-controller.status[0].load_balancer[0].ingress[0].ip
}
