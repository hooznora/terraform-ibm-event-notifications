##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  description = "ID of resource group to use when creating the event stream instance"
  type        = string
}

variable "name" {
  type        = string
  description = "The name to give the IBM Event Notification instance created by this module."
}

variable "tags" {
  type        = list(string)
  description = "Optional list of tags to be added to the Event Notification instance"
  default     = []
}

variable "region" {
  type        = string
  description = "IBM Cloud region where event notification will be created, supported regions are: us-south (Dallas), eu-gb (London), eu-de (Frankfurt), au-syd (Sydney), eu-es (Madrid)"
  default     = "us-south"
}

variable "skip_en_kms_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all event notification instances in the provided resource group reader access to the instance specified in the existing_kms_instance_guid variable."
  default     = false
}

variable "existing_kms_instance_crn" {
  description = "The CRN of the Hyper Protect Crypto Services or Key Protect instance. To ensure compliance with FSCloud standards, it is required to use HPCS only."
  type        = string
}

variable "root_key_id" {
  type        = string
  description = "The Key ID of a root key, existing in the KMS instance passed in var.existing_kms_instance_crn, which will be used to encrypt the data encryption keys (DEKs) which are then used to encrypt the data."
}

variable "kms_endpoint_url" {
  description = "The KMS endpoint URL to use when configuring KMS encryption."
  type        = string
}

variable "service_credential_names" {
  description = "Map of name, role for service credentials that you want to create for the event notification"
  type        = map(string)
  default     = {}
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
  description = "(Optional, list) List of CBR rules to create."
  default     = []
}

########################################################################################################################
# COS
########################################################################################################################

variable "destination_name" {
  type        = string
  description = "The Destintion name."
  default     = null
}

variable "bucket_name" {
  type        = string
  description = "The bucket name in IBM cloud object storage instance."
  default     = null
}

variable "cos_instance_id" {
  type        = string
  description = "The instance id for IBM Cloud object storage instance."
  default     = null
}

variable "cos_region" {
  type        = string
  description = "The bucket region."
  default     = null
}

variable "cos_integration_enabled" {
  type        = bool
  description = "Set this to true to control the encryption keys used to encrypt the data that you store in Event Notification. If set to false, the data is encrypted by using randomly generated keys. For more info on Managing Encryption, see https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-en-managing-encryption"
  default     = false
}

variable "skip_en_cos_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all Event Notification instances in the resource group to read the encryption key from the COS instance. No policy is created if var.kms_encryption_enabled is set to false."
  default     = false
}
