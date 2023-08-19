locals {
  location-short = {
    "uksouth" = "uks"
  }

  name-suffix = join("-", [var.service, local.location-short[var.location], var.env-code, "001"])
  gal-rg      = join("-", ["rg", "gal", local.name-suffix])
  vm-rg       = join("-", ["rg", "vm", local.name-suffix])
  net-rg      = join("-", ["rg", "corenet", local.name-suffix])
  vm-name     = join("-", ["vm", local.name-suffix])
}