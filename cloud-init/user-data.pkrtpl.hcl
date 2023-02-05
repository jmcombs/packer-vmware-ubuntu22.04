#cloud-config
autoinstall:
  version: 1
  locale: en_US.UTF-8
  refresh-installer:
    update: true
  source:
    id: ubuntu-server-minimal
    search_drivers: false
  network:
    ethernets:
      ens160:
        dhcp4: true
    version: 2
  identity:
    realname: OS Admin
    username: ${ssh_username}
    hostname: ubuntu-server
    password: ${ssh_hashed_password}
  ssh:
    allow-pw: true
    authorized-keys: []
    install-server: true
  drivers:
    install: false
  packages: [open-vm-tools]
  kernel:
    package: linux-generic
  updates: security
