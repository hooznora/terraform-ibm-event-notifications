##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If not set a new resource group will be created using the prefix variable"
  default     = "geretain-test-event-notifications"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "en-fsc"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example, Event Notifications supported regions are: us-south (Dallas), eu-gb (London), eu-de (Frankfurt), au-syd (Sydney), eu-es (Madrid)"
  default     = "us-south"
}

variable "cos_region" {
  type        = string
  description = "The region in which the cos bucket is located."
  default     = "us-south"
}

variable "existing_kms_instance_crn" {
  description = "The CRN of the Hyper Protect Crypto Services. To ensure compliance with FSCloud standards, it is required to use HPCS only"
  type        = string
  default     = "crn:v1:bluemix:public:hs-crypto:us-south:a/abac0df06b644a9cabc6e44f55b3880e:e6dce284-e80f-46e1-a3c1-830f7adff7a9::"
}

variable "root_key_crn" {
  type        = string
  description = "The Key ID of a root key, existing in the KMS instance passed in var.existing_kms_instance_crn, which will be used to encrypt the data encryption keys (DEKs) which are then used to encrypt the data."
  default     = "crn:v1:bluemix:public:hs-crypto:us-south:a/abac0df06b644a9cabc6e44f55b3880e:e6dce284-e80f-46e1-a3c1-830f7adff7a9:key:76170fae-4e0c-48c3-8ebe-326059ebb533"
}

variable "kms_endpoint_url" {
  description = "The KMS endpoint URL to use when configuring KMS encryption."
  type        = string
  default     = "https://api.us-south.hs-crypto.cloud.ibm.com:8992"
}
