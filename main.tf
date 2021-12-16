provider "azurerm" {
    features {}
}

terraform {
  backend "azurerm" {
      resource_group_name = "the_rg_on_azure"
      storage_account_name = "the_storage_account_nome"
      container_name = "the_blob_container_name"
      key = "terraform.tfstate"
  }
}

#This variable is the env var defined in the azure-pipeline.yml file
variable "imagebuild" {
  type = string
  description = "the build number used to tag the docker image"
}

resource "azurerm_resource_group" "docker_mvc_rg" {
  name     = "docker-mvc-resources"
  location = "West Europe"
}

resource "azurerm_container_group" "docker_mvc_cg" {
  name                = "docker-mvc-continst"
  location            = azurerm_resource_group.docker_mvc_rg.location
  resource_group_name = azurerm_resource_group.docker_mvc_rg.name
  ip_address_type     = "public"
  dns_name_label      = "danrub78"
  os_type             = "Linux"

  container {
    name   = "docker-mvc-app"
    image  = "danrub78/test:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }


}