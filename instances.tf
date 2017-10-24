provider "ibm" {
}

variable "ssh_key" {
  description = "Public SSH key used to connect to the virtual guest"
  default = "patro-key"
}

variable "datacenter" {
  description = "SoftLayer datacenter where infrastructure resources will be deployed"
  default = "wdc04"
}


variable "instance_name" {
  description = "Virtual Machine name"
  default = "wps"
}

variable "domain" { 
    description = "Virtual Machine domain"
    default = "wps.patro" 
}



# This will create a new SSH key that will show up under the \
# Devices>Manage>SSH Keys in the SoftLayer console.
resource "ibm_compute_ssh_key" "orpheus_public_key" {
    label = "Orpheus Public Key"
    public_key = "${var.ssh_key}"
}

variable "wps" {
  type = "map"
  
  default = {
    nodes       = "1"
    cpu_cores   = "2"
    disk_size   = "100" // GB
    local_disk  = false
    memory      = "8192"
    network_speed= "1000"
    private_network_only=false
    hourly_billing=true
  }
 
}

resource "ibm_compute_vm_instance" "wps" {
    
    datacenter  = "${var.datacenter}"
    domain      = "${var.domain}"
    hostname    = "${var.instance_name}"
    
    image_id = "1770459"

    cores       = "${var.wps["cpu_cores"]}"
    memory      = "${var.wps["memory"]}"
    disks       = ["${var.wps["disk_size"]}"]
    local_disk  = "${var.wps["local_disk"]}"
    network_speed         = "${var.wps["network_speed"]}"
    hourly_billing        = "${var.wps["hourly_billing"]}"
    private_network_only  = "${var.wps["private_network_only"]}"

    user_metadata = "{\"value\":\"newvalue\"}"

    ssh_key_ids = ["${ibm_compute_ssh_key.orpheus_public_key.id}"]
}






##### ICP Instance details ######
module "wps-provision" {
    source = "github.com/ibm-cloud-architecture/terraform-module-wps-deploy"
    
    wps = "${ibm_compute_vm_instance.wps.ipv4_address}"
    
} 

