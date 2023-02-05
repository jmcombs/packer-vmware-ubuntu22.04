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
# Cleans shell history.
echo '> Cleaning shell history ...'
unset HISTFILE
history -cw
truncate -s0 ~/.bash_history
rm -rf /root/.bash_history
# Clear Hostname
echo '> Setting hostname to localhost ...'
truncate -s0 /etc/hostname
hostnamectl set-hostname localhost
# Remove Machine ID
echo '> Removing the machine-id ...'
truncate -s0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
# Enable cloud-init customization engine for vSphere Guest
echo '> Enabling cloud-init customization engine for vSphere Guest ...'
echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg
echo '> Running cloud-init clean ...'
cloud-init clean --seed
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
