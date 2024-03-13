##############################################################################
# Resource group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Get Cloud Account ID
##############################################################################

data "ibm_iam_account_settings" "iam_account_settings" {
}

##############################################################################
# Create KMS Instance
##############################################################################

# KMS root key for Event Notifications
module "kms" {
  providers = {
    ibm = ibm.kms
  }
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.8.4"
  resource_group_id           = module.resource_group.resource_group_id
  key_protect_instance_name   = "${var.prefix}-kms-da"
  create_key_protect_instance = true
  region                      = var.region
  keys = [
    {
      key_ring_name = "en-da"
      keys = [
        {
          key_name = "${var.prefix}-en"
        }
      ]
    }
  ]
}

##############################################################################
# Create Event Notifications Instance
##############################################################################

module "event_notification" {
  source                    = "../../solutions/standard"
  resource_group_name         = module.resource_group.resource_group_name
  event_notification_name                      = "${var.prefix}-en-da"
  kms_endpoint_url          = module.kms.kp_private_endpoint
  tags                      = var.resource_tags
  ibmcloud_api_key          = var.ibmcloud_api_key

  # Map of name, role for service credentials that you want to create for the event notification
  service_credential_names = {
    "en_manager" : "Manager",
    "en_writer" : "Writer",
    "en_reader" : "Reader",
    "en_channel_editor" : "Channel Editor",
    "en_device_manager" : "Device Manager",
    "en_event_source_manager" : "Event Source Manager",
    "en_event_notifications_publisher" : "Event Notification Publisher",
    "en_status_reporter" : "Status Reporter",
    "en_email_sender" : "Email Sender",
    "en_custom_email_status_reporter" : "Custom Email Status Reporter",
  }
  region = var.region
  # KMS Related
  kms_region = var.region
  existing_kms_instance_crn = module.kms.key_protect_id
  # COS Related
  cos_region              = var.region
  skip_en_cos_auth_policy = false
}
