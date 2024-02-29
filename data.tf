data "equinix_metal_project" "project" {
  name = var.metal_create_project ? equinix_metal_project.new_project[0].name : var.project_name
}

data "equinix_metal_ip_block_ranges" "address_block" {
<<<<<<< HEAD
  project_id = local.project_id
  metro      = var.metro
=======
  project_id = data.equinix_metal_project.project.project_id
<<<<<<< HEAD
  metro      = local.cheapest_metro_price.metro
>>>>>>> acfa1e1 (initial commit for issue-15)
=======
  metro      = local.cheapest_metro_price.metro 
>>>>>>> 1016292 (Dynamically grab pricing data and choose cheapest metro for spot pricing)
}


data "equinix_metal_spot_market_request" "seed_req" {
  count      = var.spot_instance ? 1 : 0
  request_id = equinix_metal_spot_market_request.seed_spot_request.0.id
}


data "equinix_metal_spot_market_request" "join_req" {
  count      = var.spot_instance ? var.node_count - 1 : 0
  request_id = equinix_metal_spot_market_request.join_spot_request[count.index].id
}


data "equinix_metal_device" "seed_device" {
  device_id = var.spot_instance ? data.equinix_metal_spot_market_request.seed_req.0.device_ids[0] : equinix_metal_device.seed.0.id
}

data "equinix_metal_device" "join_devices" {
  count     = var.node_count - 1
  device_id = var.spot_instance ? data.equinix_metal_spot_market_request.join_req[count.index].device_ids[0] : equinix_metal_device.join[count.index].id
}



