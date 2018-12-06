provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    region     = "${var.region}"
} # end provider

terraform {
  required_version = ">= 0.11.8"
}

# create the VPC
resource "aws_vpc" "media_vpc" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}" 
  enable_dns_support   = "${var.dnsSupport}" 
  enable_dns_hostnames = "${var.dnsHostNames}"
tags {
    Name = "${var.prefix}-vpc"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "media_vpc_Subnet" {
  vpc_id                  = "${aws_vpc.media_vpc.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"
tags = {
   Name = "${var.prefix}-vpc-Subnet"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "media_vpc_Security_Group" {
  vpc_id       = "${aws_vpc.media_vpc.id}"
  name         = "media vpc Security Group"
  description  = "media vpc Security Group"
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 22
    to_port    = 22
  }

ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 80
    to_port    = 80
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 443
    to_port    = 443
  }
# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = 443
    to_port    = 443
  }

# allow ingress icmp port for ping operation.
  ingress {
    protocol   = "icmp"
    cidr_blocks = "${var.ingressCIDRblock}"
    from_port  = -1
    to_port    = -1
  }


egress {
    protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_blocks = "${var.ingressCIDRblock}"
    }

tags = {
        Name = "${var.prefix}-vpc-Security-Group"
  }
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "media_vpc_Security_ACL" {
  vpc_id = "${aws_vpc.media_vpc.id}"
  subnet_ids = [ "${aws_subnet.media_vpc_Subnet.id}" ]

# allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}" 
    from_port  = 22
    to_port    = 22
  }
# allow ingress  ports 
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }
# allow egress  ports
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 0
    to_port    = 0
  }

tags {
    Name = "${var.prefix}-vpc-ACL"
  }
} # end resource

resource "aws_network_acl_rule" "allow_ingress_icmp_test" {
    network_acl_id = "${aws_network_acl.media_vpc_Security_ACL.id}"
    rule_number = 300
    egress = false
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}

resource "aws_network_acl_rule" "allow_egress_icmp_test" {
    network_acl_id = "${aws_network_acl.media_vpc_Security_ACL.id}"
    rule_number = 300
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = -1
    to_port = -1
    icmp_type = -1
    icmp_code = -1
}

# Create the Internet Gateway
resource "aws_internet_gateway" "media_vpc_GW" {
  vpc_id = "${aws_vpc.media_vpc.id}"
tags {
        Name = "${var.prefix}-vpc-Internet-Gateway"
    }
} # end resource

# Create the Route Table
resource "aws_route_table" "media_vpc_route_table" {
    vpc_id = "${aws_vpc.media_vpc.id}"
tags {
        Name = "${var.prefix}-vpc-Route-Table"
    }
} # end resource


# Create the Internet Access Private
resource "aws_route" "media_vpc_internet_access" {
  route_table_id        = "${aws_route_table.media_vpc_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.media_vpc_GW.id}"
} # end resource


# Associate the Route Table with the Subnet
resource "aws_route_table_association" "media_vpc_association" {
    subnet_id      = "${aws_subnet.media_vpc_Subnet.id}"
    route_table_id = "${aws_route_table.media_vpc_route_table.id}"
} # end resource


# end vpc.tf
