# Provider Variables
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Main Variables
variable "suffix" {
    type = string
    default = "saprouter-demo"
}
variable "region" {
    type = string
    default = "eastus2"
}

variable "bootstrap-attacker-vm" {
  type    = string
  default = "./configurations/setup_attacker-vm.txt"
}
variable "bootstrap-saprouter-vm" {
  type    = string
  default = "./configurations/setup_saprouter-vm.txt"
}

# FortiGate related variables
variable "bootstrap-fgtvm" {
  type    = string
  default = "./configurations/fgtvm.conf"
}
variable "adminusername" {
  type    = string
  default = "azureadmin"
}
variable "adminpassword" {
  type    = string
  default = "Fortinet123#"
}
variable "size" {
  type    = string
  default = "Standard_F4s"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}
variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}
variable "license" {
  type    = string
  description = "Provide PATH if BYOL licenses is used"
  default = ""
}
variable "flexvm_token" {
  type    = string
  default = ""
}
variable "fgtsku" {
  type = string
  default = "fortinet_fg-vm"
}
variable "fgtversion" {
  type    = string
  default = "7.4.0"
}

variable "fgtiface1" {
  type    = string
  default = "10.0.1.10"
}
variable "fgtiface2" {
  type    = string
  default = "10.0.2.10"
}
variable "fgtiface3" {
  type    = string
  default = "10.0.3.10"
}