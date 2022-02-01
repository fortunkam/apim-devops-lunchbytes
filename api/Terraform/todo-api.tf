terraform {
  backend "azurerm" {
    storage_account_name = "lbynt4wiscjkwnm"
    container_name       = "terraform-state"
    key                  = "todo.api.tfstate"
    
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.94.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  apimName = "lunchbytes-apim"
  resource_group_name = "LunchBytes"
}

data "azurerm_api_management" "apim" {
  name                = local.apimName
  resource_group_name = local.resource_group_name
}

resource "azurerm_api_management_backend" todo_backend {
    name               = "todo-backend"
    resource_group_name = local.resource_group_name
    api_management_name = data.azurerm_api_management.apim.name
    protocol           = "http"
    url                = "https://lunchbytes-web-app.azurewebsites.net/"
} 

resource "azurerm_api_management_api" "todo_api" {
  name                = "todo-api"
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Todo API"
  revision = "1"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("../swagger.json")
  }
}

resource "azurerm_api_management_api_policy" "todo_api_policy" {
  api_name            = azurerm_api_management_api.todo_api.name
  resource_group_name = local.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="todo-backend" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

