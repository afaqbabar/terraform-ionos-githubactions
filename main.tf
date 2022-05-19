module "dc" {
  source                 = "./dc"
  dc_name                = var.dc_name
  dc_location            = var.dc_location
  dc_description         = var.dc_description
  dc_sec_auth_protection = var.dc_sec_auth_protection
}
