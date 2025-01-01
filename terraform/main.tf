resource "oci_identity_compartment" "dh-AI-cmp" {
  # Required
  compartment_id = var.tenancy_ocid
  description = "Compartment for organizing and managing all AI-related resources, ensuring secure access and efficient resource utilization."
  name = "dh-AI-cmp"
}

module "network" {
  source           = "./modules/network"
  compartment_ocid = oci_identity_compartment.dh-AI-cmp.id
  create_vcn       = var.create_vcn
  prefix_name      = var.prefix_name
  network_cidrs    = var.network_cidrs
}

module "oke" {
  depends_on = [module.network]
  source                                 = "./modules/oke"
  node-pool-subnet_id                    = var.create_vcn ? module.network.oda_private_subnet_id : var.existing_private_subnet_id_oke_nodes
  oke-service_lb_subnet_ids              = var.create_vcn ? module.network.oda_private_subnet_lb_id : var.existing_private_subnet_id_oke_lb
  oke-subnet_id                          = var.create_vcn ? module.network.oda_public_subnet_oke_id : var.existing_public_subnet_id_oke
  oke-vcn_id                             = var.create_vcn ? module.network.oda_cc_vcn_id : var.existing_vcn_id
  ad_list                                = var.ad_list
  compartment_ocid                       = oci_identity_compartment.dh-AI-cmp.id
  node_count                             = var.node_count
  oke-worker-node-memory                 = var.oke-worker-node-memory
  oke-worker-node-ocpu                   = var.oke-worker-node-ocpu
  oke-worker-node-os-version             = var.oke-worker-node-os-version
  oke-worker-node-shape                  = var.oke-worker-node-shape
  oke-worker-nodes-auto-generate-ssh-key = var.oke-worker-nodes-auto-generate-ssh-key
  oke-worker-nodes-ssh-key               = var.oke-worker-nodes-ssh-key
  prefix_name                            = var.prefix_name
  tenancy_ocid                           = var.tenancy_ocid
}

module "ocmns-k8s" {
  source                       = "./modules/ocmns-k8s"
  dummy_dependency             = module.oke.oke_ready
  oda_private_subnet_lb_id     = var.create_vcn ? module.network.oda_private_subnet_lb_id : var.existing_private_subnet_id_oke_lb
  cluster_id                   = module.oke.oda_cc_cluster_id
  oci_service_account_username = var.oci_service_account_username
  oci_service_auth_token       = var.oci_service_auth_token
  ocir_namespace               = var.ocir_namespace
  ocir_registry_url            = var.ocir_registry_url
}

module "api-gateway" {
  source                 = "./modules/api-gateway"
  depends_on = [module.ocmns-k8s]
  api-gateway-subnet_id  = var.create_vcn ? module.network.oda_public_subnet_id : var.existing_public_subnet_id
  k8s-ingress-ip         = module.ocmns-k8s.ingress_ip
  apigateway_path_prefix = var.apigateway_path_prefix
  compartment_ocid       = oci_identity_compartment.dh-AI-cmp.id
  prefix_name            = var.prefix_name
}
