# vRealize Automation Terraform Provider Example
# 
# By: Cody De Arkland (cdearkland@vmware.com)
#
# This example leverages Consul and Vault for state and secret storage respectively
# SovLabs vRealize Automation Plugis are leveraged as well 
# Ensure you have populated a terraform.tfvars file before proceeding to apply this manifest
# Required tfvars are: 
#   username
#   tenant
#   host 
# Required variables can always be viewed in variables.tf 

terraform {
  backend "consul" {
    address = "localhost:8500"
    path    = "vars/state"
  }
}

provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"
}

data "vault_generic_secret" "auth" {
  path = "secret/password"
}

provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
}

provider  "vra7" {
    username = "${data.vault_generic_secret.auth.data["user"]}"
    password  = "${data.vault_generic_secret.auth.data["pass"]}"
    tenant = "${var.tenant}"
    host = "${var.host}"
}

resource "vra7_resource" "DB_Server" {
  count            = 1
  catalog_name = "CentOS 7"

  catalog_configuration = {
    _deploymentName = "DB Demo"
  }

  resource_configuration = {    
    CentOS.cpu = "2"
    CentOS.memory = "4096"
    CentOS.os = "ce"
    CentOS.app = "dbs"
    CentOS.tier = "dev"
  }
}

  resource "vra7_resource" "WEB_Server" {
  count            = 1
  catalog_name = "CentOS 7"

  catalog_configuration = {
    _deploymentName = "Web Demo"
  }

  resource_configuration = {    
    CentOS.cpu = "1"
    CentOS.memory = "2048"
    CentOS.os = "ce"
    CentOS.app = "web"
    CentOS.tier = "dev"
  }
  }

  resource "vra7_resource" "App_Server" {
  count            = 1
  catalog_name = "CentOS 7"

  catalog_configuration = {
    _deploymentName = "App Demo"
  }

  resource_configuration = {    
    CentOS.cpu = "4"
    CentOS.memory = "2048"
    CentOS.os = "ce"
    CentOS.app = "app"
    CentOS.tier = "dev"
  }
}
