variable "oda_private_subnet_lb_id" {
  description = "The ID of the private subnet for OKE load balancer"
  # value       = oci_core_subnet.oda-private-subnet-lb[0].id
}

variable "cluster_id" {

}


variable "dummy_dependency" {
  description = "Dependency placeholder"
  type        = bool
}

variable "ocir_registry_url" {
}

variable "ocir_namespace" {
}

variable "oci_service_account_username" {
}

variable "oci_service_auth_token" {
}
