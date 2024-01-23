variable "dns_entry" {
  type    = list(object({
    zone_name    = string
    private_zone = bool
    tags         = map(string)
    vpc = optional(list(string))
 
    
    dns_records  = map(object({
      type    = string
      records = list(string)
      set_identifier = optional(string)
      geolocation_routing_policy = optional(object({ 
        country = optional(string)
      }))


    }))
  }))
}
