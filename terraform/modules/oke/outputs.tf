output "oda_cc_cluster_id" {
  description = "The ID of the OKE cluster for ODA"
  value       = oci_containerengine_cluster.oda-cc-cluster.id
}

output "oke_ready" {
  description = "Dummy output to indicate OKE module is ready"
  value       = true
}
