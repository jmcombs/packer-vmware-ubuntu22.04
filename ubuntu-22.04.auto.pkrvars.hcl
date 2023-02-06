##################################################################################
# VARIABLES
#  - Variables commented out are in secure vault
##################################################################################

# OS Build Credentials

#ssh_username
#ssh_password

# vSphere Objects

#vcenter_username
#vcenter_password
#vcenter_server
vcenter_insecure_connection     = true
#vcenter_datacenter
#vcenter_cluster
#vcenter_datastore
#vcenter_network
vcenter_folder                  = "Templates"

# Virtual Machine Settings

vm_name                     = "Ubuntu 22.04 Minimal"
vm_guest_os_type            = "ubuntu64Guest"
vm_version                  = 19
vm_firmware                 = "bios"
vm_cdrom_type               = "sata"
vm_cpu_sockets              = 2
vm_cpu_cores                = 1
vm_mem_size                 = 16384
vm_disk_size                = 102400
thin_provision              = false
vm_disk_controller_type     = ["lsilogic"]
vm_network_card             = "vmxnet3"
vm_boot_wait                = "5s"

# ISO Objects

iso_file                    = "ubuntu-22.04-live-server-amd64.iso"
iso_checksum                = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
iso_checksum_type           = "sha256"
iso_path                    = "[synds720-software-ds1] Ubuntu/"

# Scripts

shell_scripts               = ["./scripts/clean-server.sh"]