#cloud-config
token: "${token}"  # replace with a desired token
os:
  ssh_authorized_keys:
  - github:ibrokethecloud
  password: "${password}"  # replace with a your password
  hostname: "${hostname_prefix}-${count}"
install:
  mode: create
  device: /dev/sda
  iso_url: https://releases.rancher.com/harvester/v1.0.1/harvester-v1.0.1-amd64.iso
  tty: ttyS1,115200n8
  vip: ${vip}
  vip_mode: static
