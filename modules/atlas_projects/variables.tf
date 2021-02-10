variable "organization" {
    description = "Name of Atlas organization to use"
    default = "FILL IN ATLAS ORGANIZATION ID"
}

variable "atlas_project_name" {
    description = "Name of the Atlas project to use"
    default = "FILL IN PROJECT NAME"
}

// variable "atlas_project_id" {
//     description = "Project ID of existing Atlas project to use"
//     default = <insert project id here in quotes>
// }


variable "ip_whitelist" {
    description = "Allowed IP to allow ingress to Atlas - Note: entry can be CIDR or single address"
    default = "FILL IN IP ADDRESS FOR ACCESSLIST"
}

variable "ip_whitelist_comment" {
  description = "Information reference whitelisted IP"
  default     = "IP address allowed for Project access"
}


variable "cluster_name" {
  description = "The name to use for cluster under project"
  default     = "FILL IN NAME OF CLUSTER"
}

variable "azure_rg" {
    description = "Name of azure resource group to use"
}

variable "location" {
    description = "azure location"
}

variable "key_vault_name" {
    description = "Name of azure key vault to use"
}

variable "key_identifier" {
    description = "Name of azure key to use"
}

variable "azure_subscription" {
    description = "Name of azure subscription to use"
}

variable "tenant_id" {
    description = "Name of azure tenant id"
}

variable "azure_authentication_secret" {
    description = "Password to be used when connecting Atlas to Azure Key Vault - For prod better to fetch or use env variable"
    default = "SERVICE PRINCIPAL PASSWORD TO CONFIGURE KEY VAULT SECRETS"
}

variable "azure_keyvault_accesspolicy_principal_appid" {
    description = "Application ID of principal to use in setting kv access policy"
    default = "APPLICATION ID OF PRINCIPAL TO USE"
}

variable "cloud_provider" {
    description = "Cloud provider to use if required"
    default = "AZURE"
}

variable "azure_private_link_endpoint_name" {
    description = "Name to use for azure private link endpoint name"
    default = "PRIVATE LINK ENDPOINT NAME TO USE"
}

variable "private_service_connection_name" {
    description = "Name to use for your private service connection"
    default = "PRIVATE SERVICE CONNECTION NAME TO USE"
}

variable "subnet_id" {
    description = "Subnet id from azure virtual network"
}

variable "name_private_endpoint" {
    description = "Name of the Azure private endpoint"
    default = "PRIVATE ENDPOINT NAME TO USE"
}

variable "name_private_service_connection" {
    description = "Name of the private service connection in private endpoint"
    default = "PRIVATE SERVICE CONNECTION NAME TO USE"
}

variable "request_message_private_service_connection" {
    description = "Request messsage to include with private service connection in private endpoint"
    default = "REQUEST MESSAGE TO INCLUDE"
}