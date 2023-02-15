variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_hashed_password" {
  type    = string
  description = "The hashed password to use to authenticate over SSH."
  default = ""
  sensitive = true
}

# vSphere Objects

variable "vcenter_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vcenter_host" {
  type = string
  description = "The ESXi host where target VM is created."
  default = ""
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where target VM is created."
  default = ""
}

# ISO Objects

variable "iso_path" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
  }

variable "iso_url" {
  type    = string
  description = "The url to retrieve the iso image"
  default = ""
  }

variable "iso_file" {
  type = string
  description = "The file name of the guest operating system ISO image installation media."
  default = ""
}

variable "iso_checksum" {
  type    = string
  description = "The checksum of the ISO image."
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  description = "The checksum type of the ISO image. Ex: sha256"
  default = ""
}

# HTTP Endpoint

variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = ""
}

# Virtual Machine Settings

variable "vm_name" {
  type    = string
  description = "The template vm name"
  default = ""
}

variable "vm_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
  default = ""
}

variable "vm_guest_os_type" {
  type    = string
  description = "The guest operating system type, also know as guestid."
  default = ""
}

variable "vm_version" {
  type = number
  description = "The VM virtual hardware version."
  # https://kb.vmware.com/s/article/1003746
}

variable "vm_firmware" {
  type    = string
  description = "The virtual machine firmware. (e.g. 'bios' or 'efi')"
  default = ""
}

variable "vm_cdrom_type" {
  type    = string
  description = "The virtual machine CD-ROM type."
  default = ""
}

variable "vm_cpu" {
  type = number
  description = "The number of vCPUs"
}

variable "vm_ram" {
  type = number
  description = "The amount of vRAM (in MB)"
}

variable "vm_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}

variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "vm_disk_thinprovisioned" {
  type = bool
  description = "Thin or Thick provisioning of the disk"
}

variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
}

variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  default = ""
}

variable "vm_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = ""
}

variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  default = ""
}

variable "shell_scripts" {
  type = list(string)
  description = "A list of scripts."
  default = []
}

##################################################################################
# LOCALS
##################################################################################

locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  templatevars = {
    ssh_username = var.ssh_username,
    ssh_hashed_password = var.ssh_hashed_password
  }
}

##################################################################################
# SOURCE
##################################################################################

source "vsphere-iso" "linux-ubuntu-server" {
  # Build Configuration/Type
  convert_to_template = true
  # Boot Configuration
  boot_wait = var.vm_boot_wait
  boot_command = [
    "e<down><down><down><end>",
    " autoinstall ds=nocloud;",
    "<F10>"
  ]
  # vCenter Configuration
  vcenter_server = var.vcenter_server
  username = var.vcenter_username
  password = var.vcenter_password
  insecure_connection = var.vcenter_insecure_connection
  datacenter = var.vcenter_datacenter
  # Virtual Machine Hardware Configuration
  CPUs = var.vm_cpu
  RAM = var.vm_ram
  firmware = var.vm_firmware
  tools_upgrade_policy = true
  # vCenter Location Configuration
  vm_name = var.vm_name
  folder = var.vm_folder
  cluster = var.vcenter_cluster
  host = var.vcenter_host
  datastore = var.vm_datastore
  # Run Configuration
  boot_order = "disk,cdrom"
  # Shutdown Configuration
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "15m"
  # Wait Configuration
  ip_wait_timeout = "20m"
  # ISO Configuration
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_paths = ["${ var.iso_path }/${ var.iso_file }"]
  # CDRom Configuration
  cdrom_type = var.vm_cdrom_type
  remove_cdrom = true
#  cd_files = [
#        "./cloud-init/*"]
  cd_content = {
    "meta-data" = file("./cloud-init/meta-data")
    "user-data" = templatefile("./cloud-init/user-data.pkrtpl.hcl", local.templatevars)
  }
  cd_label = "cidata"
  # Create Configuration
  vm_version = var.vm_version
  guest_os_type = var.vm_guest_os_type
  network_adapters {
    network = var.vm_network
    network_card = var.vm_network_card
  }
  notes = "Built by HashiCorp Packer on ${local.buildtime}."
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size = var.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = var.vm_disk_thinprovisioned
  }
  # Communicator Configuration
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_port = 22
  ssh_timeout = "30m"
  ssh_handshake_attempts = "100"
}

##################################################################################
# BUILD
##################################################################################

build {
  sources = [
    "source.vsphere-iso.linux-ubuntu-server"]
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.ssh_username}",
    ]
    scripts = var.shell_scripts
    expect_disconnect = true
  }
 }
