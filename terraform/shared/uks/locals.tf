locals {
  location-short = {
    "uksouth" = "uks"
  }

  name-suffix = join("-",[ var.service, local.location-short[var.location], var.env-code, "001"])
  gal-rg = join("-", ["rg","gal",local.name-suffix])
}