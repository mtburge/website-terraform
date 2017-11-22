provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    region = "eu-west-2"
}

provider "aws" {
    shared_credentials_file = "~/.aws/credentials"
    region = "us-east-1"
    alias = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "mattburgess-terraform-state"
        key = "state/website.tfstate"
        region = "eu-west-2"
        encrypt = true
    }
}

module "s3" {
    source = "modules/s3"
    domains = "${var.domains}"
}

module "cloudfront" {
    source = "modules/cloudfront"
    domain = "${element(var.domains, 0)}"
    bucket = "${module.s3.bucket}"
    bucket_domain = "${module.s3.bucket_domain}"
}

module "route53" {
    source = "modules/route53"
    domain = "${element(var.domains, 0)}"
    aliases = "${slice(var.domains, 1, length(var.domains))}"
    cloudfront_endpoint = "${module.cloudfront.endpoint}"
    cloudfront_zone_id = "${module.cloudfront.zone_id}"
}
