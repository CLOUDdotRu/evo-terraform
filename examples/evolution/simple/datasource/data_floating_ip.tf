data "cloudru_evolution_fip" "fips" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    project_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    availability_zone_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    # interface_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    # nat_gateway_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    # free = true

    # NOTE: это опциональный параметр
    # name = "test"
  }
}

locals {
  demo_fip = data.cloudru_evolution_fip.fips.resources.0
}
