provider "softlayer" {
#    username = "${var.sl_username}"
#    api_key = "${var.sl_api_key}"
}

data "softlayer_ssh_key" "public_key" {
  label = "${var.key_name}"
}

resource "softlayer_virtual_guest" "wps" {
    
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

    ssh_key_ids = ["${data.softlayer_ssh_key.public_key.id}"]
}

module "wps-provision" {
    source = "github.com/ibm-cloud-architecture/terraform-module-wps-deploy"
    
    wps = "${softlayer_virtual_guest.wps.ipv4_address}"
    
    # We will let terraform generate a new ssh keypair 
    # for boot master to communicate with worker and proxy nodes
    # during WPS deployment
    generate_key = true
    
    # SSH user and key for terraform to connect to newly created SoftLayer resources
    # ssh_key is the private key corresponding to the public keyname specified in var.key_name
    ssh_user  = "root"
    ssh_key   = "~/.ssh/id_rsa"
    
} 

