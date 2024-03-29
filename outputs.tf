output "harvester_url" {
  value       = "https://${equinix_metal_reserved_ip_block.harvester_vip.network}/"
  description = "The URL to reach the Harvester user interface"
}

output "public_ips" {
  value       = concat([data.equinix_metal_device.seed_device.access_public_ipv4], data.equinix_metal_device.join_devices.*.access_public_ipv4)
  description = "The public IP addresses of all Harvester nodes"
}

output "out_of_band_hostnames" {
  value       = concat([data.equinix_metal_device.seed_device.sos_hostname], data.equinix_metal_device.join_devices.*.sos_hostname)
  description = "Out of band hostnames for SSH access to the console"
}
