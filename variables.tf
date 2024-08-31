variable "harvester_version" {
  default     = "v1.3.1"
  description = "Harvester version to be installed"
}

variable "node_count" {
  default     = "3"
  description = "Number of nodes to deploy Harvester cluster"
}

variable "project_name" {
  default     = ""
  description = "Name of the Equinix metal project"
}

variable "metal_create_project" {
  type        = bool
  default     = false
  description = "Create a Metal Project if this is 'true'. Else use provided 'project_name'"
}

variable "plan" {
  default     = "c3.small.x86"
  description = "Size of the servers to be deployed on Equinix metal"
}

variable "billing_cylce" {
  default     = "hourly"
  description = "Equinix metal billing/invoice generation schedule"
}

variable "metro" {
  default     = "SG"
  description = "Equinix metal data center location. Examples: SG,SV,AM,MA,Ny,LA,etc."
}

variable "ipxe_script" {
  default     = "https://raw.githubusercontent.com/rancherlabs/terraform-harvester-equinix/main/ipxe/ipxe-"
  description = "URL for booting the servers with IPXE"
}

variable "hostname_prefix" {
  default     = "harvester-pxe"
  description = "Prefix for resources to be created in equinix metal"
}

variable "spot_instance" {
  default     = false
  description = "Set to true to use spot instance instead of on demand. Also set you max bid price if true."
}

variable "max_bid_price" {
  default     = "0.00"
  description = "Maximum bid price for spot request."
}

variable "ssh_key" {
  default     = ""
  description = "Your ssh key, examples: 'github: myghid' or 'ssh-rsa AAAAblahblah== keyname'"
}

variable "num_of_vlans" {
  default     = 0
  description = "Number of VLANs to be created"
}

variable "rancher_api_url" {
  default     = ""
  description = "Rancher API endpoint to manager your Harvester cluster"
}

variable "rancher_access_key" {
  default     = ""
  description = "Rancher access key"
}

variable "rancher_secret_key" {
  default     = ""
  description = "Rancher secret key"
}

variable "rancher_insecure" {
  default     = false
  description = "Allow insecure connections to the Rancher API"
}
variable "api_key" {
  type        = string
  default     = ""
  description = "Equinix Metal authentication token"
}

variable "use_cheapest_metro" {
  type        = bool
  default     = true
  description = "A boolean variable to control cheapest metro selection"
}
