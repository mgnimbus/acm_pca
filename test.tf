resource "aws_acmpca_certificate_authority_certificate" "example" {
  certificate_authority_arn = aws_acmpca_certificate_authority.example.arn

  certificate       = aws_acmpca_certificate.example.certificate
  certificate_chain = aws_acmpca_certificate.example.certificate_chain

resource "aws_acmpca_certificate" "example" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.example.arn
  certificate_signing_request = aws_acmpca_certificate_authority.example.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 10
  }
}

resource "aws_acmpca_permission" "example" {
  certificate_authority_arn = aws_acmpca_certificate_authority.example.arn
  actions                   = ["IssueCertificate", "GetCertificate", "ListPermissions"]
  principal                 = "acm.amazonaws.com"
}

resource "aws_acmpca_certificate_authority" "example" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "example.com"
    }
  }
}

data "aws_partition" "current" {}

resource "aws_acm_certificate" "cert123" {

  certificate_authority_arn = aws_acmpca_certificate_authority.example.arn
  domain_name               = "nginx-hello-alb-ecs-1220433373.us-east-1.elb.amazonaws.com"
  key_algorithm             = "RSA_2048"

  tags = {
    Name = "pca_test123"
  }

  lifecycle {
    create_before_destroy = true
  }
}
