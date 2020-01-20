resource "azurerm_resource_group" "rg" {
  name     = "${random_string.prefix.result}-terraform-state"
  location = var.location

  tags = {
    blueprint   = "tfstate"
    workspace   = var.workspace 
  }
}