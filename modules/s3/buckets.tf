resource "aws_s3_bucket" "website" {
    bucket = "${element(var.domains, 0)}"
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "index.html"
    }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = "${aws_s3_bucket.website.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${element(var.domains, 0)}/*"
      }
  ]
}
POLICY
}

resource "aws_s3_bucket" "alias" {
    bucket = "${element(var.domains, count.index+1)}"
    count = "${length(var.domains)-1}"
    acl = "public-read"

    website {
        redirect_all_requests_to = "${element(var.domains, 0)}"
    }
}
