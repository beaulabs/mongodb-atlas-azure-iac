variable "atlas_project_id" {
    description = "Atlas project id to deploy clusters into"
    
}

variable "cluster_name" {
  description = "The name to use for cluster under project"
  default     = "FILL IN NAME OF CLUSTER"
}

variable "cloud_provider" {
  description = "The cloud provider to place cluster in - AWS / Azure / GCP"
  default     = "AZURE"
}

variable "region" {
  description = "The region in which to place the cluster"
  default     = "US_CENTRAL"
}

variable "cluster_tier" {
    description = "The cluster tier size you desire - eg M30, M40, etc"
    default = "M30"
}

variable "disk_size" {
    description = "The cluster disk size to initialize with in GB"
    default = "P6"
}

variable "electable_nodes" {
    description = "The number of electable nodes in your replicaset"
    default = 3
}

variable "region_priority" {
    description = "Election priority of the region"
    default = 7
}

variable "read_only_nodes" {
    description = "The number of read only nodes in your replicaset"
    default = 0
}

variable "analytics_nodes" {
    description = "The number of analytical nodes in your replicaset"
    default = 0
}
