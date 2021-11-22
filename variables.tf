variable node_count {
    default = "3"
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
    default = "https://raw.githubusercontent.com/ibrokethecloud/custom_pxe/master/harvester.ipxe"
}

variable hostname_prefix {
    default = "harvester-pxe"
}