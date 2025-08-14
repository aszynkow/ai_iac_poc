data oci_identity_compartment oci_compartment {
    id = var.compartment_ocid
}

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data "oci_identity_availability_domains" "ADs" {
  #provider       = oci.targetregion
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "auxvmimage" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.aux_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_core_images" "gpuvmimage" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.gpu_node_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}


data "oci_objectstorage_namespace" "osNamespace" {
    #Optional
    compartment_id = var.tenancy_ocid
}