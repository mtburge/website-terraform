resource "aws_route53_zone" "alias" {
    name = "${var.domain}"
}

resource "aws_route53_record" "a" {
    zone_id = "${aws_route53_zone.alias.zone_id}"
    name = "${var.domain}"
    type = "A"

    alias {
      name = "${var.cloudfront_domain}"
      zone_id = "${var.cloudfront_zone}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "www" {
    zone_id = "${aws_route53_zone.alias.zone_id}"
    name = "www.${var.domain}"
    type = "A"

    alias {
      name = "${var.cloudfront_domain}"
      zone_id = "${var.cloudfront_zone}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "ns" {
    zone_id = "${aws_route53_zone.alias.zone_id}"
    name = "${var.domain}"
    type = "NS"
    ttl = "30"

    records = [
        "${aws_route53_zone.alias.name_servers.0}",
        "${aws_route53_zone.alias.name_servers.1}",
        "${aws_route53_zone.alias.name_servers.2}",
        "${aws_route53_zone.alias.name_servers.3}"
    ]
}
