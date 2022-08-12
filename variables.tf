variable harvester_version {
    default = "v1.0.2"
}

variable node_count {
    default = "2"
}

variable project_name {
    default = ""
}

variable plan {
    default = "c3.small.x86"
}

variable billing_cylce {
    default = "hourly"
}

variable metro {
    default = "SG"
}

variable facility {
    default = "sg1"
}

variable ipxe_script {
    default = "https://raw.githubusercontent.com/ibrokethecloud/custom_pxe/master/mac.ipxe"
}

variable hostname_prefix {
    default = "harvester-pxe"
}

variable spot_instance {
    default     = false
    description = "Set to true to use spot instance instead of on demand. Also set you max bid price if true."
}

variable max_bid_price {
    default     = "0.00"
    description = "Maximum bid price for spot request."
}

variable ssh_key {
    default     = ""
    description = "Your ssh key, examples: 'github: myghid' or 'ssh-rsa AAAAblahblah== keyname'" 
}
