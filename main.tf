terraform {

  required_version = ">= 0.14.0"

  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "= 6.2.1"
    }
  }

  cloud {
    organization = "ionos"

    workspaces {
      name = "ionos_githubActions"
    }
  }
}

module "dc" {
  source                 = "../dc"
  dc_name                = var.dc_name
  dc_location            = var.dc_location
  dc_description         = var.dc_description
  dc_sec_auth_protection = var.dc_sec_auth_protection
}

