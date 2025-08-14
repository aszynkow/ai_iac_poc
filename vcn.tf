module "vcn" {
 
  source  = "./modules/spoke"
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid  = local.poc_compartment_id
  subnet_variables = local.subnet_variables
  spoke_variables = local.spoke_variables
  spoke_cidr_block = var.spoke_cidr_block
  vcn_hub_id = ""#Not rewuired as only creating 1 stand alone VCN
  existing_hub_compartment_id = ""#Creating a new compartment
  environment_name = var.environment_name
  depends_on = [oci_identity_compartment.poc_compartment]
}