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

module "itsmattburgesscouk" {
    source = "modules/domain"
    domain = "itsmattburgess.co.uk"

    domains = [
        "itsmattburgess.co.uk",
        "itsmattburgess.com",
        "itsmattburgess.uk",
        "itsmattburgess.me",
        "www.itsmattburgess.co.uk",
        "www.itsmattburgess.com",
        "www.itsmattburgess.uk",
        "www.itsmattburgess.me"
    ]
}

module "itsmattburgesscom" {
    source = "modules/alias"
    domain = "itsmattburgess.com"

    cloudfront_domain = "${module.itsmattburgesscouk.cloudfront_domain}"
    cloudfront_zone = "${module.itsmattburgesscouk.cloudfront_zone}"
}

module "itsmattburgessuk" {
    source = "modules/alias"
    domain = "itsmattburgess.uk"

    cloudfront_domain = "${module.itsmattburgesscouk.cloudfront_domain}"
    cloudfront_zone = "${module.itsmattburgesscouk.cloudfront_zone}"
}

module "itsmattburgessme" {
    source = "modules/alias"
    domain = "itsmattburgess.me"

    cloudfront_domain = "${module.itsmattburgesscouk.cloudfront_domain}"
    cloudfront_zone = "${module.itsmattburgesscouk.cloudfront_zone}"
}
