########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.existing_resource_group == true ? var.resource_group_name : null
}

#######################################################################################################################
# KMS Key
#######################################################################################################################

locals {
  en_kms_key_id = var.existing_kms_root_key_id != null ? var.existing_kms_root_key_id : module.kms[0].keys[format("%s.%s", var.en_key_ring_name, var.en_key_name)].key_id
}

# KMS root key for Event Notifications
module "kms" {
  providers = {
    ibm = ibm.kms
  }
  count                       = var.existing_kms_root_key_id != null ? 0 : 1 # no need to create any KMS resources if passing an existing key
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.8.3"
  resource_group_id           = null # rg only needed if creating KP instance
  create_key_protect_instance = false
  region                      = var.kms_region
  existing_kms_instance_guid  = var.existing_kms_instance_crn
  key_ring_endpoint_type      = var.kms_endpoint_type
  key_endpoint_type           = var.kms_endpoint_type
  keys = [
    {
      key_ring_name         = var.en_key_ring_name
      existing_key_ring     = false
      force_delete_key_ring = true
      keys = [
        {
          key_name                 = var.en_key_name
          standard_key             = false
          rotation_interval_month  = 3
          dual_auth_delete_enabled = false
          force_delete             = true
        }
      ]
    }
  ]
}

########################################################################################################################
# Event Notifications
########################################################################################################################

locals {
  # KMS Related
  existing_kms_instance_crn = var.existing_kms_instance_crn != null ? var.existing_kms_instance_crn : null
}

module "event_notifications" {
  source                   = "../.."
  resource_group_id        = module.resource_group.resource_group_id
  region                   = var.region
  name                     = var.event_notification_name
  plan                     = var.service_plan
  tags                     = var.tags
  service_endpoints        = var.service_endpoints
  service_credential_names = var.service_credential_names
  # KMS Related
  kms_encryption_enabled    = true
  kms_endpoint_url          = var.kms_endpoint_url
  existing_kms_instance_crn = local.existing_kms_instance_crn
  root_key_id               = local.en_kms_key_id
  skip_en_kms_auth_policy   = var.skip_en_kms_auth_policy
  # COS Related
  cos_integration_enabled = true
  cos_destination_name    = var.cos_destination_name
  cos_bucket_name         = var.cos_bucket_name
  cos_instance_id         = var.cos_instance_id
  cos_region              = var.cos_region
  skip_en_cos_auth_policy = var.skip_en_cos_auth_policy
}
