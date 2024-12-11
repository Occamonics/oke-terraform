# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#                 OKE
#*************************************

// OKE Cluster
resource "oci_containerengine_cluster" "oda-cc-cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = local.cluster_k8s_latest_version
  name               = "${var.prefix_name} Cluster"
  vcn_id             = var.oke-vcn_id

  endpoint_config {
    is_public_ip_enabled = false
    subnet_id            = var.oke-subnet_id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = true
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    service_lb_subnet_ids = [var.oke-service_lb_subnet_ids]
  }
}

// OKE Cluster Node Pool
resource "oci_containerengine_node_pool" "node-pool-1" {
  cluster_id         = oci_containerengine_cluster.oda-cc-cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = oci_containerengine_cluster.oda-cc-cluster.kubernetes_version
  name               = "node-pool-1"
  node_shape         = var.oke-worker-node-shape
  #  node_shape          = "VM.Standard.E4.Flex"

  // if using flex shape, we have to specify shape details memory/ocpu
  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.oke-worker-node-memory
      ocpus         = var.oke-worker-node-ocpu
    }
  }

  node_source_details {
    image_id = data.oci_core_images.oke_node_pool_images.images.1.id
    #    image_id          = "ocid1.image.oc1.us-chicago-1.aaaaaaaafx43wf6j6ls3vjb7bdfn44as4256kerh42plfikrborklvgebrfq"
    source_type = "IMAGE"
  }

  node_config_details {
    #size                    = length(data.oci_identity_availability_domains.ADs.availability_domains)
    size = var.node_count
    dynamic "placement_configs" {
      #for_each              = data.oci_identity_availability_domains.ADs.availability_domains
      for_each = var.ad_list
      content {
        #availability_domain = placement_configs.value.name
        availability_domain = placement_configs.value
        subnet_id           = var.node-pool-subnet_id
      }
    }
  }

  ssh_public_key = var.oke-worker-nodes-auto-generate-ssh-key ? tls_private_key.oke_worker_node_ssh_key.public_key_openssh : var.oke-worker-nodes-ssh-key
}

# Generate ssh keys to access Worker Nodes
resource "tls_private_key" "oke_worker_node_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
