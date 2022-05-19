terraform {
  cloud {
    organization = "ionos"

    workspaces {
      name = "ionos_githubActions"
    }
  }
}

