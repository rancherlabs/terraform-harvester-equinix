data "equinix_metal_project" "project" {
  name = var.project_name
}


data "equinix_metal_ip_block_ranges" "address_block" {
  project_id = data.equinix_metal_project.project.project_id
  metro = var.metro
}
