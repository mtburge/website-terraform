output "cloudfront_domain" {
    value =  "${aws_cloudfront_distribution.website.domain_name}"
}

output "cloudfront_zone" {
    value = "${aws_cloudfront_distribution.website.hosted_zone_id}"
}
