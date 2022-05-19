terraform {

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

