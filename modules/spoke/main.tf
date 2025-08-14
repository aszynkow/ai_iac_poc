locals {
    separator = "_"
    vcn_name = join (local.separator,[local.environment_name,"vcn"])
    environment_name = var.environment_name
    existing_hub_compartment_id = var.existing_hub_compartment_id
    spoke_cidr_block = var.spoke_cidr_block
    base_prefix_length = tonumber(split("/", local.spoke_cidr_block)[1])
    dns_label = join("",[local.environment_name,"vcn"])
    netwrok_compartment = var.compartment_ocid
    subnet_variables = var.subnet_variables
    spoke_variables = var.spoke_variables
    nat_name = join (local.separator,[local.environment_name,local.vcn_name,"nat"])
    sgw_name = join (local.separator,[local.environment_name,local.vcn_name,"sgw"])
    igw_name = join (local.separator,[local.environment_name,local.vcn_name,"igw"])
    #drg_attach_name = join ("",[local.vcn_name,"DRG-Attachment"])
    #vcn_hub_id = var.vcn_hub_id
    services_id = lookup(data.oci_core_services.all_oci_services[0].services[0], "id")
    services_desc = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
    #drg_id = data.oci_core_drg_attachments.hub_drg_attachments.drg_attachments.0.drg_id
    #com_ids = [for comp in data.oci_identity_compartments.all_comaprtments.compartments: [for x in data.oci_core_vcns.all_vcns["ocid1.compartment.oc1..aaaaaaaap5wfzevgletixqjlb3jyei3vk2gczd5jc3ga3u3w3mwowqmeumia"].virtual_networks : x if x.index > 0  ].0.cidr_blocks ]
    #vcn_hub_cidrs = data.oci_core_vcns.all_vcns.virtual_networks.0.cidr_blocks#[for x in data.oci_core_vcns.all_vcns.virtual_networks : x if x.id == local.vcn_hub_id].0.cidr_blocks
}