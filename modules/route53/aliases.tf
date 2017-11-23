data "aws_s3_bucket" "website" {
    bucket = "${element(var.aliases, count.index)}"
    count = "${length(var.aliases)}"
}

resource "aws_route53_zone" "website" {
    name = "${element(var.aliases, count.index)}"
    count = "${length(var.aliases)}"
}

resource "aws_route53_record" "www" {
    zone_id = "${element(aws_route53_zone.website.*.zone_id, count.index)}"
    count = "${length(var.aliases)}"
    name = "${element(var.aliases, count.index)}"
    type = "A"

    alias {
      name = "${element(data.aws_s3_bucket.website.*.website_domain, count.index)}"
      zone_id = "${element(data.aws_s3_bucket.website.*.hosted_zone_id, count.index)}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "nameserver" {
    zone_id = "${element(aws_route53_zone.website.*.zone_id, count.index)}"
    count = "${length(var.aliases)}"
    name = "${element(var.aliases, count.index)}"
    type = "NS"
    ttl = "30"

    records = [
        "${element(aws_route53_zone.website.*.name_servers.0, count.index)}",
        "${element(aws_route53_zone.website.*.name_servers.1, count.index)}",
        "${element(aws_route53_zone.website.*.name_servers.2, count.index)}",
        "${element(aws_route53_zone.website.*.name_servers.3, count.index)}"
    ]
}
