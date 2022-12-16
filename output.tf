output "harvester_url" {
  value = "https://${equinix_metal_reserved_ip_block.harvester_vip.network}/"
}

output "seed_ip" {
  value = data.equinix_metal_device.seed_device.access_public_ipv4
}

output "join_ips" {
  value = length(data.equinix_metal_device.join_devices) == 0 ? ["none"] : data.equinix_metal_device.join_devices.*.access_public_ipv4
}
