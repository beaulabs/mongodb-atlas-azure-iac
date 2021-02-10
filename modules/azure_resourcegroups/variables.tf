variable "azure_subscription" {
    description = "The Azure subscription to use"
    default = "FILL IN AZURE SUBSCRIPTION TO USE"
}

variable "azure_rg" {
    description = "The Azure resource group to use"
    default = "FILL IN NAME OF AZURE RESOURCE GROUP"
}

variable "azure_location" {
    description = "Azure location to use for resources"
    default = "Central US"
}

variable "azure_virtual_net" {
    description = "Virtual network name"
    default = "FILL IN VIRTUAL NETWORK NAME"
}

variable "address_space_subnet_name" {
    description = "Address space subnet name"
    default = "FILL IN VIRTUAL NETWORK SUBNET NAME"
}


