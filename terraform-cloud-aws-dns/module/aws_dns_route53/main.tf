# provider "aws" {
#   region = "ap-northeast-1"  # Specify your desired AWS region
# }

locals {
  dnsTransform_Map = { for entry in var.dns_entry : entry.zone_name => entry }
  
  dnsTransporm_List = flatten([for toplayerkey, toplayervalue in local.dnsTransform_Map : [
    for nextLayerkey, nextlayervalue in toplayervalue.dns_records : {

      vpc = toplayervalue.private_zone ? toplayervalue.vpc : []
      zone_name = toplayervalue.zone_name
      records = nextlayervalue.records
      type = nextlayervalue.type
      domain = nextLayerkey
      tags = toplayervalue.tags
      set_identifier = can(nextlayervalue.set_identifier) ? nextlayervalue.set_identifier : null
      geolocation_routing_policy = can(nextlayervalue.geolocation_routing_policy) ? nextlayervalue.geolocation_routing_policy : {} 
      } 
  ]])

  dnsFinaltransform_Map = { for final in local.dnsTransporm_List : final.domain => final }
} 

resource "aws_route53_zone" "kalsada" {
  for_each = local.dnsTransform_Map 
  
  name          = each.value.zone_name
  tags          = each.value.tags
  
  
  dynamic "vpc" {
    for_each = each.value.vpc != null ? toset(each.value.vpc) : []

    content {
        vpc_id = vpc.value
      }
    }
  }


resource "aws_route53_record" "bilanguanan" {
  for_each = local.dnsFinaltransform_Map

  zone_id = aws_route53_zone.kalsada[each.value.zone_name].zone_id
  name    = each.value.domain
  type    = each.value.type
  ttl     = "300"
  records = toset(each.value.records)

  dynamic "geolocation_routing_policy" {
    for_each = each.value.geolocation_routing_policy != null ? each.value.geolocation_routing_policy : {}
    content {
      country = each.value.geolocation_routing_policy.country
    }
  
  }

  set_identifier = each.value.set_identifier
}