variable tenancy_ocid {}
variable "compartment_ocid" {}
variable "subnet_variables" {type = list}
variable "spoke_variables" {type = list}
variable vcn_hub_id {}
variable existing_hub_compartment_id {}
#variable vcn_name {}
variable spoke_cidr_block {}
variable environment_name {}