# Configure MongoDB Atlas Provider
# NOTE: Programmatic keys will not placed in variables.tf - Export with environment
# variables only!

# PROVIDERS - Tell terraform which providers we need
terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.8.2"
    }
    azure = {
      source = "hashicorp/azurerm"
      version = "2.46.1"
    }
  }
}

provider "mongodbatlas" {
  # Configuration options
}

provider "azure" {
    subscription_id = var.azure_subscription
    features {
    }
}

data "azurerm_client_config" "current" {

}

module "atlas_cluster" {
  source = "./modules/atlas_clusters"

  atlas_project_id = module.atlas_project.atlas_project_id

    depends_on = [
    module.azure_keyvault
  ]
}

module "atlas_project" {
  source = "./modules/atlas_projects"

  azure_rg = module.azure_resgrp.resourcegroup_name
  key_vault_name = module.azure_keyvault.keyvault_name
  key_identifier = module.azure_keyvault.key_identifier
  azure_subscription = data.azurerm_client_config.current.subscription_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  location = module.azure_resgrp.resourcegroup_location
  subnet_id = module.azure_resgrp.virtual_network_subnet_ids
  

  # We need the azure key vault deployed first as projects KMS is reliant
  # upon the key vault name and key to deploy
  depends_on = [
    module.azure_keyvault,
    module.azure_resgrp
  ]
}


module "azure_resgrp" {
  source = "./modules/azure_resourcegroups"
}

module "azure_keyvault" {
  source = "./modules/azure_keyvault"

  resource_group_name = module.azure_resgrp.resourcegroup_name
  location = module.azure_resgrp.resourcegroup_location
  virtual_network_subnet_ids = module.azure_resgrp.virtual_network_subnet_ids

  depends_on = [
    module.azure_resgrp
  ]

}
