terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.51.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "06c057c2-d971-49ba-beae-0e0b0a40cecd"
    tenant_id = "4355b790-1afd-4678-90ad-6403216d1814"
    client_id = "0e0993a7-dd6c-4d46-ad9d-16cad7136b01"
    client_secret = "_DB8Q~8JEcHkHg-C_lAuav6wrtrJbuiYRgb3iaze"
    features {}
 }