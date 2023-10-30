##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  description = "The resource group ID where the Event Notification instance will be created."
  type        = string
}

variable "name" {
  type        = string
  description = "The name to give the IBM Event Notification instance created by this module."
}

variable "plan" {
  type        = string
  description = "Plan for the event notification instance : lite or standard"
  default     = "standard"
  validation {
    condition     = contains(["lite", "standard"], var.plan)
    error_message = "The specified plan is not a valid selection! Supported plans are: lite or standard"
  }
}

variable "tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "region" {
  type        = string
  description = "IBM Cloud region where event notification will be created, supported regions are: us-south (Dallas), eu-gb (London), eu-de (Frankfurt), au-syd (Sydney)"
  default     = "us-south"
  validation {
    condition     = contains(["us-south", "eu-gb", "eu-de", "au-syd"], var.region)
    error_message = "The specified region is not valid, supported regions are: us-south (Dallas), eu-gb (London), eu-de (Frankfurt), au-syd (Sydney)"
  }
}

variable "service_endpoints" {
  type        = string
  description = "Specify whether you want to enable the public or both public and private service endpoints. Supported values are 'public' or 'public-and-private'."
  default     = "public"
  validation {
    condition     = contains(["public", "public-and-private"], var.service_endpoints)
    error_message = "The specified service endpoint is not a valid selection! Supported options are: public or public-and-private."
  }
}

variable "cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
  }))
  description = "(Optional, list) List of CBR rules to create"
  default     = []
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all Event Notification instances in the resource group to read the encryption key from the KMS instance. If set to false, pass in a value for the KMS instance in the existing_kms_instance_guid variable. In addition, no policy is created if var.kms_encryption_enabled is set to false."
  default     = false
}

variable "kms_encryption_enabled" {
  type        = bool
  description = "Set this to true to control the encryption keys used to encrypt the data that you store in Event Notification. If set to false, the data is encrypted by using randomly generated keys. For more info on Managing Encryption, see https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-en-managing-encryption"
  default     = false
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Services (HPCS) that you want to use for encryption. Only used if var.kms_encryption_enabled is set to true."
  default     = null
  validation {
    condition = anytrue([
      var.kms_key_crn == null,
      can(regex(".*kms.*", var.kms_key_crn)),
      can(regex(".*hs-crypto.*", var.kms_key_crn)),
    ])
    error_message = "Value must be the root key CRN from either the Key Protect or Hyper Protect Crypto Service (HPCS)"
  }
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect Crypto Services or Key Protect instance in which the key specified in var.kms_key_crn is coming from. Required only if var.kms_encryption_enabled is set to true, var.skip_iam_authorization_policy is set to false, and you pass a value for var.kms_key_crn."
  type        = string
  default     = null
}

variable "root_key_id" {
  type        = string
  description = "The Key ID of a root key, existing in the Key Protect instance passed in var.existing_kms_instance_guid, which will be used to encrypt the data encryption keys (DEKs) which are then used to encrypt the data. Required if value passed for var.existing_kms_instance_guid."
  default     = null
}


variable "service_credential_names" {
  description = "Map of name, role for service credentials that you want to create for the event notification"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for name, role in var.service_credential_names : contains(["Manager", "Writer", "Reader", "Event Source Manager", "Channel Editor", "Event Notifications Publisher", "Status Reporter", "Device Manager", "Email Sender", "Custom Email Status Reporter"], role)])
    error_message = "Valid values for service credential roles are 'Manager', 'Writer', 'Reader', 'Event Source Manager', 'Channel Editor', 'Event Notifications Publisher', 'Status Reporter', 'Device Manager', 'Email Sender', 'Custom Email Status Reporter'"
  }
}
