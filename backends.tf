terraform {
  cloud {
    organization = "terraformlocal"

    workspaces {
      name = "terraformodules"
    }
  }
}