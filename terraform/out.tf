output "media_public_ips" {
  value = "${aws_instance.mediawiki.*.public_ip}"
        }

output "database_public_ip" {
  value = "${aws_instance.database.public_ip}"
        }

output "elburl" {
  value = "${aws_elb.media_elb.dns_name}"
        }
