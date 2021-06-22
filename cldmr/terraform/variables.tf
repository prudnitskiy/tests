variable "location" {
  description = "Specifies deployment location"
  default     = "westeurope"
}

variable "storage_size" {
  description = "Specifies deployment disk size"
  default     = "32"
}

variable "storage_type" {
  description = "Specifies deployment disk speed"
  default     = "Standard_LRS"
}

variable "admin_username" {
  description = "Admin username"
  default = "prudnitskiy"
}

variable "tags" {
  description = "Node variabels"
  default = {
    "source"  = "TF"
    "till"    = "290621"
    "project" = "cldmr"
    "region"  = "Netherlands"
  }
}
