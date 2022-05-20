output "host" {
  description = "Output Host"
  value       = data.ionoscloud_k8s_cluster.k8s_cluster_01.config[0].clusters[0].cluster.server
  sensitive   = true
}

