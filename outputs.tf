output "id" {
  value       = azurerm_storage_account.general_purpose.id
  description = "The id of the storage account."
}

output "name" {
  value       = azurerm_storage_account.general_purpose.name
  description = "The name of the storage account."
}

output "primary_access_key" {
  value       = azurerm_storage_account.general_purpose.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}