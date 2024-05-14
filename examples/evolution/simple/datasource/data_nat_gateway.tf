data "cloudru_evolution_nat_gateway" "gateways" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    project_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    availability_zone_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    name = "gateway-eda25a"
  }
}

output "filtered_gateways" {
  value = data.cloudru_evolution_nat_gateway.gateways.resources
}
