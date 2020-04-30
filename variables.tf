variable "management_subnet_id" {
  default = ""
  description = "VPC Gen2 subnet ID for the TMOS management network.  To list available subnets, run `ibmcloud is subnets`."
}

variable "internal_subnet_id" {
  default = ""
  description = "VPC Gen2 subnet ID for the TMOS internal network.  To list available subnets, run `ibmcloud is subnets`."
}

variable "external_subnet_id" {
  default = ""
  description = "VPC Gen2 subnet ID for the TMOS external (VIP) network.  To list available subnets, run `ibmcloud is subnets`."
}

variable "tmos_image_id" {
  default = ""
  description = "The image to be used when provisioning F5 BIG-IP instance. To list available images, run `ibmcloud is images`."
}

variable "instance_profile" {
  default = "cx2-2x4"
  description = "The profile of compute CPU and memory resources to be used when provisioning F5 BIG-IP instance. To list available profiles, run `ibmcloud is profiles`."
}

variable "ssh_key_name" {
    default = ""
    description = "The name of the public SSH key (VPC Gen 2 SSH Key) to be used when provisining F5 BIG-IP instance.  To list available keys, run `ibmcloud is keys`."
}



