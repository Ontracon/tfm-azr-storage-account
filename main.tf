# ============================================================================ #
#                                     Setup                                    #
# ============================================================================ #

module "common" {
  source               = "git::https://github.com/Ontracon/tfm-cloud-commons.git?ref=1.0.2"
  cloud_region         = var.cloud_region
  global_config        = var.global_config
  custom_tags          = var.custom_tags
  custom_name          = var.custom_name
  commons_file_json    = var.commons_file_json
  local_file_json_tpl  = var.local_file_json_tpl
  naming_file_json_tpl = var.naming_file_json_tpl
}

# ============================================================================ #
#                       resource_group_name                                    #
# ============================================================================ #
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  location = var.cloud_region
  name     = module.common.names.resource_type["azurerm_resource_group"].name
  tags     = module.common.tags
}

# ============================================================================ #
#                       Storage Account (General Purpose)                      #
# ============================================================================ #
resource "azurerm_storage_account" "general_purpose" {
  resource_group_name = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location            = var.cloud_region
  name                = module.common.names.resource_type["azurerm_storage_account"].name
  tags                = module.common.tags

  account_replication_type          = var.account_replication_type
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  access_tier                       = var.access_tier
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  enable_https_traffic_only         = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = false
  infrastructure_encryption_enabled = true
  queue_encryption_key_type         = "Account"
  table_encryption_key_type         = "Account"

  identity {
    type         = var.user_assigned_identity_id != null ? "UserAssigned" : "SystemAssigned"
    identity_ids = var.user_assigned_identity_id != null ? [var.user_assigned_identity_id] : null
  }

  dynamic "blob_properties" {
    for_each = (var.blob_properties != null ? [var.blob_properties] : [])
    iterator = blob_property
    content {
      dynamic "cors_rule" {
        for_each = (var.cors_rule != null ? [var.cors_rule] : [])
        content {
          allowed_headers    = lookup(cors_rule.value, "allowed_headers", null)
          allowed_methods    = lookup(cors_rule.value, "allowed_methods", null)
          allowed_origins    = lookup(cors_rule.value, "allowed_origins", null)
          exposed_headers    = lookup(cors_rule.value, "exposed_headers", null)
          max_age_in_seconds = lookup(cors_rule.value, "max_age_in_seconds", null)
        }
      }

      dynamic "delete_retention_policy" {
        for_each = (lookup(blob_property.value, "delete_retention_policy", null) != null ? [
          lookup(blob_property.value, "delete_retention_policy", null)
        ] : [])
        content {
          days = delete_retention_policy.value["days"]
        }
      }
      versioning_enabled       = lookup(blob_property.value, "versioning_enabled", null)
      change_feed_enabled      = lookup(blob_property.value, "change_feed_enabled", null)
      default_service_version  = lookup(blob_property.value, "default_service_version", null)
      last_access_time_enabled = lookup(blob_property.value, "last_access_time_enabled", null)

      dynamic "container_delete_retention_policy" {
        for_each = (lookup(blob_property.value, "container_delete_retention_policy", null) != null ? [
          lookup(blob_property.value, "container_delete_retention_policy", null)
        ] : [])
        content {
          days = container_delete_retention_policy.value["days"]
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = (var.queue_properties != null ? [var.queue_properties] : [])
    iterator = queue_property
    content {
      dynamic "cors_rule" {
        for_each = (var.cors_rule != null ? [var.cors_rule] : [])
        content {
          allowed_headers    = lookup(cors_rule.value, "allowed_headers", null)
          allowed_methods    = lookup(cors_rule.value, "allowed_methods", null)
          allowed_origins    = lookup(cors_rule.value, "allowed_origins", null)
          exposed_headers    = lookup(cors_rule.value, "exposed_headers", null)
          max_age_in_seconds = lookup(cors_rule.value, "max_age_in_seconds", null)
        }
      }

      logging {
        delete                = true
        read                  = true
        version               = "v1.0"
        write                 = true
        retention_policy_days = lookup(queue_property.value, "retention_policy_days", null)
      }

      dynamic "minute_metrics" {
        for_each = (lookup(queue_property.value, "minute_metrics", null) != null ? [
          lookup(queue_property.value, "minute_metrics", null)
        ] : [])
        content {
          enabled               = minute_metrics.value["enabled"]
          version               = minute_metrics.value["version"]
          include_apis          = minute_metrics.value["include_apis"]
          retention_policy_days = minute_metrics.value["retention_policy_days"]
        }
      }

      dynamic "hour_metrics" {
        for_each = (lookup(queue_property.value, "hour_metrics", null) != null ? [
          lookup(queue_property.value, "hour_metrics", null)
        ] : [])
        content {
          enabled               = hour_metrics.value["enabled"]
          version               = hour_metrics.value["version"]
          include_apis          = hour_metrics.value["include_apis"]
          retention_policy_days = hour_metrics.value["retention_policy_days"]
        }
      }
    }
  }

  share_properties {
    smb {
      versions                        = ["SMB3.1.1"]
      authentication_types            = ["NTLMv2", "Kerberos"]
      kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]
      channel_encryption_type         = ["AES-256-GCM"]
    }
  }

  routing {
    choice = "MicrosoftRouting"
  }
}


# ============================================================================ #
#                              Network integration                             #
# ============================================================================ #
resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id         = azurerm_storage_account.general_purpose.id
  default_action             = "Deny"
  ip_rules                   = var.allowed_ips
  virtual_network_subnet_ids = var.allowed_subnet_ids
  bypass                     = var.allowed_bypass_network_rules
}

# ============================================================================ #
#                             Customer Managed Key                             #
# ============================================================================ #

resource "azurerm_storage_account_customer_managed_key" "customer_managed_key" {
  count                     = var.customer_managed_key_name != null ? 1 : 0
  storage_account_id        = azurerm_storage_account.general_purpose.id
  key_vault_id              = var.customer_managed_key_vault_id
  key_name                  = var.customer_managed_key_name
  user_assigned_identity_id = var.user_assigned_identity_id
}

# ============================================================================ #
#                             Monitoring & Logging                             #
# ============================================================================ #
data "azurerm_monitor_diagnostic_categories" "storage_account_diagnostic_categories" {
  count       = var.log_analytics_workspace_id != null ? 1 : 0
  resource_id = azurerm_storage_account.general_purpose.id
}

resource "azurerm_monitor_diagnostic_setting" "storage_account_diagnostic_setting" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "storage_account_diagnostic_setting"
  target_resource_id         = azurerm_storage_account.general_purpose.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.storage_account_diagnostic_categories[0].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.log_retention_period
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.storage_account_diagnostic_categories[0].metrics
    content {
      category = metric.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = var.log_retention_period
      }
    }
  }
}