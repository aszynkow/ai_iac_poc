# spoke Terraform module
A Terraform module to create a spoke vcn with multiple subnets atatched to hub vcn with DRG in a existing_netwrok_compartment.  


Usage:  

################################################  


Example of Spoke VCN being created with spoke and subnets config files (details below). NAT created. DRG attachment created. Routing and Security lists created to/for HUB and other spokes.  


locals {
    
    spoke_file_path = "${path.module}/config_files/spoke.csv"
    subnet_file_path = "${path.module}/config_files/subnets.csv"

    subnet_variables = csvdecode(file(local.subnet_file_path))
    spoke_variables = csvdecode(file(local.spoke_file_path))

}

module "CreateSpokeVcn" {

    source   = "git::https://devops.scmservice.ap-sydney-1.oci.oraclecloud.com/namespaces/sdncspltazsk/projects/tf_modules/repositories/spoke"
    tenancy_ocid = var.tenancy_ocid
    compartment_ocid           = var.compartment_ocid
    subnet_variables = local.subnet_variables
    spoke_variables = local.spoke_variables
    vcn_name = var.vcn_name
    spoke_cidr_block = var.spoke_cidr_block
    vcn_hub_id = var.vcn_hub_id
    existing_hub_compartment_id = var.existing_hub_compartment_id

}

################################################  

config_files/spoke.csv - file containing other spokes used to create routing and security rules (VCN default)

Example of 3 existing spoke VCNs:  

id,other_spoke_name,other_spoke_cidr_block  

1,Spoke-A,192.168.101.0/24  

2,Spoke-B,192.168.102.0/24  

3,Spoke-C,192.168.103.0/24  

################################################  


/config_files/subnets.csv - file containg subnets tobe creted aspart of this spoke VCN  


Example of 2 new subnets to be added (private only)  

id,display_name,dns_label,cidr_block  

1,spokeasub1,spokeasub1,192.168.104.0/24  

2,spokeasub2,spokeasub2,192.168.105.0/24  


Questions: adam.szynkowski@oracle.com