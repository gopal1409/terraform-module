locals {
  owners               = var.business_devision #sap
  environment          = var.environment       #dev 
  resource_name_prefix = "${var.business_devision}-${var.environment}"
  #sap-dev
  common_tags = {              #common tag is the named
    owners      = local.owners #to call a local varaibles you need to use local.nameof the varaibles
    environment = local.environment
  }
}