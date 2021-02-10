output "keyvault_name" {
  description = "The name of the azure key vault"
  value = azurerm_key_vault.iac_keyvault.name
}

output "key_identifier" {
  description = "The key identifier"
  value = azurerm_key_vault_key.iac_atlas_key.id
}


output "keyvault_uri" {
    description = "URL of the keyvault for Atlas use downstream"
    value = azurerm_key_vault.iac_keyvault.vault_uri
}