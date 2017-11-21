variable "domains" {
    type = "list"
    description = "Domains which are configured to redirect to the master domain (first item in this list)"
    default = [
        "itsmattburgess.co.uk",
        "itsmattburgess.com",
        "itsmattburgess.uk"
    ]
}
