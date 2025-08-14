## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_identity_compartment" "poc_compartment" {
  provider       = oci.homeregion
  compartment_id = var.compartment_ocid  
  name           = local.compartment_name
  description    = local.compartment_name
  enable_delete  = true   
  }

locals{
 poc_compartment_id = oci_identity_compartment.poc_compartment.id
}

resource oci_identity_policy iam_policy_compartment {
  #for_each      =  { for policy in var.policy_variables : policy.compartment_name => policy }
  provider       = oci.homeregion
  name           = local.group_policy_name
  description    = local.group_policy_name
  compartment_id = var.compartment_ocid
  statements = ["allow group ${local.group_name} to manage all-resources in compartment ${local.compartment_name}"]
  depends_on = [ oci_identity_compartment.poc_compartment, oci_identity_group.iam_group ]
}

resource oci_identity_policy iam_policy_tenancy {
  #for_each      =  { for policy in var.policy_variables : policy.compartment_name => policy }
  provider       = oci.homeregion
  name           = local.tenancy_group_policy_name
  description    = local.tenancy_group_policy_name
  compartment_id = var.tenancy_ocid
  statements = ["allow group ${local.group_name} to read compartments in tenancy",
  "allow group ${local.group_name} to use tag-namespaces in tenancy"]
  depends_on = [ oci_identity_compartment.poc_compartment, oci_identity_group.iam_group ]
}

resource "oci_identity_group" "iam_group" {
    provider       = oci.homeregion
    compartment_id = var.tenancy_ocid
    description = local.group_name
    name = local.group_name
}

resource oci_identity_policy dg_policy_tenency {
  #for_each      =  { for policy in var.policy_variables : policy.compartment_name => policy }
  provider       = oci.homeregion
  name           = local.dg_policy_name
  description    = local.dg_policy_name
  compartment_id = var.compartment_ocid
  statements = ["allow dynamic-group ${local.dg_name} to use generative-ai-chat in compartment ${local.compartment_name}"]
  depends_on = [ oci_identity_compartment.poc_compartment]
}

resource oci_identity_dynamic_group dg_policy_tenency {
  provider       = oci.homeregion
  compartment_id = var.tenancy_ocid
  description    = "dynamic group to allow access to resources"
  matching_rule  = "ALL { ${local.dg_compartment_match} }"
  name           = local.dg_policy_name

  lifecycle {
    ignore_changes = [matching_rule]
  }
  depends_on = [ oci_identity_compartment.poc_compartment]
}