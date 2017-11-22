output "endpoint" {
    value = "${aws_cloudfront_distribution.website.domain_name}"
}

output "zone_id" {
    value = "${aws_cloudfront_distribution.website.hosted_zone_id}"
}
