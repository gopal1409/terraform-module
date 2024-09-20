##to create resource what we define 
variable "resource_group_name" {
  description = "you can change the resource group name from here"
  type        = string #list of string #map numeric bool
  default     = "rg-prod"
}

variable "resource_group_location" {
  description = "location for the resource group"
  type        = string
  default     = "eastus2"
}