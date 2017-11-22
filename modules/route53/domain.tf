data "aws_s3_bucket" "domain" {
    bucket = "${var.domain}"
}

resource "aws_route53_zone" "domain" {
    name = "${var.domain}"
}

resource "aws_route53_record" "domain-www" {
    zone_id = "${aws_route53_zone.domain.zone_id}"
    name = "${var.domain}"
    type = "A"

    alias {
      name = "${var.cloudfront_endpoint}"
      zone_id = "${var.cloudfront_zone_id}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "domain-ns" {
    zone_id = "${aws_route53_zone.domain.zone_id}"
    name = "${var.domain}"
    type = "NS"
    ttl = "30"

    records = [
        "${aws_route53_zone.domain.name_servers.0}",
        "${aws_route53_zone.domain.name_servers.1}",
        "${aws_route53_zone.domain.name_servers.2}",
        "${aws_route53_zone.domain.name_servers.3}"
    ]
}
