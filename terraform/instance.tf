provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    region     = "${var.region}"
} # end provider

resource "aws_instance" "mediawiki" {
    ami = "${lookup(var.ami,var.region)}"
    count = "${var.count}"
    #private_ip = "${lookup(var.conn_ips,count.index)}"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.tungsten_VPC_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.media_instance_type}"
tags {
        Name = "${var.prefix}-conn-${count.index + 1}"
  }
} # end resource

resource "aws_instance" "tungsten" {
    ami = "${data.aws_ami.tungsten.id}"
    count = "${var.count}"
    private_ip = "${lookup(var.ips,count.index)}"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${var.security_group_id}"]
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    instance_type = "${var.mysql_instance_type}"

  root_block_device {
    volume_type = "${var.root_storage_type}"
    volume_size = "${var.root_storage_size}"
    iops = "${var.root_storage_iops}"
    delete_on_termination = true
    }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "${var.database_storage_type}"
    volume_size = "${var.database_storage_size}"
    iops = "${var.database_storage_iops}"
    delete_on_termination = true
    }


tags {
        Name = "${var.prefix}-node-db${count.index + 1}"
  }
} # end resource
