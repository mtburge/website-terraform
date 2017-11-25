resource "aws_s3_bucket" "domain" {
    bucket = "${var.domain}"
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "index.html"
    }
}

resource "aws_s3_bucket_policy" "domain" {
  bucket = "${aws_s3_bucket.domain.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${var.domain}/*"
      }
  ]
}
POLICY
}

resource "aws_route53_zone" "domain" {
    name = "${var.domain}"
}

resource "aws_route53_record" "a" {
    zone_id = "${aws_route53_zone.domain.zone_id}"
    name = "${var.domain}"
    type = "A"

    alias {
      name = "${aws_cloudfront_distribution.website.domain_name}"
      zone_id = "${aws_cloudfront_distribution.website.hosted_zone_id}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "www" {
    zone_id = "${aws_route53_zone.domain.zone_id}"
    name = "www.${var.domain}"
    type = "A"

    alias {
      name = "${aws_cloudfront_distribution.website.domain_name}"
      zone_id = "${aws_cloudfront_distribution.website.hosted_zone_id}"
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "ns" {
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
