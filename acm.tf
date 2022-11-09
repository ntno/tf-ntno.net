data "aws_acm_certificate" "ntno_cert" {
  provider    = aws.us_east_1
  domain      = "ntno.net"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "star_ntno_cert" {
  provider    = aws.us_east_1
  domain      = "*.ntno.net"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
