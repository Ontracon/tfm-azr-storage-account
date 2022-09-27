provider "azurerm" {
  features {}
}

# Inputs are limited to the minimum necessary to deploy the example as designed
# Values which are not provided will be replaced internally with preconfigured defaults
module "terraform-azure-bmw-storage" {
  source        = "../../"
  cloud_region  = var.cloud_region
  global_config = var.global_config
}