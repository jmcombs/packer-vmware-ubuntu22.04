##################################################################################
# VARIABLES
#  - Variables commented out are in secure vault or passed as environment variables
##################################################################################

# OS Build Credentials

#ssh_username
#ssh_password

# vCenter Objects

#vcenter_username
#vcenter_password
#vcenter_server
#vcenter_datacenter
#vcenter_cluster
#vcenter_insecure_connection

# Guest OS Objects

#vm_name
#vm_folder
#vm_guest_os_type
#vm_version
#vm_firmware
#vm_cdrom_type
#vm_cpu
#vm_ram
#vm_datastore
#vm_disk_size
#vm_disk_thinprovisioned
#vm_disk_controller_type
#vm_network_card
#vm_network
#vm_boot_wait

# ISO Objects

iso_file                    = "ubuntu-22.04-live-server-amd64.iso"
iso_checksum                = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
iso_checksum_type           = "sha256"
iso_path                    = "[synds720-software-ds1] Ubuntu/"

# Scripts

shell_scripts               = ["./scripts/clean-server.sh"]