output "cluster_base_connection_string" {
  description = "The base connection string"
  value       = mongodbatlas_cluster.iac_cluster.mongo_uri
}

output "cluster_private_endpoint_string" {
  description = "The strings you can use to connect to this cluster through a private endpoint"
  value = mongodbatlas_cluster.iac_cluster.connection_strings[0].private_endpoint[0].srv_connection_string
}