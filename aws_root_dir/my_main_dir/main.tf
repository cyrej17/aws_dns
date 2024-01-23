provider "aws" {
  region = "ap-northeast-1"
}

module "dns" {
  source    = "../module/aws_dns_route53"
  dns_entry = var.dns_entry
}