# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#         General
#*************************************

// Prefix name. Will be used as a name prefix to identify resources, such as OKE, VCN, API Gateway, and others
variable "prefix_name" {
#   # default = "Digital Assistant"
}

#*************************************
#         OKE Specific
#*************************************

// OKE Worker Nodes Shape
variable "oke-worker-node-shape" {
#   #  default = "VM.Standard.E4.Flex"
}
// Worker Nodes OS Image
variable "oke-worker-node-os-version" {
#   #  default="8.9"
}
// Worker Node Memory
variable "oke-worker-node-memory" {
  # default=32
}
// Worker Node OCPU
variable "oke-worker-node-ocpu" {
#   default=2
}
// Auto-generate OKE Worker Nodes SSH Key
variable "oke-worker-nodes-auto-generate-ssh-key" {
#   default = true
}
// OKE Worker Nodes SSH Key
variable "oke-worker-nodes-ssh-key" {
#   default = ""
}

variable "oke-vcn_id" {

}

variable "oke-subnet_id" {

}

variable "oke-service_lb_subnet_ids" {

}

variable "node-pool-subnet_id" {

}





#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
}

variable "compartment_ocid" {
}

#*************************************
# Limiting ADs to one - 20230402 AB
#*************************************
variable "ad_list" {
  type = list(string)
#   default = ["kzxG:US-ASHBURN-AD-1"]
}

variable "node_count" {
#   default = 1
}
