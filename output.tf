output "harvester_url" {
  value = "https://${equinix_metal_reserved_ip_block.harvester_vip.network}/"
}
