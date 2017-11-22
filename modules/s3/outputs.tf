output "bucket_domain" {
    value = "${aws_s3_bucket.website.bucket_domain_name}"
}

output "bucket" {
    value = "${aws_s3_bucket.website.id}"
}
