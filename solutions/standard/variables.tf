########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The API Key to use for IBM Cloud."
  sensitive   = true
}

variable "existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision Event Notifications resources to."
}

variable "region" {
  type        = string
  description = "The region in which to provision Event Notifications resources."
  default     = "us-south"
}

variable "existing_monitoring_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "(Optional) The CRN of an existing IBM Cloud Monitoring instance. Used to monitor the COS bucket used for storing failed events. Ignored if using existing COS bucket and not provisioning SCC workload protection."
}

########################################################################################################################
# Event Notifications
########################################################################################################################

variable "service_credential_names" {
  type        = map(string)
  description = "Map of name, role for service credentials that you want to create for the Event Notifications instance."
  default     = {}

  validation {
    condition     = alltrue([for name, role in var.service_credential_names : contains(["Manager", "Writer", "Reader", "Event Source Manager", "Channel Editor", "Event Notification Publisher", "Status Reporter", "Device Manager", "Email Sender", "Custom Email Status Reporter"], role)])
    error_message = "Valid values for service credential roles are 'Manager', 'Writer', 'Reader', 'Event Source Manager', 'Channel Editor', 'Event Notification Publisher', 'Status Reporter', 'Device Manager', 'Email Sender', 'Custom Email Status Reporter'"
  }
}

variable "event_notification_name" {
  type        = string
  description = "The name to give the IBM Event Notification instance created by this solution."
  default     = "base-event-notifications"
}

variable "service_plan" {
  type        = string
  description = "Plan for the Event Notifications instance : lite or standard"
  default     = "standard"
  validation {
    condition     = contains(["lite", "standard"], var.service_plan)
    error_message = "The specified plan is not a valid selection! Supported plans are: lite or standard"
  }

}

variable "service_endpoints" {
  type        = string
  description = "Specify whether you want to enable the public or both public and private service endpoints. Supported values are 'public' or 'public-and-private'."
  default     = "public-and-private"
  validation {
    condition     = contains(["public", "public-and-private"], var.service_endpoints)
    error_message = "The specified service endpoint is not a valid selection! Supported options are: public or public-and-private."
  }
}

variable "tags" {
  type        = list(string)
  description = "Optional list of tags to be added to the Event Notification instance."
  default     = []
}

########################################################################################################################
# KMS
########################################################################################################################

variable "existing_kms_instance_crn" {
  type        = string
  description = "The CRN of the Hyper Protect Crypto Services or Key Protect instance."
}

variable "existing_kms_root_key_id" {
  type        = string
  description = "The Key ID of a root key, existing in the KMS instance passed in var.existing_kms_instance_crn, which will be used to encrypt the data encryption keys (DEKs) which are then used to encrypt the data. The code will create the key if one is not passed in."
  default     = null
}

variable "kms_endpoint_url" {
  type        = string
  description = "The KMS endpoint URL to use when configuring KMS encryption. HPCS endpoint URL format- https://api.private.<REGION>.hs-crypto.cloud.ibm.com:<port> and KP endpoint URL format- https://<REGION>.kms.cloud.ibm.com. Only required if not passing existing key."
}

variable "kms_region" {
  type        = string
  default     = "us-south"
  description = "The region in which KMS instance exists."
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for commincating with the KMS instance. Allowed values are: 'public' or 'private' (default). Only used if not supplying an existing root key."
  default     = "private"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "The kms_endpoint_type value must be 'public' or 'private'."
  }
}

variable "en_key_ring_name" {
  type        = string
  default     = "en-key-ring"
  description = "The name to give the Key Ring which will be created for Event Notifications. Not used if supplying an existing Key."
}

variable "en_key_name" {
  type        = string
  default     = "en-key"
  description = "The name to give the Key which will be created for the Event Notifications. Not used if supplying an existing Key."
}

variable "cos_key_ring_name" {
  type        = string
  default     = "cos-key-ring"
  description = "The name to give the Key Ring which will be created for COS. Not used if supplying an existing Key."
}

variable "cos_key_name" {
  type        = string
  default     = "cos-key"
  description = "The name to give the Key which will be created for COS. Not used if supplying an existing Key."
}

variable "skip_en_kms_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all Event Notification instances in the resource group to read the encryption key from the KMS instance."
  default     = false
}

########################################################################################################################
# COS
########################################################################################################################

variable "cos_destination_name" {
  type        = string
  description = "The name to give the IBM Cloud Object Storage destination which will be created for storage of failed delivery events."
  default     = "COS Destination"
}

variable "cos_bucket_name" {
  type        = string
  description = "The name to use when creating the Cloud Object Storage bucket for storing failed events (NOTE: bucket names are globally unique). If 'add_bucket_name_suffix' is set to true, a random 4 characters will be added to this name to help ensure bucket name is globally unique."
  default     = "base-event-notifications-bucket"
}

variable "cos_region" {
  type        = string
  description = "The Cloud Object Storage region."
  default     = "us-south"
}

variable "skip_en_cos_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all Event Notification instances in the resource group to interact with your Cloud Object Storage instance."
  default     = false
}

variable "cos_instance_name" {
  type        = string
  default     = "base-security-services-cos"
  description = "The name to use when creating the Cloud Object Storage instance."
}

variable "cos_instance_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to Cloud Object Storage instance. Only used if not supplying an existing instance."
  default     = []
}

variable "cos_instance_access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the Cloud Object Storage instance. Only used if not supplying an existing instance."
  default     = []
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add random generated suffix (4 characters long) to the newly provisioned COS bucket name. Only used if not passing existing bucket. set to false if you want full control over bucket naming using the 'cos_bucket_name' variable."
  default     = true
}

variable "cos_bucket_access_tags" {
  type        = list(string)
  default     = []
  description = "Optional list of access tags to be added to the COS bucket."
}

variable "cos_bucket_class" {
  type        = string
  default     = "smart"
  description = "The storage class of the newly provisioned COS bucket. Allowed values are: 'standard', 'vault', 'cold', 'smart' (default value), 'onerate_active'"
  validation {
    condition     = contains(["standard", "vault", "cold", "smart", "onerate_active"], var.cos_bucket_class)
    error_message = "Allowed values for cos_bucket_class are \"standard\", \"vault\",\"cold\", \"smart\", or \"onerate_active\"."
  }
}

variable "existing_cos_instance_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "The CRN of an existing Cloud Object Storage instance. If not supplied, a new instance will be created."
}

variable "existing_cos_bucket_name" {
  type        = string
  nullable    = true
  default     = null
  description = "The name of an existing bucket inside the existing Cloud Object Storage instance. If not supplied, a new bucket will be created."
}

variable "skip_cos_kms_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance. WARNING: An authorization policy must exist before an encrypted bucket can be created"
  default     = false
}

variable "management_endpoint_type_for_bucket" {
  description = "The type of endpoint for the IBM terraform provider to use to manage COS buckets. (`public`, `private` or `direct`). Ensure to enable virtual routing and forwarding (VRF) in your account if using `private`, and that the terraform runtime has access to the the IBM Cloud private network."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "direct"], var.management_endpoint_type_for_bucket)
    error_message = "The specified management_endpoint_type_for_bucket is not a valid selection!"
  }
}

variable "existing_activity_tracker_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "(Optional) The CRN of an existing Activity Tracker instance. Used to send COS bucket log data and all object write events to Activity Tracker. Only used if not supplying an existing COS bucket."
}

variable "cos_endpoint" {
  type        = string
  description = "The endpoint url for your cos instance, for further information refer to the official docs https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-endpoints. Required only if var.cos_integration_enabled is set to true."
  default     = null
}
