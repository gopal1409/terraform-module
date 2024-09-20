resource "azurerm_resource_group" "rg" { #refrence block
  name = "${local.resource_name_prefix}-${var.resource_group_name}"
  #sap-dev-rg-default 
  location = var.resource_group_location
  tags     = local.common_tags

}

#inside the resource block we have define attributes 
#this attributes should in key vlaue format seprated using equal sign
#there are some attributes which is required 
