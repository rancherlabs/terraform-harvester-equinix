variable "harvester_version" {
  description = "Harvester version to be installed"
  default     = "v1.1.2"
}

variable "node_count" {
  description = "Number of nodes to deploy Harvester cluster"
  default     = "3"
}

variable "project_name" {
  description = "Name of the Equinix metal Project"
  default     = ""
}

variable "metal_create_project" {
  type        = bool
  default     = false
  description = "Create a Metal Project if this is 'true'. Else use provided 'project_name'"
}

variable "plan" {
  description = "Size of the servers to be deployed on Equinix metal"
  default     = "c3.small.x86"
}

variable "billing_cylce" {
  description = "Equinix metal billing/invoice generation schedule"
  default     = "hourly"
}

variable "metro" {
  description = "Equinix metal data center location. Examples: SG,SV,AM,MA,Ny,LA,etc."
  default     = "SG"
}

variable "ipxe_script" {
  description = "URL for booting the servers with IPXE"
  default     = "https://raw.githubusercontent.com/rancherlabs/harvester-equinix-terraform/main/ipxe/ipxe-"
}

variable "hostname_prefix" {
  description = "Prefix for resources to be created in equinix metal"
  default     = "harvester-pxe"
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
  description = "Equinix Metal authentication token"
  default     = ""
}

variable "use_cheapest_metro" {
  description = "A boolean variable to control cheapest metro selection"
  type        = bool
  default     = true
}
