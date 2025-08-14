## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_core_instance" "llm_instance" {
  count = var.llm_vm_count
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain_name
  compartment_id      = local.poc_compartment_id
  display_name        =  join(local.separator,[var.environment_name,var.vm_instance_name[count.index]])
  shape               = var.node_shape[count.index]

  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  
   shape_config {
      memory_in_gbs = var.node_flex_shape_memory[count.index]
      ocpus         = var.node_flex_shape_ocpus[count.index]
    }
  

  create_vnic_details {
    subnet_id        = local.subnet2_id#oci_core_subnet.opensearch_public_subnet.id
    display_name     =  join(local.separator,[var.environment_name,var.vm_instance_name[count.index]])
    assign_public_ip = false
  }

  source_details {
    source_id   = oci_core_image.cus__image[count.index].id #data.oci_core_images.kbot_image.images[0].id
    source_type = "image"
    boot_volume_size_in_gbs = var.vm_boot_volume_size_in_gbs[count.index]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key#tls_private_key.public_private_key_pair.public_key_openssh#var.ssh_authorized_keys
    #user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  #defined tags

}

resource "oci_core_image" "cus__image" {
  count = var.llm_vm_count
  # Required
  compartment_id = local.poc_compartment_id
  display_name   = join(local.separator,[var.environment_name,var.cus_image_name[count.index]])
  image_source_details {
          source_type = "objectStorageUri"
          source_uri = local.cus_image_url[count.index]
      }
  
}

resource "oci_core_instance" "aux_vm" {
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain_name
  compartment_id      = local.poc_compartment_id
  display_name        = local.aux_name
  shape               = var.aux_shape

  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  
   shape_config {
      memory_in_gbs = var.aux_mem
      ocpus         = var.aux_ocpu
    }
  

  create_vnic_details {
    subnet_id        = local.subnet2_id#oci_core_subnet.opensearch_public_subnet.id
    display_name     = local.aux_name
    assign_public_ip = false
  }

  source_details {
    source_id   = data.oci_core_images.auxvmimage.images[0].id
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key#tls_private_key.public_private_key_pair.public_key_openssh#var.ssh_authorized_keys
    #user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  #defined tags
}

resource "oci_core_instance" "gpu_instance" {
  count = local.gpu_vm_count
  availability_domain = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = local.gpu_instance_name
  shape               = var.gpu_node_shape

  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  
  dynamic "shape_config" {
    for_each = local.is_flex_shape ? [1] : []
    content {
      memory_in_gbs = var.gpu_node_flex_shape_memory
      ocpus         = var.gpu_node_flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = local.subnet2_id#oci_core_subnet.opensearch_public_subnet.id
    display_name     = local.gpu_instance_name
    assign_public_ip = false
  }

  source_details {
    source_id   = data.oci_core_images.gpuvmimage.images[0].id
    source_type = "image"
    boot_volume_size_in_gbs = var.gpu_boot_szie_gbs
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key#tls_private_key.public_private_key_pair.public_key_openssh#var.ssh_authorized_keys
    #user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  #defined tags

}