terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.8.2"
    }
  }
}
# DATA SOURCES - Data Sources to reference required information in building/modifying our resources

# This data source is to handle chicken/egg of connection strings to feed into Azure Key Vault. 
# Resource needs to complete first, then we need to be able to access that resulting attributes
# for downstream build out
data "mongodbatlas_cluster" "iac_clusterdata" {
    project_id = mongodbatlas_cluster.iac_cluster.project_id
    name = mongodbatlas_cluster.iac_cluster.name     

    depends_on = [ mongodbatlas_cluster.iac_cluster]
}

# CLUSTERS - Create the cluster in the project 
# Create a new cluster
resource "mongodbatlas_cluster" "iac_cluster" {
  # CLUSTER SPECIFICS - name, clustertype, region and replicaset info
  project_id = var.atlas_project_id
  name       = var.cluster_name
  cluster_type = "REPLICASET"
  replication_specs {
      num_shards = 1
      regions_config {
          region_name = var.region
          electable_nodes = var.electable_nodes
          priority = var.region_priority
          read_only_nodes = var.read_only_nodes
          analytics_nodes = var.analytics_nodes
      }
  }

  # CLUSTER CLOUD PROVIDER - Set cloud provider specifics
  provider_name         = var.cloud_provider
  provider_instance_size_name = var.cluster_tier 
  provider_disk_type_name = var.disk_size 

  
  # CLUSTER AUTO SCALING - Note you will want to uncomment auto_scaling if using free tier
  # If not shared tenant (eg non-free tier Atlas) scaling will be auto enabled. It is
  # safe to comment out the auto_scaling block if not concerned about CPU scaling. 
  # NOTE: If you comment out auto_scaling ensure you comment out the lifecycle block as well. 
  
  #auto_scaling_disk_gb_enabled = false
  auto_scaling_compute_enabled = false
  
  # CLUSTER - LIFECYCLE RESOURCES - This is needed for auto_scaling. If not using auto
  # scaling settings you can comment the lifecycle block out. If you were to run a 
  # terraform plan/apply and Atlas had scaled prior automatically due to contraints 
  # terraform would try to reset the cluster back to what matched in state. 
  # If you need to manually/explicitly change the cluster size comment out the
  # lifecycle block and then run terraform plan/apply. Ensure to uncomment once
  # done to prevent any other accidental changes.

  lifecycle {
      ignore_changes = [ provider_instance_size_name, provider_disk_type_name,]
  }
  
  # CLUSTER - MONGODB VERSION - Set MongoDB version you want to use
  mongo_db_major_version       = "4.4"

  # CLUSTER - BACKUP - Set if you want cloud backups and pit (point in time) enabled
  provider_backup_enabled = true
  pit_enabled = true 

  # ENCRYPTION AT REST - Set for client managed keys for encryption at rest
  # Use "NONE" as value to enable encryption at rest on cluster
  encryption_at_rest_provider = "NONE"

}
