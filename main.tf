provider "aws" {
    shared_credentials_file = "/Users/matt/.aws/credentials"
    region = "eu-west-2"
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
