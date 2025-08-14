resource oci_psql_db_system aipoc {
  #apply_config = <<Optional >>
  compartment_id = local.poc_compartment_id
  config_id      = oci_psql_configuration.aipoc_logical.id
  #credentials = <<Optional >>

  credentials {
        #Required
        password_details {
            #Required
            password_type = "PLAIN_TEXT"

            #Optional
            password = var.pgsql_password
            #secret_id = oci_vault_secret.test_secret.id
            #secret_version = var.db_system_credentials_password_details_secret_version
        }
        username = var.pgsql_user
    }
  db_version = var.db_version
  
  display_name = local.pgsql_db_name
  instance_count              = var.instance_count
  instance_memory_size_in_gbs = var.instance_memory_size_in_gbs
  instance_ocpu_count         = var.instance_ocpu_count
  
  management_policy {
    backup_policy {
      #backup_start = <<Optional >>
      #copy_policy = <<Optional >>
      #days_of_the_month = <<Optional >>
      #days_of_the_week = <<Optional >>
      kind = var.pgsql_backup_kind
      #retention_days = <<Optional >>
    }
    #maintenance_window_start = "WED 05:30"
  }
  network_details {
    is_reader_endpoint_enabled = var.pgsql_is_reader_endpoint_enabled
    nsg_ids = [
    ]
    #primary_db_endpoint_private_ip = ""
    subnet_id                      = local.subnet2_id
  }
  #patch_operations = <<Optional >>
  shape = var.pgsql_shape
  source {
    #backup_id = <<Optional >>
    #is_having_restore_config_overrides = <<Optional >>
    source_type = "NONE"
  }
  storage_details {
    availability_domain   = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain_name
    iops                  = var.pgsql_iops
    is_regionally_durable = var.pgsql_is_regionally_durable
    system_type           = var.pgsql_system_type
  }
  system_type = var.pgsql_system_type
}

resource oci_psql_configuration aipoc_logical {
  compartment_id = local.poc_compartment_id

  #compatible_shapes = ["VM.Standard.E5.Flex",]

 db_configuration_overrides {
        #Required
        dynamic items {
            for_each = local.db_overrides 
            content {#Required
            config_key = items.value.config_key
            overriden_config_value = items.value.overriden_config_value
            }
        }
    }

  #compatible_shapes = var.db_config_compatible_shape
  db_version                 = var.db_version
  #description = <<Optional >>
  display_name = local.pgsql_db_name
  instance_memory_size_in_gbs = var.db_config_or_instance_memory_size_in_gbs
  instance_ocpu_count         = var.db_config_or_instance_ocpu_count
  is_flexible                 = var.db_config_or_is_flexible
  shape                       = var.db_config_or_shape
  
  system_tags = {
  }

 lifecycle {
    ignore_changes = [db_configuration_overrides]
  }
}