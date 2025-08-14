data oci_identity_compartments all_comaprtments {
    compartment_id = var.tenancy_ocid
    compartment_id_in_subtree = "true"
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = 1
}