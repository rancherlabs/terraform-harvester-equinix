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

resource "metal_reserved_ip_block" "harvester_vip" {
  project_id = data.metal_project.project.project_id
  metro   = var.metro
  type = "public_ipv4"
  quantity   = 1
}


resource "metal_device" "seed" {
  hostname         = "harvester-pxe-1"
  plan             = var.plan
  metro            = var.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cylce
  project_id       = data.metal_project.project.project_id
  ipxe_script_url  = var.ipxe_script
  always_pxe       = "false"
  user_data        = templatefile("${path.module}/create.tpl", { password = random_password.password.result, token = random_password.token.result, vip = metal_reserved_ip_block.harvester_vip.network })
}

resource "metal_ip_attachment" "first_address_assignment" {
  device_id = metal_device.seed.id
  cidr_notation = join("/", [cidrhost(metal_reserved_ip_block.harvester_vip.cidr_notation, 0), "32"])
}


resource "metal_device" "join" {
  hostname         = "harvester-pxe-${count.index +2}"
  count            = "${var.node_count -1}"
  plan             = var.plan
  metro            = var.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cylce
  project_id       = data.metal_project.project.project_id
  ipxe_script_url  = var.ipxe_script
  always_pxe       = "false"
  user_data        = templatefile("${path.module}/join.tpl", { password = random_password.password.result, token = random_password.token.result, seed = metal_device.seed.access_public_ipv4 })
}