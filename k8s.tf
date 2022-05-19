resource "ionoscloud_datacenter" "afaq_dc" {
  name                = "Afaq Datacenter-02"
  location            = "de/fra"
  description         = "Test datacenter for K8s and other resources using Terraform & Github Actions"
  sec_auth_protection = false
}
