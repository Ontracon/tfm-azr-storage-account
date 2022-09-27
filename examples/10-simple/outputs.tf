output "storage_account_id" {
  value       = module.terraform-azure-bmw-storage.id
  description = "Id of created storage account"
}

output "storage_account_name" {
  value       = module.terraform-azure-bmw-storage.name
  description = "Name of created storage account"
}
