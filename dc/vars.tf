variable "dc_name" {
  description = "Name of DC"
  default     = "DC for k8s - 02"
}

variable "dc_location" {
  description = "The regional location where VDC will be created"
  default     = "de/fra"
}

variable "dc_description" {
  description = "Description of DC"
  default     = "DC for k8s - 02"
}

variable "dc_sec_auth_protection" {
  description = "Boolean value representing if the data center requires extra protection e.g. two factor protection"
  default     = false
}


