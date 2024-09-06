data "equinix_metal_project" "project" {
  count = var.metal_create_project ? 0 : 1

  name       = var.project_name == "" ? null : var.project_name
  project_id = var.project_id == "" ? null : var.project_id

  lifecycle {
    precondition {
      condition     = !(var.project_name != "" && var.project_id != "")
      error_message = "Only one of project_name or project_id can be set"
    }
    precondition {
      condition     = var.project_name != "" || var.project_id != ""
      error_message = "One of project_name or project_id must be set when metal_create_project is false"
    }
  }
}

data "equinix_metal_ip_block_ranges" "address_block" {
  project_id = local.project_id
  metro      = (var.spot_instance && var.use_cheapest_metro) ? local.cheapest_metro_price.metro : var.metro
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

data "http" "prices" {
  count  = var.spot_instance && var.use_cheapest_metro ? 1 : 0
  url    = "https://api.equinix.com/metal/v1/market/spot/prices/metros"
  method = "GET"
  request_headers = {
    "X-Auth-Token" = var.api_key
  }
}

