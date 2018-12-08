variable "region" {}
variable "availabilityZone" {}
variable "prefix" {}
variable "media_instance_type" {}
variable "database_instance_type" {}

variable "root_storage_type" {
    default = "standard"
}
variable "root_storage_size" {
     default = "20"
}
variable "root_storage_iops" {
    default = "100"
}
variable "database_storage_type" {
    default = "gp2"
}
variable "database_storage_size" {
    default = "20"
}
variable "database_storage_iops" {
    default = "100"
}

variable "instanceTenancy" {
     default     = "default"
}

variable "dnsSupport" {
     default     = true
}

variable "dnsHostNames" {
    default = true
}


variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}

variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}

variable "subnetCIDRinternal" {
    type = "list"
    default = [ "10.0.1.0/24" ]
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
         type = "list"
         default = [ "0.0.0.0/0" ]
}

variable "mapPublicIP" {
    default = true
}

variable "mediaami" {
}

variable "key_name" {
}

variable "ips" {
         default = {
        "0" = "10.0.1.10"
        "1" = "10.0.1.20"
        }
}


variable "elb_account_id" {
         default = {
        "us-east-1" = "127311923021"
        "us-east-2" = "033677994240"
        "us-west-1" = "027434742980"
        "us-west-2" = "797873946194"
        "ca-central-1" = "985666609251"
        "eu-central-1" = "054676820928"
        "eu-west-1" = "156460612806"
        "eu-west-2" = "652711504416"
        "eu-west-3" = "009996457667"
        "ap-northeast-1" = "582318560864"
        "ap-northeast-2" = "600734575887"
        "ap-northeast-3" = "383597477331"
        "ap-southeast-1" = "114774131450"
        "ap-southeast-2" = "783225319266"
        "ap-south-1" = "718504428378"
        "sa-east-1" = "507241528517"
        "us-gov-west-1*" = "048591011584"
        "us-gov-east-1*" = "190560391635"
        "cn-north-1**" = "638102146993"
        "cn-northwest-1**" = "037604701340"
        }
}
