resource "oci_objectstorage_bucket" "osb1" {
    #Required
    compartment_id = local.poc_compartment_id
    name           = local.bucket_name
    namespace      = local.osb1_namespace

    #Optional
    storage_tier   = var.osb1_storage_tier
    access_type    = var.osb1_public_access_type
    #freeform_tags  = var.osb1_freeform_tags
    #kms_key_id = 
    #metadata = 
    #object_events_enabled = 
}