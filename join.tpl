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
  networks:
    harvester-mgmt: # The management bond name. This is mandatory.
      interfaces:
      - name: enp2s0f0np0
      default_route: true
      method: dhcp
      bond_options:
        mode: balance-tlb
        miimon: 100
  device: /dev/sda
  iso_url: https://releases.rancher.com/harvester/v0.3.0/harvester-v0.3.0-amd64.iso
  tty: ttyS1,115200n8