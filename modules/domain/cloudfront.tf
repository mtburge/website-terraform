data "aws_acm_certificate" "website" {
    domain = "${var.domain}"
    statuses = ["ISSUED"]
    provider = "aws.us-east-1"
}

resource "aws_cloudfront_distribution" "website" {
    enabled = true
    is_ipv6_enabled = true
    comment = "${var.domain}"
    default_root_object = "index.html"
    price_class = "PriceClass_100"
    depends_on = ["aws_s3_bucket.domain"]
    aliases = [
        "${var.domains}"
    ]

    origin {
        domain_name = "${aws_s3_bucket.domain.bucket_domain_name}"
        origin_id = "${var.domain}"
    }

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "${var.domain}"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 86400
        max_ttl = 31536000
        smooth_streaming = false
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn = "${data.aws_acm_certificate.website.arn}"
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1.1_2016"
    }
}
