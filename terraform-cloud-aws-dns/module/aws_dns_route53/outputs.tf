output "dns_zones" {
  value = aws_route53_zone.kalsada
}
output "dns_records" {
  value = aws_route53_record.bilanguanan
}

