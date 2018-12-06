resource "aws_instance" "mediawiki" {
    ami = "${var.mediaami}"
    count = "2"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.media_vpc_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.media_vpc_Subnet.id}"
    instance_type = "${var.media_instance_type}"
tags {
        Name = "${var.prefix}-media-${count.index + 1}"
  }
} # end resource

resource "aws_instance" "database" {
    ami = "${var.mediaami}"
    count = "1"
    associate_public_ip_address = "1"
    availability_zone       = "${var.availabilityZone}"
    vpc_security_group_ids = ["${aws_security_group.media_vpc_Security_Group.id}"]
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.media_vpc_Subnet.id}"
    instance_type = "${var.database_instance_type}"

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
        Name = "${var.prefix}-database"
  }
} # end resource
