## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
#Austorization
variable user_ocid {
  description = "User OCID"
  default = ""
}

variable fingerprint {
  description = "Fingerprint"
  default = ""
}

variable private_key_path {
  description = "API private key path"
  default = ""
}

variable release {
  default = "1.0"
}

variable availability_domain_name {
  default = ""
}

variable tenancy_ocid {
  description = "Tenancy OCID"
}
#Deployment
variable environment_name {
  default = "aipoc"
}

variable compartment_ocid {
  description = "OCID of the compartment where VCN will be created"
}

variable region {
  description = "OCI Region"
}

variable spoke_cidr_block {
  description = "VCN's CIDR IP Block"
  default = "10.0.0.0/24"
}

variable instance_os {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable linux_os_version {
  description = "Operating system version for all Linux instances"
  default     = "9"
}

variable ssh_authorized_keys {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable ssh_public_key {
  description = "The private key path to access instance."
  default     = ""
}

variable vm_instance_name {
  description = "Name of the compute instance"
  default     = ["frontend","backend"]
}

variable vm_boot_volume_size_in_gbs {
  default = [100,256]
}
variable llm_vm_count {
  default = 2
}

variable node_flex_shape_ocpus {
  description = "Flex Instance shape OCPUs"
  default = [2,16]
}

variable node_flex_shape_memory {
  description = "Flex Instance shape Memory (GB)"
  default = [32,256]
}

variable node_shape {
description = "Instance shape to use for master instance."
 default     = ["VM.Standard.E5.Flex","VM.Standard.E5.Flex"]
}

variable aux_shape {
 default = "VM.Standard.E5.Flex"
}

variable aux_ocpu {
 default = 4
}

variable aux_mem {
 default = 32
}


#Object Storage
variable "osb1_storage_tier" {
  default = "Standard"
}
variable "osb1_public_access_type" {
  default = "NoPublicAccess"
}#
#variable "osb1_freeform_tags" {}
variable osb1_name {
  default = ""
}
#IAM
#BAstion
variable bastion_client_cidr_block_allow_list {
  default = ["0.0.0.0/0"]
}
variable bastion_name {
  default = ""
}

variable cus_image_name {
  default = ["import_fronted_image","import_backend_image"]
}
variable cus_image_url {
  default = []
}

#pgsql
variable pgsql_password {
  default = ""
}

variable pgsql_user {
  default = ""
}

variable pgsql_db_name {
  default ="pgsqldb"
}

variable db_version {
  default = "16"
}
  
variable  instance_count {  
  default = "2"
}

variable instance_memory_size_in_gbs {
  default = "96"
}

variable instance_ocpu_count {
  default = "8"
}

variable pgsql_shape {
  default = "PostgreSQL.VM.Standard.E5.Flex"
}

variable pgsql_iops {
  default= "300000" 
}

variable pgsql_is_reader_endpoint_enabled {
  default = "true"
}

variable pgsql_backup_kind {
  default = "NONE"
}
   
variable pgsql_is_regionally_durable  {
  default = "false"
}

variable pgsql_system_type  { 
  default = "OCI_OPTIMIZED_STORAGE"
}

variable db_config_or_instance_memory_size_in_gbs {
  default = "0"
}

variable db_config_or_instance_ocpu_count {  
  default = "0"
}

variable db_config_or_is_flexible {                
  default = "true"
}
  
variable db_config_or_shape  {
  default  = "VM.Standard.E5.Flex"
}

variable db_config_compatible_shape {
  default = ["VM.Standard.E4.Flex","VM.Standard3.Flex"]
}

#LB
variable lb_shape {
    default = "flexible"
}

variable  maximum_bandwidth_in_mbps {
    default ="10"
}

variable minimum_bandwidth_in_mbps {
    default = "10"
}

variable https_health_check_path {
    default = "/"
}

variable enable_https {
  default = false
}

variable listener_ssl_configuration_certificate_id {
  default = ""
}