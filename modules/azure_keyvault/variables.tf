variable "azure_subscription" {
    description = "The Azure subscription to use"
    default = "FILL IN AZURE SUBSCRIPTION"
}


variable "azure_keyvault_name" {
    description = "Name of the Azure Key Vault"
    default = "FILL IN NAME OF KEY VAULT"
}

variable "azure_keyvault_accesspolicy_principal_objid" {
    description = "Object ID of principal to use in setting kv access policy - Note this comes from Enterprise applications"
    default = "FILL IN OBJECT ID OF SERVICE PRINCIPAL"
}

variable "azure_keyvault_accesspolicy_principal_user_objid" {
    description = "Object ID of principal to use in setting kv access policy - Note this comes from Enterprise applications not the objid of the app registration, 87 = user, 51 = tf app"
    default = "FILL IN OBJECT ID OF USER"
}


variable "azure_keyvault_accesspolicy_principal_appid" {
    description = "Application ID of principal to use in setting kv access policy"
    default = "FILL IN SERVICE PRINCIAPL APPLICATION ID"
}


variable "resource_group_name" {
    description = "The azure resource group name to use"
}

variable "location" {
    description = "The azure location to use"
}

variable "virtual_network_subnet_ids" {
    description = "The virtual network subnet ids"
}

variable "allowed_ips" {
    description = "The allowed IPs that need to be set in Key Vault firewall"
    default = ["67.174.108.107", "18.214.178.145", "18.235.145.62", "18.235.30.157", "18.235.48.235", "34.193.242.51", "34.196.151.229", "34.200.66.236", "34.235.52.68", "35.153.40.82", "35.169.184.216", "35.171.106.60", "35.174.179.65", "35.174.230.146", "35.175.93.3", "35.175.94.38", "35.175.95.59", "52.71.233.234", "52.87.98.128", "107.20.0.247", "107.20.107.166"]
}