resource "ionoscloud_datacenter" "afaq_dc" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = false
}

resource "ionoscloud_lan" "afaq_lan" {
  datacenter_id         = ionoscloud_datacenter.afaq_dc.id
  public                = false
  name                  = var.lan_name
}

resource "ionoscloud_ipblock" "afaq_ipblock" {
  location              = var.dc_location
  size                  = var.ipblock_size
  name                  = var.ipblock_name
}
