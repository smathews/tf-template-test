##############################################################################
# Terraform Main IaC
##############################################################################

data "ibm_is_vpc" "vpc" {
    name = "us-south-vpc"
}

data "ibm_is_image" "ubuntu" {
    name = "ibm-ubuntu-20-04-minimal-amd64-2"
}

data "ibm_is_ssh_key" "key" {
    name = "test"
}

data "ibm_is_subnet" "subnet" {
    name = "sub-us-south-1"
}

resource "ibm_is_instance" "foobar" {
    name    = "foobar"
    vpc     = data.ibm_is_vpc.vpc.id
    zone    = "us-south-1"
    profile = "cx2-2x4"
    keys    = [data.ibm_is_ssh_key.key.id]
    image   = data.ibm_is_image.ubuntu.id
    
    primary_network_interface {
        subnet  = data.ibm_is_subnet.subnet.id
    }
}

# data "ibm_is_instance" "get_foobar" {
#     name       = "foobar"
#     depends_on = [
#       ibm_is_instance.foobar,
#     ]
# }
