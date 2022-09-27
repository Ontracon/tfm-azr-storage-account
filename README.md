# tfm-azr-storage-account

<!--.test-default-test-start-->
[![OTC repo](https://img.shields.io/static/v1?logo=git&style=plastic&label=OTC%20repo&message=✓%205%20|✗%200%20|▲%201|➝%200&color=yellow)](https://github.com/Ontracon/tfm-azr-storage-account/actions/runs/3139194761)
[![TF Base](https://img.shields.io/static/v1?logo=terraform&style=plastic&label=TF%20Base&message=✓%203%20|✗%200%20|▲%201|➝%200&color=yellow)](https://github.com/Ontracon/tfm-azr-storage-account/actions/runs/3139194761)
[![TF Compliance (tflint)](https://img.shields.io/static/v1?logo=terraform&style=plastic&label=TF%20Compliance%20(tflint)&message=✓%201%20|✗%20%20|▲%201|➝%200&color=yellow)](https://github.com/Ontracon/tfm-azr-storage-account/actions/runs/3139194761)
[![Security (Checkov)](https://img.shields.io/static/v1?logo=terraform&style=plastic&label=Security%20(Checkov)&message=✓%2011%20|✗%200%20|▲%201|➝%200&color=yellow)](https://github.com/Ontracon/tfm-azr-storage-account/actions/runs/3139194761)
<!--.test-default-test-end-->

Module to create a Azure storage account.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common"></a> [common](#module\_common) | git::https://github.com/Ontracon/tfm-cloud-commons.git | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.storage_account_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.general_purpose](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_account_network_rules.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_monitor_diagnostic_categories.storage_account_diagnostic_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | `"Hot"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Defaults to LRS | `string` | `"LRS"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. Defaults to false. | `bool` | `false` | no |
| <a name="input_allowed_bypass_network_rules"></a> [allowed\_bypass\_network\_rules](#input\_allowed\_bypass\_network\_rules) | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Defaults to 'AzureServices' | `list(string)` | <pre>[<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | One or more IP Addresses, or CIDR Blocks which should be able to access the Azure Storage Account. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_allowed_subnet_ids"></a> [allowed\_subnet\_ids](#input\_allowed\_subnet\_ids) | One or more Subnet ID's which should be able to access this Azure Storage Account | `set(string)` | `[]` | no |
| <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties) | A blob\_properties block. Define the cors\_rule using the cors\_rule variable.<br><br>**delete\_retention\_policy** := A delete\_retention\_policy block. <br>***days*** := Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7.<br><br>**versioning\_enabled** := Is versioning enabled? Default to false.<br><br>**change\_feed\_enabled** := Is the blob service properties for change feed events enabled? Default to false.<br><br>**default\_service\_version** := The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version. Defaults to 2020-06-12.<br><br>**last\_access\_time\_enabled** := Is the last access time based tracking enabled? Default to false.<br><br>**versioning\_enabled** := A container\_delete\_retention\_policy block as defined below.<br>***days*** := Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7. | <pre>object({<br>    delete_retention_policy = optional(object({<br>      days = number<br>    }))<br>    versioning_enabled       = optional(bool)<br>    change_feed_enabled      = optional(bool)<br>    default_service_version  = optional(string)<br>    last_access_time_enabled = optional(bool)<br>    container_delete_retention_policy = optional(object({<br>      days = number<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_cloud_region"></a> [cloud\_region](#input\_cloud\_region) | Define the cloud region to use (AWS Region / Azure Location) which tf should use. | `string` | n/a | yes |
| <a name="input_commons_file_json"></a> [commons\_file\_json](#input\_commons\_file\_json) | Json file to override the commons fixed variables. | `string` | `""` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | A cors\_rule block as defined below. this cors\_rule will be reused on all properties.<br><br>**allowed\_headers** := A list of headers that are allowed to be a part of the cross-origin request.<br><br>**allowed\_methods** := A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.<br><br>**allowed\_origins** := A list of origin domains that will be allowed by CORS.<br><br>**exposed\_headers** := A list of response headers that are exposed to CORS clients.<br><br>**max\_age\_in\_seconds** := The number of seconds the client should cache a preflight response. | <pre>object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  })</pre> | `null` | no |
| <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | Should cross Tenant replication be enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Set custom name for deployment. | `string` | `""` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Set custom tags for deployment. | `map(string)` | `null` | no |
| <a name="input_customer_managed_key_name"></a> [customer\_managed\_key\_name](#input\_customer\_managed\_key\_name) | The name of Key Vault Key to be used as the Customer Managed Key | `string` | `null` | no |
| <a name="input_customer_managed_key_vault_id"></a> [customer\_managed\_key\_vault\_id](#input\_customer\_managed\_key\_vault\_id) | The ID of the Key Vault where the key for the Customer Managed Key is stored. | `string` | `null` | no |
| <a name="input_global_config"></a> [global\_config](#input\_global\_config) | Global config Object which contains the mandatory informations within OTC. | <pre>object({<br>    env             = string<br>    customer_prefix = string<br>    project         = string<br>    application     = string<br>    costcenter      = string<br>  })</pre> | n/a | yes |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Defaults to false | `bool` | `false` | no |
| <a name="input_local_file_json_tpl"></a> [local\_file\_json\_tpl](#input\_local\_file\_json\_tpl) | Json template file to override the local settings template. | `string` | `""` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The id of the log analytics workspace, where all the diagnostics data should get stored in. If not set, no log/metrics are forwarded to Log Analytics | `string` | `null` | no |
| <a name="input_log_retention_period"></a> [log\_retention\_period](#input\_log\_retention\_period) | The number of days for which this Retention Policy should apply. Setting this to 0 will retain the events indefinitely. | `string` | `7` | no |
| <a name="input_naming_file_json_tpl"></a> [naming\_file\_json\_tpl](#input\_naming\_file\_json\_tpl) | Json template file to override the naming template. | `string` | `""` | no |
| <a name="input_queue_properties"></a> [queue\_properties](#input\_queue\_properties) | A queue\_properties block. Define the cors\_rule using the cors\_rule variable.module\_name          = basename(abspath(path.module))<br><br>**retention\_policy\_days** :=  Specifies the number of days that logs will be retained.<br><br>**minute\_metrics** := A minute\_metrics block supports the following:<br>***enabled*** := Indicates whether minute metrics are enabled for the Queue service. Changing this forces a new resource.<br>***version*** := The version of storage analytics to configure. Changing this forces a new resource.<br>***include\_apis*** := Indicates whether metrics should generate summary statistics for called API operations.<br>***retention\_policy\_days*** :=  Specifies the number of days that logs will be retained for minute metrics<br><br>**hour\_metrics** := A minute\_metrics block supports the following:<br>***enabled*** := Indicates whether hour metrics are enabled for the Queue servmodule\_name          = basename(abspath(path.module))ice. Changing this forces a new resource.<br>***version*** := The version of storage analytics to configure. Changing this forces a new resource.<br>***include\_apis*** := Indicates whether metrics should generate summary statistics for called API operations.<br>***retention\_policy\_days*** :=  Specifies the number of days that logs will be retained for hour metrics | <pre>object({<br>    retention_policy_days = optional(number)<br>    minute_metrics = optional(object({<br>      enabled               = bool<br>      version               = string<br>      include_apis          = optional(bool)<br>      retention_policy_days = optional(number)<br>    }))<br>    hour_metrics = optional(object({<br>      enabled               = bool<br>      version               = string<br>      include_apis          = optional(bool)<br>      retention_policy_days = optional(number)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Storage Account will be created | `string` | `""` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true. | `bool` | `true` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | The ID of a user assigned identity, which should be assigned to this storage account | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the storage account. |
| <a name="output_name"></a> [name](#output\_name) | The name of the storage account. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key for the storage account. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
