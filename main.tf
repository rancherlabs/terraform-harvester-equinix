locals {
  project_id = var.metal_create_project ? equinix_metal_project.new_project[0].id : data.equinix_metal_project.project[0].project_id
  metro      = (var.spot_instance && var.use_cheapest_metro && local.cheapest_metro_price != null) ? local.cheapest_metro_price.metro : lower(var.metro)
}

// IP attachment to be added to seed node, and this is subsequently assigned as Harvester vip
// in the config.yaml
resource "random_password" "password" {
  length  = 16
  special = false
}

resource "random_password" "token" {
  length  = 16
  special = false
}

resource "equinix_metal_project" "new_project" {
  count           = var.metal_create_project ? 1 : 0
  name            = var.project_name
  organization_id = var.organization_id == "" ? null : var.organization_id
}

locals {
  machine_size = var.plan
  pricing_data = (var.spot_instance && var.use_cheapest_metro) ? try(jsondecode(data.http.prices[0].response_body), null) : null
  least_bid_price_metro = can(local.pricing_data) && can(local.pricing_data.spot_market_prices) ? flatten([for metro, machines in local.pricing_data.spot_market_prices : [
    for machine, details in machines : {
      metro   = metro
      machine = machine
      price   = details.price
    } if machine == local.machine_size
  ]]) : []
  cheapest_metro_price = length(local.least_bid_price_metro) > 0 ? {
    price = min([for price in local.least_bid_price_metro : price.price]...),
    metro = [for price in local.least_bid_price_metro : price.metro if price.price == min([for price in local.least_bid_price_metro : price.price]...)][0]
  } : null
}

## Keeping it commented for debugging purposes. Will remove once verified.
#output "http_response" {
#  value = data.http.prices.response_body
#}

resource "equinix_metal_reserved_ip_block" "harvester_vip" {
  project_id = local.project_id
  metro      = local.metro
  type       = "public_ipv4"
  quantity   = 1
}

resource "equinix_metal_device" "seed" {
  hostname         = "${var.hostname_prefix}-1"
  count            = var.node_count >= 1 && !var.spot_instance ? 1 : 0
  plan             = var.plan
  metro            = local.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cycle
  project_id       = local.project_id
  ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
  always_pxe       = "false"
  user_data        = templatefile("${path.module}/create.tpl", { version = var.harvester_version, password = random_password.password.result, token = random_password.token.result, vip = equinix_metal_reserved_ip_block.harvester_vip.network, hostname_prefix = var.hostname_prefix, ssh_key = var.ssh_key, count = "1", cluster_registration_url = var.rancher_api_url != "" ? rancher2_cluster.rancher_cluster[0].cluster_registration_token[0].manifest_url : "" })
}

resource "equinix_metal_spot_market_request" "seed_spot_request" {
  count            = var.node_count >= 1 && var.spot_instance ? 1 : 0
  project_id       = local.project_id
  max_bid_price    = (var.use_cheapest_metro && local.cheapest_metro_price != null) ? local.cheapest_metro_price.price : var.max_bid_price
  metro            = local.metro
  devices_min      = 1
  devices_max      = 1
  wait_for_devices = true

  instance_parameters {
    hostname         = "${var.hostname_prefix}-1"
    billing_cycle    = "hourly"
    operating_system = "custom_ipxe"
    ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
    plan             = var.plan
    userdata         = templatefile("${path.module}/create.tpl", { version = var.harvester_version, password = random_password.password.result, token = random_password.token.result, vip = equinix_metal_reserved_ip_block.harvester_vip.network, hostname_prefix = var.hostname_prefix, ssh_key = var.ssh_key, count = "1", cluster_registration_url = var.rancher_api_url != "" ? rancher2_cluster.rancher_cluster[0].cluster_registration_token[0].manifest_url : "" })
  }
}


resource "equinix_metal_ip_attachment" "first_address_assignment" {
  device_id     = var.spot_instance ? data.equinix_metal_spot_market_request.seed_req.0.device_ids[0] : equinix_metal_device.seed.0.id
  cidr_notation = join("/", [cidrhost(equinix_metal_reserved_ip_block.harvester_vip.cidr_notation, 0), "32"])
}

resource "equinix_metal_device" "join" {
  hostname         = "${var.hostname_prefix}-${count.index + 2}"
  count            = var.spot_instance ? 0 : var.node_count - 1
  plan             = var.plan
  metro            = local.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cycle
  project_id       = local.project_id
  ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
  always_pxe       = "false"
  user_data        = templatefile("${path.module}/join.tpl", { version = var.harvester_version, password = random_password.password.result, token = random_password.token.result, seed = equinix_metal_reserved_ip_block.harvester_vip.network, hostname_prefix = var.hostname_prefix, ssh_key = var.ssh_key, count = "${count.index + 2}" })
}

resource "equinix_metal_spot_market_request" "join_spot_request" {
  count            = var.spot_instance ? var.node_count - 1 : 0
  project_id       = local.project_id
  max_bid_price    = (var.use_cheapest_metro && local.cheapest_metro_price != null) ? local.cheapest_metro_price.price : var.max_bid_price
  metro            = local.metro
  devices_min      = 1
  devices_max      = 1
  wait_for_devices = true

  instance_parameters {
    hostname         = "${var.hostname_prefix}-${count.index + 2}"
    billing_cycle    = "hourly"
    operating_system = "custom_ipxe"
    ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
    plan             = var.plan
    userdata         = templatefile("${path.module}/join.tpl", { version = var.harvester_version, password = random_password.password.result, token = random_password.token.result, seed = equinix_metal_reserved_ip_block.harvester_vip.network, hostname_prefix = var.hostname_prefix, ssh_key = var.ssh_key, count = "${count.index + 2}" })
  }
}

resource "equinix_metal_vlan" "vlans" {
  count       = var.num_of_vlans
  description = "VLAN for ${var.hostname_prefix}"
  project_id  = local.project_id
  metro       = local.metro
}

resource "equinix_metal_port_vlan_attachment" "vlan_attach_seed" {

  count     = var.num_of_vlans
  device_id = data.equinix_metal_device.seed_device.id
  vlan_vnid = equinix_metal_vlan.vlans[count.index].vxlan
  port_name = "bond0"
}

resource "equinix_metal_port_vlan_attachment" "vlan_attach_join" {

  count     = var.num_of_vlans * (var.node_count - 1)
  device_id = data.equinix_metal_device.join_devices[count.index % (var.node_count - 1)].id
  vlan_vnid = equinix_metal_vlan.vlans[floor(count.index / (var.node_count - 1))].vxlan
  port_name = "bond0"
}

resource "rancher2_cluster" "rancher_cluster" {
  name        = var.hostname_prefix
  count       = var.rancher_api_url != "" ? 1 : 0
  description = "${var.hostname_prefix} created by Terraform"
}

resource "local_file" "harvester_kubeconfig" {
  count    = var.rancher_api_url != "" ? 1 : 0
  content  = rancher2_cluster.rancher_cluster[0].kube_config
  filename = "${var.hostname_prefix}-kubeconfig.yaml"
}