##### SoftLayer Access Credentials ######
variable "sl_username" { default = "__INSERT_YOUR_OWN__" }
variable "sl_api_key" { default = "__INSERT_YOUR_OWN__" }

variable "key_name" { 
  description = "Name or reference of SSH key to provision softlayer instances with"
  default = "patro-key"
}


##### Common VM specifications ######
variable "datacenter" { default = "wdc04" }
variable "domain" { default = "wps.patro" }

# Name of the ICP installation, will be used as basename for VMs
variable "instance_name" { default = "wps" }

##### ICP Instance details ######
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
