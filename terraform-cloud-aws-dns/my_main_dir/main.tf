provider "aws" {
  region = "ap-northeast-1"
}

# module "dns" {
#   source    = "../module/aws_dns_route53"
#   dns_entry = var.dns_entry
# }

  module "dns2" {
  source  = "app.terraform.io/cyrej_yt_ops/dns2/aws"
  version = "1.0.0"
  dns_entry = var.dns_entry

  }