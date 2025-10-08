terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group existant
data "azurerm_resource_group" "main" {
  name = "RG-Thibault-Gibard"
}