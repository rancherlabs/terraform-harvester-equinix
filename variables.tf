variable "harvester_version" {
  type        = string
  default     = "v1.3.1"
  description = "Harvester version to be installed (Must be a valid version tag from https://github.com/rancherlabs/terraform-harvester-equinix/tree/main/ipxe)"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Number of nodes to deploy Harvester cluster"
}

variable "project_name" {
  type        = string
  default     = "Harvester Labs"
  description = "Name of the Equinix Metal project to deploy into, when not looking up by project_id"
}

variable "metal_create_project" {
  type        = bool
  default     = false
  description = "Create a Metal Project if this is 'true'. Else use provided 'project_name'"
}

variable "organization_id" {
  type        = string
  default     = ""
  description = "Equinix Metal organization ID to create or find a project in"
}

variable "project_id" {
  type        = string
  default     = ""
  description = "Equinix Metal project ID to deploy into, if not creating a new project or looking up by name"
}

variable "plan" {
  type        = string
  default     = "m3.small.x86"
  description = "Size of the servers to be deployed on Equinix metal (https://deploy.equinix.com/developers/docs/metal/hardware/standard-servers/)"
}

variable "billing_cycle" {
  description = "Equinix metal billing/invoice generation schedule (hourly/daily/monthly/yearly)"
  type        = string
  default     = "hourly"
}

variable "metro" {
  type        = string
  default     = "SG"
  description = "Equinix metal data center location (https://deploy.equinix.com/developers/docs/metal/locations/metros/). Examples: SG,SV,AM,MA,Ny,LA,etc."
}

variable "ipxe_script" {
  type        = string
  default     = "https://raw.githubusercontent.com/rancherlabs/terraform-harvester-equinix/main/ipxe/ipxe-"
  description = "URL to the iPXE script to use for booting the server (harvester_version will be appended to this without the 'v' prefix)"
}

variable "hostname_prefix" {
  type        = string
  default     = "harvester-pxe"
  description = "Prefix for resources to be created in equinix metal"
}

variable "spot_instance" {
  type        = bool
  default     = true
  description = "Set to true to use spot instance instead of on demand. Also set your max bid price if true."
}

variable "max_bid_price" {
  type        = string
  default     = "0.75"
  description = "Maximum bid price for spot request"
}

variable "ssh_key" {
  type        = string
  default     = ""
  description = "Your ssh key, examples: 'github: myghid' or 'ssh-rsa AAAAblahblah== keyname'"
}

variable "num_of_vlans" {
  type        = number
  default     = 2
  description = "Number of VLANs to be created"
}

variable "rancher_api_url" {
  type        = string
  default     = ""
  description = "Rancher API endpoint to manager your Harvester cluster"
}

variable "rancher_access_key" {
  type        = string
  default     = ""
  description = "Rancher access key"
}

variable "rancher_secret_key" {
  type        = string
  default     = ""
  description = "Rancher secret key"
}

variable "rancher_insecure" {
  type        = bool
  default     = false
  description = "Allow insecure connections to the Rancher API"
}

variable "api_key" {
  type        = string
  default     = ""
  description = "Equinix Metal authentication token. Required when using Spot Instances for HTTP pricing lookups. METAL_AUTH_TOKEN should always be set as an environment variable"
}

variable "use_cheapest_metro" {
  type        = bool
  default     = true
  description = "A boolean variable to control cheapest metro selection"
}
