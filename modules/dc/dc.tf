resource "ionoscloud_datacenter" "afaq_dc" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = var.dc_sec_auth_protection
}
