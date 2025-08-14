locals {
 spoke_file_path = "${path.module}/config_files/secrules.csv"
 subnet_file_path = "${path.module}/config_files/subnets.csv"

 subnet_variables = csvdecode(file(local.subnet_file_path))
 spoke_variables = csvdecode(file(local.spoke_file_path))

 db_override_file_path = "${path.module}/config_files/dboverride.csv"
 db_overrides = csvdecode(file(local.db_override_file_path))
 

 aux_name = join(local.separator,[var.environment_name,"auxvm"])
 separator = "_"
 osb1_namespace = data.oci_objectstorage_namespace.osNamespace.namespace
 pgsql_db_name = join(local.separator,[var.environment_name,"pgsqldb"])
 dg_compartment_match = format("instance.compartment.id='%s'", local.poc_compartment_id)
 compartment_name = var.environment_name
 group_name = join(local.separator,[var.environment_name,"groupadmins"])
 dg_name = join(local.separator,[var.environment_name,"dyngroup"])
 group_policy_name = join(local.separator,[var.environment_name,"grouppolicy"])
 tenancy_group_policy_name = join(local.separator,[var.environment_name,"tenancypolicy"])
 dg_policy_name = join(local.separator,[var.environment_name,"dymanicgrouppolicy"])
 bastion_name = join(local.separator,[var.environment_name,"bastion"])
 bucket_name = join(local.separator,[var.environment_name,"bucket"])
 vcn_id = module.vcn.vcn_id
 subnet1_id = module.vcn.subnet1_id
 subnet2_id = module.vcn.subnet2_id

 https_count = var.enable_https ? 1 : 0
 lb_name = join(local.separator,[var.environment_name,"lb"])
 lbsl_name = join(local.separator,[var.environment_name,"lbsl"])
 lstn1_name = join(local.separator,[var.environment_name,"lstn"])
 lstn2_name = join(local.separator,[var.environment_name,"lstn2"])
 nsglb1_name = join(local.separator,[var.environment_name,"nsglb"])
 nsgprivlb1_name = join(local.separator,[var.environment_name,"nsgprivlb"])
 bcknd1_name = join(local.separator,[var.environment_name,"bcknd"])
 bcknd2_name = join(local.separator,[var.environment_name,"bcknd2"])
 lbsubnet_name = join(local.separator,[var.environment_name,"lbsub"])
 lbdns_name = join(local.separator,[var.environment_name,"lbsub"])
 lbrt_name = join(local.separator,[var.environment_name,"lbrt"])
 waf_name = join(local.separator,[var.environment_name,"waf"])
 waf_policy_name = join(local.separator,[var.environment_name,"wafpolicy"])
 cus_image_url = tolist(split(",",var.cus_image_url))
 bastion_client_cidr_block_allow_list = tolist(split(",",var.bastion_client_cidr_block_allow_list))
}