resource "ionoscloud_datacenter" "afaq_dc" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = false
}

resource "ionoscloud_lan" "afaq_lan" {
  datacenter_id = ionoscloud_datacenter.afaq_dc.id
  public        = false
  name          = var.lan_name
}

resource "ionoscloud_ipblock" "afaq_ipblock" {
  location = var.dc_location
  size     = var.ipblock_size
  name     = var.ipblock_name
}

resource "ionoscloud_k8s_cluster" "afaq_k8s_cluster" {
  name                  = var.k8s_name
  k8s_version           = var.k8s_ver
  public                = true
  maintenance_window {
    day_of_the_week     = "Sunday"
    time                = "09:00:00Z"
  }
}
