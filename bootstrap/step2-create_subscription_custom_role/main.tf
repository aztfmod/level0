provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = "~> 2.8.0"
  }
}

data "azurerm_subscription" "primary" {}

data "terraform_remote_state" "step1" {

  backend = "local" 

  config = {
    path = "${var.step1_tfstate_path}/terraform.tfstate"
  }

}