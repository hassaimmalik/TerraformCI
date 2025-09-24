terraform {
  required_version = "~> 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.43.0"
    }
  }

  cloud {
    organization = "ps-wayne-hoggett" # change to your Terraform Cloud org
    workspaces {
      name = "TerraformCI" # change to your workspace name
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tf-test-rg"
  location = "Central US"
}

# Create a Storage Account
resource "azurerm_storage_account" "storageaccount" {
  name                     = "tfstoracct${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Add a random integer to ensure the storage account name is unique
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}
