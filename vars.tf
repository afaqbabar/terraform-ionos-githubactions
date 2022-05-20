variable "dc_name" {
  description = "Name of DC"
  default     = "DC for k8s - 02"
}

variable "dc_location" {
  description = "The regional location where VDC will be created"
  default     = "de/fra"
}

variable "dc_description" {
  description = "Description of DC"
  default     = "DC for k8s - 02"
}

variable "lan_name" {
  description = "Name of Private LAN"
  default     = "afaq_lan_01"
}

variable "ipblock_name" {
  description = "Name of IP block"
  default     = "afaq_ipblock_01"
}

variable "ipblock_size" {
  description = "Size of IP block"
  default     = 3
}

variable "k8s_name" {
  description = "Name of k8s cluster"
  default     = "k8s_cluster_01"
}

variable "k8s_ver" {
  description = "K8s Version"
  default     = "1.22.8"
}

variable "nodepool_name" {
  description = "Name of node pool"
  default = "k8s_nodepool_01"
}

