resource "azurerm_resource_group" "resource_group" {
    name     = "rg-${var.suffix}"
    location = var.region

    tags = {}
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

data "template_file" "attacker-vm" {
  template = file(var.bootstrap-attacker-vm)
  vars = {}
}

data "template_file" "saprouter-vm" {
  template = file(var.bootstrap-saprouter-vm)
  vars = {}
}