terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      version = "1.10.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.2"
    }
  }
}

provider "equinix" {}

provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure   = var.rancher_insecure
}
