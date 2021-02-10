#!/bin/bash

# This small wrapper script is to handle required modifications when running Terraform
# deployments of Atlas utilizing Azure Key Vault service for Atlas Encryption at Rest 
# using your Key Management (BYOK). 

# Due to current Terraform MongoDB Atlas not exposing ip address of MongoDB hosts
# You must first deploy clusters with the "Manage your own encryption keys (M10) and up
# flag as false ("off"). This value is set in the cluster code as "NONE". Once the cluster
# is up and running we need to pull fqdn host names from terraform.state and loop through 
# the values to perform a dig on the name and set the ip.

# Once the IPs are captured we need to update Azure Key Vault firewall with the new addresses
# and have Terraform call for a refresh to pick up the Key Vault changes and make the modifications.
# After Key Vault firewall has been updated we change the cluster encryption key flag to "AZURE"
# and have Terraform call for a refresh to pick up the cluster changes and turn on key management.


#############
# Functions #
#############

enable_cluster_encryption_keys() {

    # Declare array to hold Azure Key Vault firewall IP addresses

    declare -a ipaddr

    while IFS= read -r line_values || [ -n "$line_values" ]; do
        ipaddr+=("$line_values")
    done < ./data/ipaddress.txt

    # Used for testing...uncomment if you are modifying script to test IP address load into array
    #printf '%s\n' "${ipaddr[@]}"

    # Get IP address of hosts from terraform state, create array, perform dig on values to populate into Azure Key Vault Network ACLs
    IFS=, read -r -a host_ips <<< "$(jq -r '.outputs.cluster_base_connection_string.value' terraform.tfstate | sed -e 's/mongodb:\/\///' -e s'/:27017//g')";
        for i in "${host_ips[@]}"; 
            do ipaddr=("$(dig +short $i | sed 's/^/"/;s/$/",/')" "${ipaddr[@]}"); 
        done

    # Used for testing...uncomment if you are modifying script to test IP address load into array
    # printf '%s\n' "UPDATED ARRAY WITH NEW IP ADDRESS"
    # printf '%s\n' "${ipaddr[@]}"


    # Now that we have the host IP addresses lets update the Key Vault Network ACLs
    # NOTE - sed command below was written on Mac. To run on Linux you may have to remove the '.bak' (forced by Mac)
    sed -i '.bak' "s/\[[^][]*\]/[${ipaddr[*]}]/g" ./modules/azure_keyvault/variables.tf

    # Update ipaddress.txt for record of IPs that have been injected into Azure Key Vault Network ACLS
    cp ./data/ipaddress.txt ./data/ipaddress.txt.bak
    > ./data/ipaddress.txt
    printf '%s\n' "${ipaddr[@]}" > ./data/ipaddress.txt 



}


prep_cluster_encryption_keys() {

    # Change initial flag value of "NONE" to "AZURE" to enable cluster to use customer key for encryption
    # at rest. # NOTE - sed command below was written on Mac. To run on Linux you may have to remove the '.bak' (forced by Mac)

    sed -i 'bak' 's/"NONE"/"AZURE"/g' ./modules/atlas_clusters/clusters.tf 

}


deploy_atlas() {

    # Deploy single cluster instance into Atlas configuring all required components
    # Azure Resource Group
    # Azure Virtual Net
    # Azure Subnet
    # Azure Key Vault (with Network ACLs)
    # Atlas Project (with Encryption at Rest/Customer keys and Azure Private Endpoint, Database user, Network Acess)
    # Atlas Cluster - Single instance

    terraform apply --auto-approve
    prep_cluster_encryption_keys
    enable_cluster_encryption_keys
    terraform apply --auto-approve -target=module.azure_keyvault.azurerm_key_vault.iac_keyvault
    terraform apply --auto-approve -target=module.atlas_clusters.mongodbatlas_cluster.iac_cluster

}


destroy_environment() {

    terraform destroy --auto-approve
    cp ./data/ipaddress-atlas.txt ./data/ipaddress.txt 
    sed -i 'bak' 's/"AZURE"/"NONE"/g' ./modules/atlas_clusters/clusters.tf

    declare -a ipaddrreset

    while IFS= read -r line_values || [ -n "$line_values" ]; do
        ipaddrreset+=("$line_values")
    done < ./data/ipaddress.txt
    sed -i '.bak' "s/\[[^][]*\]/[]/g" ./modules/azure_keyvault/variables.tf
    sed -i '.bak' "s/\[[^][]*\]/[${ipaddrreset[*]}]/g" ./modules/azure_keyvault/variables.tf
    sed -i '.bak' 's/,,/,/g' ./modules/azure_keyvault/variables.tf

}

refresh_environment() {
    terraform refresh
}


quit() {
    clear
    echo "Thank you for using MongoDB Atlas!"
    echo "Have a nice day..."
    sleep 2
    exit
}

menu() {
    while [[ $INPUT != [Qq] ]]; do
    echo "Terraform - Atlas IAC"
    echo "---------------------"
    echo ""
    echo "Please choose from the available options:"
    echo ""
    echo "1) Deploy Atlas infrastructure"
    echo "2) Destroy Atlas infrastructure"
    echo "3) Run Terraform refresh"
    echo "Q) Quit"
    echo ""
    echo "Enter selection and hit return..."
    read INPUT

    case $INPUT in
        1)
            deploy_atlas
            ;;
        2)
            destroy_environment
            ;;
        3)  refresh_environment
            ;;
    Q | q)
            quit
            ;;
        *)
            echo "Invalid selection. Please choose from the available options."
            sleep 1
            ;;
        esac

    done
}


# Call Functions in order required to deploy infrastructure and then turn on customer Encryption at Rest key configurations.


#############
#   Main    #
#############


# Clear the screen to start fresh
clear

# Run main menu function
menu















