// Get OKE Cluster CONFIG File
data "oci_containerengine_cluster_kube_config" "oke_cluster_kube_config" {
  cluster_id = var.cluster_id
}

// Nginx Ingress HElM Chart Values.yaml file
data "template_file" "helm-values-ingress-nginx" {
  template = <<END
controller:
  service:
    annotations:
      service.beta.kubernetes.io/oci-load-balancer-internal: "true"
      service.beta.kubernetes.io/oci-load-balancer-subnet1: ${ var.oda_private_subnet_lb_id }
      service.beta.kubernetes.io/oci-load-balancer-shape: "flexible"
      service.beta.kubernetes.io/oci-load-balancer-shape-flex-min: "10"
      service.beta.kubernetes.io/oci-load-balancer-shape-flex-max: "100"
END
}


data "kubernetes_service" "ingress-nginx-controller" {
  depends_on = [helm_release.helm-chart-ingress-nginx]
  metadata {
    name = "ingress-nginx-controller"
  }
}
