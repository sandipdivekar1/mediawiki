terraform {
  required_version = ">= 0.11.8"
}

# Add instances with aws elastic load balancer.
resource "aws_elb" "media_elb" {
  name               = "${var.prefix}-terraform-elb"
  security_groups = ["${aws_security_group.media_vpc_Security_Group.id}"]
  subnets = ["${aws_subnet.media_vpc_Subnet.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "tcp:22"
    interval            = 30
  }

  instances                   = ["${aws_instance.mediawiki.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.prefix}-terraform-elb"
  }
} # end resource
