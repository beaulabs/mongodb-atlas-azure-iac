output "key_vault_url" {
  description = "Key Vault URL"
  value       = module.azure_keyvault.keyvault_uri
}

output "objectid" {
  description = "testing"
  value = data.azurerm_client_config.current.object_id
}

output "clientid" {
  description = "testing"
  value = data.azurerm_client_config.current.client_id
}

output "subscriptionid" {
  description = "testing"
  value = data.azurerm_client_config.current.subscription_id
}

output "tenant" {
  description = "testing"
  value = data.azurerm_client_config.current.tenant_id
}

output "key_identifier" {
  description = "my key identifer"
  value = module.azure_keyvault.key_identifier
}

output "cluster_base_connection_string" {
  description = "The base connection string"
  value       = module.atlas_cluster.cluster_base_connection_string
}

output "cluster_private_endpoint_string" {
  description = "The strings you can use to connect to this cluster through a private endpoint"
  value = module.atlas_cluster.cluster_private_endpoint_string
}