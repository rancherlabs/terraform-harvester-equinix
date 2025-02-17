terraform {
  required_version = ">= 1.2"
  provider_meta "equinix" {
    module_name = "harvester-equinix"
  }
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "3.0.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "5.1.0"
    }
  }
}

provider "equinix" {}

provider "http" {}

provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure   = var.rancher_insecure
}
