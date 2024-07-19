data "cloudru_evolution_fip" "fips" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    # project_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # availability_zone_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # interface_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # nat_gateway_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # free = true

    # NOTE: Это опциональный параметр
    # name = "test"
  }
}

locals {
  demo_fip = data.cloudru_evolution_fip.fips.resources.0
}
