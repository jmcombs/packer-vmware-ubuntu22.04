#!/usr/bin/bash

# Prepares a Ubuntu Server guest operating system.

### Create a cleanup script. ###
echo '> Creating cleanup script ...'
sudo cat <<EOF > /tmp/cleanup.sh
#!/bin/bash
# Cleans all audit logs.
echo '> Cleaning all audit logs ...'
if [ -f /var/log/audit/audit.log ]; then
    truncate -s0 /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    truncate -s0 /var/log/lastlog
fi
# Cleans persistent udev rules.
echo '> Cleaning persistent udev rules ...'
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi
# Cleans /tmp directories.
echo '> Cleaning /tmp directories ...'
rm -rf /tmp/*
rm -rf /var/tmp/*
# Cleans SSH keys.
echo '> Cleaning SSH keys ...'
rm -f /etc/ssh/ssh_host_*
# Cleans apt-get.
echo '> Cleaning apt-get ...'
apt-get autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*
# Remove Machine ID
echo '> Removing the machine-id ...'
truncate -s0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
# Disable Password for root
echo '> Disabling password for root ...'
passwd -dl root
# Cleans shell history.
echo '> Cleaning shell history ...'
truncate -s0 ~/.bash_history
history -c
# Enable cloud-init customization engine for vSphere Guest
echo '> Enabling cloud-init customization engine for vSphere Guest ...'
if [ -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg ]; then
    rm /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
fi
if [ -f /etc/cloud/cloud.cfg.d/99-installer.cfg ]; then
    rm /etc/cloud/cloud.cfg.d/99-installer.cfg
fi
cat <<EOF1 > /etc/cloud/cloud.cfg.d/99-vmware-guest-customization.cfg
disable_vmware_customization: false
datasource:
  VMware:
  OVF:
EOF1
# Cleans boot options (grub)
echo `> Cleaning up grub ...`
sed -i -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
update-grub
# Disable Root Login to sshd
echo '> Disabling root and password login to sshd ...'
sed -i 's/^#\?PermitRootLogin.*/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/#PasswordAuthentication yes/' /etc/ssh/sshd_config
# Run cloud-init clean
echo '> Running cloud-init clean ...'
cloud-init clean --logs --seed
EOF

### Change script permissions for execution. ### 
echo '> Changeing script permissions for execution ...'
sudo chmod +x /tmp/cleanup.sh

### Executes the cleauup script. ### 
echo '> Executing the cleanup script ...'
sudo /tmp/cleanup.sh

### All done. ### 
echo '> Done.'  
echo '> Packer Template Build -- Complete'
