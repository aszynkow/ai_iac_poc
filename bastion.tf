resource "oci_bastion_bastion" "test_bastion" {
    #Required
    bastion_type = "STANDARD"
    compartment_id = local.poc_compartment_id
    target_subnet_id = local.subnet2_id
    name = local.bastion_name
    #Optional
    client_cidr_block_allow_list = local.bastion_client_cidr_block_allow_list
}