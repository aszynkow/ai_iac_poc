## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "vms_ip" {
  value = oci_core_instance.llm_instance.*.private_ip
}

output "os_bucket_name" {
  value = local.bucket_name
}

output "cus_image_url" {
  value = local.cus_image_url
}

output bastion_allow_list {
  value = local.bastion_client_cidr_block_allow_list
}

