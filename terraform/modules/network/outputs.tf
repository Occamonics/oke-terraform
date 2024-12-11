output "oda_private_subnet_id" {
  description = "The ID of the private subnet for ODA"
  value       = oci_core_subnet.oda-private-subnet[0].id
}

output "oda_private_subnet_lb_id" {
  description = "The ID of the private subnet for OKE load balancer"
  value       = oci_core_subnet.oda-private-subnet-lb[0].id
}

output "oda_public_subnet_oke_id" {
  description = "The ID of the public subnet for OKE"
  value       = oci_core_subnet.oda-private-subnet-oke[0].id
}

output "oda_cc_vcn_id" {
  description = "The ID of the VCN for ODA"
  value       = oci_core_vcn.oda-cc-vcn[0].id
}

output "oda_public_subnet_id" {
  description = "The ID of the public subnet for API Gateway"
  value = oci_core_subnet.oda-public-subnet[0].id
}
