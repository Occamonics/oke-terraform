# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

#*************************************
#         General
#*************************************

// Prefix name. Will be used as a name prefix to identify resources, such as OKE, VCN, API Gateway, and others
variable "prefix_name" {
  # default = "Digital Assistant"
}



#*************************************
#         Network Specific
#*************************************

// Create New VCN
variable "create_vcn" {
  # default = true
}


// Network CIDRs
variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                        = "10.0.0.0/16"
    PUBLIC-SUBNET-REGIONAL-CIDR     = "10.0.0.0/24"
    PRIVATE-SUBNET-REGIONAL-CIDR    = "10.0.1.0/24"
    LB-PRIVATE-SUBNET-REGIONAL-CIDR = "10.0.2.0/24"
    OKE-PUBLIC-SUBNET-REGIONAL-CIDR = "10.0.3.0/24"
    ALL-CIDR                        = "0.0.0.0/0"
  }
}

#*************************************
#           TF Requirements
#*************************************

variable "compartment_ocid" {
}
