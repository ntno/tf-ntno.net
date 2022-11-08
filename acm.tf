data "aws_acm_certificate" "ntno_cert" {
  domain      = "ntno.net"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "star_ntno_cert" {
  domain      = "*.ntno.net"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
