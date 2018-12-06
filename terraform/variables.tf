variable "region" {}
variable "availabilityZone" {}
variable "count" {}
variable "conncount" {}
variable "prefix" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_id" {}

variable "key_name" {}

variable "root_storage_type" {
    default = "standard"
}

variable "root_storage_size" {
     default = "20"
}

variable "root_storage_iops" {
    default = "100"
}

variable "database_storage_type" {}
variable "database_storage_size" {}
variable "database_storage_iops" {}

variable "ips" {
	 default = {
        "0" = "10.0.1.5"
        "1" = "10.0.1.6"
        "2" = "10.0.1.7"
        "3" = "10.0.1.8"
        "4" = "10.0.1.9"
        "5" = "10.0.1.10"
        }
}


variable "conn_ips" {
         default = {
        "0" = "10.0.1.20"
        "1" = "10.0.1.21"
        "2" = "10.0.1.22"
        "3" = "10.0.1.23"
        "4" = "10.0.1.24"
        "5" = "10.0.1.25"
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

variable "availabilityZones" {
	 type = "list"
	 default = [ "us-west-2a", "us-west-2b", "us-west-2c" ]
}
