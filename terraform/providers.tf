# Copyright (c) 2020 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

terraform {
  required_version = ">= 1.1"

  required_providers {
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source = "hashicorp/tls"
    }
    oci = {
      source  = "oracle/oci"
      version = "6.17.0"
    }
  }
}

// Default Provider
provider "oci" {
  region = var.region
  tenancy_ocid = var.tenancy_ocid

  # Uncomment the below if you are running locally using your laptop
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}


