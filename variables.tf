# ---------------------------------------------------------------------------------------------------------------------
# Global Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "cloud_region" {
  type        = string
  description = "Define the cloud region to use (AWS Region / Azure Location) which tf should use."
}

variable "global_config" {
  type = object({
    env             = string
    customer_prefix = string
    project         = string
    application     = string
    costcenter      = string
  })
  description = "Global config Object which contains the mandatory informations within OTC."
}

# ---------------------------------------------------------------------------------------------------------------------
# Custom Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "custom_tags" {
  type        = map(string)
  default     = null
  description = "Set custom tags for deployment."
}

variable "custom_name" {
  type        = string
  default     = ""
  description = "Set custom name for deployment."
}

variable "commons_file_json" {
  type        = string
  default     = ""
  description = "Json file to override the commons fixed variables."
}

variable "local_file_json_tpl" {
  type        = string
  default     = ""
  description = "Json template file to override the local settings template."
}

variable "naming_file_json_tpl" {
  type        = string
  default     = ""
  description = "Json template file to override the naming template."
}
# ======================================================================================================================
# Resource Group
# ======================================================================================================================
variable "resource_group_name" {
  description = "The name of the resource group in which the Storage Account will be created"
  default     = ""
}

##======================================================================================================================
# Storage Account (General Purpose)
# ======================================================================================================================

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Defaults to LRS"
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public. Defaults to false."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true."
  type        = bool
  default     = true
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Defaults to false"
  type        = bool
  default     = false
}

# ============================================================================ #
#                            Blob & Queue Properties                           #
# ============================================================================ #

variable "cors_rule" {
  description = <<-EOF
    A cors_rule block as defined below. this cors_rule will be reused on all properties.

    **allowed_headers** := A list of headers that are allowed to be a part of the cross-origin request.

    **allowed_methods** := A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.

    **allowed_origins** := A list of origin domains that will be allowed by CORS.

    **exposed_headers** := A list of response headers that are exposed to CORS clients.

    **max_age_in_seconds** := The number of seconds the client should cache a preflight response.
  EOF
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}

variable "blob_properties" {
  description = <<-EOF
    A blob_properties block. Define the cors_rule using the cors_rule variable.

    **delete_retention_policy** := A delete_retention_policy block. 
    ***days*** := Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7.

    **versioning_enabled** := Is versioning enabled? Default to false.

    **change_feed_enabled** := Is the blob service properties for change feed events enabled? Default to false.

    **default_service_version** := The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version. Defaults to 2020-06-12.

    **last_access_time_enabled** := Is the last access time based tracking enabled? Default to false.

    **versioning_enabled** := A container_delete_retention_policy block as defined below.
    ***days*** := Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7.

    
  EOF
  type = object({
    delete_retention_policy = optional(object({
      days = number
    }))
    versioning_enabled       = optional(bool)
    change_feed_enabled      = optional(bool)
    default_service_version  = optional(string)
    last_access_time_enabled = optional(bool)
    container_delete_retention_policy = optional(object({
      days = number
    }))
  })
  default = null
}

variable "queue_properties" {
  description = <<-EOF
    A queue_properties block. Define the cors_rule using the cors_rule variable.module_name          = basename(abspath(path.module))

    **retention_policy_days** :=  Specifies the number of days that logs will be retained.

    **minute_metrics** := A minute_metrics block supports the following:
    ***enabled*** := Indicates whether minute metrics are enabled for the Queue service. Changing this forces a new resource.
    ***version*** := The version of storage analytics to configure. Changing this forces a new resource.
    ***include_apis*** := Indicates whether metrics should generate summary statistics for called API operations.
    ***retention_policy_days*** :=  Specifies the number of days that logs will be retained for minute metrics

    **hour_metrics** := A minute_metrics block supports the following:
    ***enabled*** := Indicates whether hour metrics are enabled for the Queue servmodule_name          = basename(abspath(path.module))ice. Changing this forces a new resource.
    ***version*** := The version of storage analytics to configure. Changing this forces a new resource.
    ***include_apis*** := Indicates whether metrics should generate summary statistics for called API operations.
    ***retention_policy_days*** :=  Specifies the number of days that logs will be retained for hour metrics
  EOF
  type = object({
    retention_policy_days = optional(number)
    minute_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))
    hour_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))
  })
  default = null
}

# ======================================================================================================================
# Authentication
# ======================================================================================================================
variable "user_assigned_identity_id" {
  description = "The ID of a user assigned identity, which should be assigned to this storage account"
  type        = string
  default     = null
}

# ======================================================================================================================
# Network Access
# ======================================================================================================================
variable "allowed_ips" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Azure Storage Account."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_subnet_ids" {
  description = "One or more Subnet ID's which should be able to access this Azure Storage Account"
  type        = set(string)
  default     = []
}

variable "allowed_bypass_network_rules" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Defaults to 'AzureServices'"
  type        = list(string)
  default     = ["AzureServices"]
}

# ======================================================================================================================
# Customer Managed Key
# ======================================================================================================================

variable "customer_managed_key_name" {
  description = "The name of Key Vault Key to be used as the Customer Managed Key"
  type        = string
  default     = null
}

variable "customer_managed_key_vault_id" {
  description = "The ID of the Key Vault where the key for the Customer Managed Key is stored."
  type        = string
  default     = null
}

# ======================================================================================================================
# Monitoring & Logging
# ======================================================================================================================
variable "log_analytics_workspace_id" {
  description = "The id of the log analytics workspace, where all the diagnostics data should get stored in. If not set, no log/metrics are forwarded to Log Analytics"
  type        = string
  default     = null
}

variable "log_retention_period" {
  description = "The number of days for which this Retention Policy should apply. Setting this to 0 will retain the events indefinitely."
  type        = string
  default     = 7
}