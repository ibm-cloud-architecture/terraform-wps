provider "ibm" {
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

variable "public_key_name" {
  description = "Name of the public SSH key used to connect to the servers"
  default     = "cam-public-key-wps"
}

variable "public_key" {
  description = "Public SSH key used to connect to the servers"
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

resource "ibm_compute_ssh_key" "cam_public_key" {
  label      = "${var.public_key_name}"
  public_key = "${var.public_key}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "ibm_compute_ssh_key" "temp_public_key" {
    label      = "${var.public_key_name}-temp"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}


 resource "ibm_compute_vm_instance" "wps" {
#resource "softlayer_virtual_guest" "wps" {
    
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

    ssh_key_ids              = ["${ibm_compute_ssh_key.cam_public_key.id}", "${ibm_compute_ssh_key.temp_public_key.id}"]
}

resource "ibm_compute_ssh_key" "temp_public_key" {
    label      = "${var.public_key_name}-temp"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
}


module "provision" {
    source = "github.com/ibm-cloud-architecture/terraform-module-wps-deploy"

#    wps = "${softlayer_virtual_guest.wps.ipv4_address}"
    wps = "${ibm_compute_vm_instance.wps.ipv4_address}"
    ssh_key = "${tls_private_key.ssh.private_key_pem}"
}



