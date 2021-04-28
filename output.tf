resource "local_file" "ssh_key" {
    content = tls_private_key.ssh_key.private_key_pem
    filename = "${path.module}/ssh_key.pem"
    file_permission = "0600"
}
# Output private IP addresses
output "private_ip_saprouter" {
    value = azurerm_network_interface.saprouter_nic.private_ip_address
}
output "private_ip_target" {
    value = azurerm_network_interface.target_nic.private_ip_address
}
output "private_ip_attacker" {
    value = azurerm_network_interface.attackervm_nic.private_ip_address
}
# Output public IP addresses
output "public_ip_fortigate" {
    value = azurerm_public_ip.FGTPublicIp.ip_address
}
output "public_ip_attacker" {
    value = azurerm_public_ip.attacker_publicip.ip_address
}
# Output credentials
output "OS-Username" {
  value = "${var.suffix}-admin"
}
output "FGT-Username" {
  value = var.adminusername
}
output "Password" {
  value = var.adminpassword
}