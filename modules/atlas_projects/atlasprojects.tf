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

# PROJECT - Create the Atlas project that our clusters will run in
# Create a new project for cluster placement
resource "mongodbatlas_project" "iac_project" {
  name   = var.atlas_project_name
  org_id = var.organization

}


# PROJECT - NETWORK ACCESS - Controlled Ingress / Create IP whitelist
# This injects and allows 1 IP on access list - Note: you can use a CIDR range as well
resource "mongodbatlas_project_ip_whitelist" "allowed_ip" {
  project_id = mongodbatlas_project.iac_project.id
  ip_address = var.ip_whitelist
  comment    = var.ip_whitelist_comment
}

# PROJECT - AZURE KEY VAULT - Enable encryption at rest using customer key management
resource "mongodbatlas_encryption_at_rest" "key_vault" {
    project_id = mongodbatlas_project.iac_project.id 

    azure_key_vault = {
    enabled             = true
    client_id           = var.azure_keyvault_accesspolicy_principal_appid 
    azure_environment   = "AZURE"
    subscription_id     = var.azure_subscription
    resource_group_name = var.azure_rg
    key_vault_name      = var.key_vault_name 
    key_identifier      = var.key_identifier
    secret              = var.azure_authentication_secret
    tenant_id           = var.tenant_id
  }

}


# PROJECT - DATABASE ACCESS
resource "mongodbatlas_database_user" "beaker" {
  username           = "beaker"
  password           = "meep"
  project_id         = mongodbatlas_project.iac_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "dbforApp"
  }

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "jobCategory"
    value = "labAssistant"
  }

  scopes {
    name = var.cluster_name
    type = "CLUSTER"
  }
}

# PROJECT - ATLAS PRIVATE LINK ENDPOINT
resource "mongodbatlas_privatelink_endpoint" "iac_privatelink_endpoint" {
    project_id = mongodbatlas_project.iac_project.id
    provider_name = var.cloud_provider
    region = var.location
}

# PROJECT - ATLAS PRIVATE LINK ENDPOINT SERVICE
resource "mongodbatlas_privatelink_endpoint_service" "iac_privatelink_endpoint_service" {
    project_id = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.project_id
    private_link_id = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.private_link_id
    endpoint_service_id = azurerm_private_endpoint.iac_azure_private_endpoint.id  
    provider_name = var.cloud_provider
    private_endpoint_ip_address = azurerm_private_endpoint.iac_azure_private_endpoint.private_service_connection[0].private_ip_address
}

# PROJECT - AZURE PRIVATE LINK ENDPOINT - Configuration is being included here
# as it is easier to group and not require multiple depends_on meta-arguments
# Note, if this fails hardcode values of name in endpoint and private service connection and request message
resource "azurerm_private_endpoint" "iac_azure_private_endpoint" {
    #name = var.azure_private_link_endpoint_name
    name = var.name_private_endpoint
    resource_group_name = var.azure_rg
    location = var.location
    subnet_id = var.subnet_id

    private_service_connection {
        name = var.name_private_service_connection
        private_connection_resource_id = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.private_link_service_resource_id
        is_manual_connection = true
        request_message = var.request_message_private_service_connection
    }

}