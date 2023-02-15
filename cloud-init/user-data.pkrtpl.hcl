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
  user-data:
    disable_root: false
    chpasswd:
      expire: false
      list:
        - root:${ssh_hashed_password}
  identity:
    hostname: ubuntu-server
    username: ${ssh_username}
    password: ${ssh_hashed_password}
  ssh:
    authorized-keys: []
    install-server: true
  drivers:
    install: false
  packages: [open-vm-tools]
  kernel:
    package: linux-generic
  updates: security
  late-commands:
  - |
    cat <<EOF | sudo tee /target/tmp/post-install.sh
    #!/bin/bash
    if grep -iq PermitRootLogin /target/etc/ssh/sshd_config; then
        sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /target/etc/ssh/sshd_config
    else
        echo "PermitRootLogin yes" >>  /target/etc/ssh/sshd_config
    fi
    if grep -iq PasswordAuthentication /target/etc/ssh/sshd_config; then
        sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /target/etc/ssh/sshd_config
    else
        echo "PasswordAuthentication yes" >>  /target/etc/ssh/sshd_config
    fi
    EOF
  - chmod 755 /target/tmp/post-install.sh
  - sudo sh /target/tmp/post-install.sh
