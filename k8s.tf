resource "ionoscloud_datacenter" "dc_02" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = false
}

resource "ionoscloud_lan" "lan_01" {
  datacenter_id = ionoscloud_datacenter.afaq_dc.id
  public        = false
  name          = var.lan_name
}

resource "ionoscloud_ipblock" "ipblock_01" {
  location = var.dc_location
  size     = var.ipblock_size
  name     = var.ipblock_name
}

resource "ionoscloud_k8s_cluster" "k8s_cluster_01" {
  name        = var.k8s_name
  k8s_version = var.k8s_ver
  public      = true
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
}

resource "ionoscloud_k8s_node_pool" "k8s_node_pool_01" {
  datacenter_id  = ionoscloud_datacenter.afaq_dc.id
  k8s_cluster_id = ionoscloud_k8s_cluster.afaq_k8s_cluster.id
  name           = var.nodepool_name
  k8s_version    = ionoscloud_k8s_cluster.afaq_k8s_cluster.k8s_version
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
  auto_scaling {
    min_node_count = 1
    max_node_count = 1
  }
  cpu_family        = "INTEL_SKYLAKE"
  availability_zone = "AUTO"
  storage_type      = "SSD"
  node_count        = 1
  cores_count       = 2
  ram_size          = 2048
  storage_size      = 40
  public_ips        = [ionoscloud_ipblock.afaq_ipblock.ips[0], ionoscloud_ipblock.afaq_ipblock.ips[1]]
  lans {
    id   = ionoscloud_lan.afaq_lan.id
    dhcp = true
    routes {
      network    = "10.100.0.0/24"
      gateway_ip = "10.100.0.1"
    }
  }
  labels = {
    lab1 = "value1"
    lab2 = "value2"
  }
  annotations = {
    ann1 = "value1"
    ann2 = "value2"
  }
}
