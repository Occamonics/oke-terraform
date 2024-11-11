
// Install Nginx Ingress Helm Chart
resource "helm_release" "helm-chart-ingress-nginx" {
  # depends_on = [oci_containerengine_node_pool.node-pool-1]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  timeout    = 600000
  wait       = true
  values     = [
    data.template_file.helm-values-ingress-nginx.rendered
  ]
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}


resource "kubernetes_secret" "ocir_secret" {
  # depends_on = [kubernetes_namespace.dev]
  metadata {
    name      = "oci-secret"
    namespace = "dev"  # You can specify a different namespace
  }

  data = {
    # ".dockerconfigjson" = base64encode(jsonencode({
    #   auths = {
    #     "${var.ocir_registry_url}" = {
    #       # username = "${var.ocir_namespace}/${var.oci_service_account_username}"
    #       username = "axq6t3vfixne/service_account"
    #       password = var.oci_service_auth_token  # This will be your OCI API key token
    #     }
    #   }
    # }))
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.ocir_registry_url}" = {
          "username" = "${var.ocir_namespace}/${var.oci_service_account_username}"
          "password" = var.oci_service_auth_token
          # "email"    = var.registry_email
          "auth"     = base64encode("${var.ocir_namespace}/${var.oci_service_account_username}:${var.oci_service_auth_token}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_service_account" "oci_service_account" {
  metadata {
    name      = "oci-service-account"
    namespace = "dev"  # Specify your namespace here
  }
}
