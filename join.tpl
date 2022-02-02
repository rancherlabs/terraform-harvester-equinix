#cloud-config
server_url: https://${seed}:8443
token: "${token}"
os:
  ssh_authorized_keys:
  - github:ibrokethecloud
  password: "${password}"
  hostname: "${hostname_prefix}-${count}"
install:
  mode: join
  device: /dev/sda
  iso_url: https://releases.rancher.com/harvester/v1.0.0/harvester-v1.0.0-amd64.iso
  tty: ttyS1,115200n8