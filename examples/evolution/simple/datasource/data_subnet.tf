data "cloudru_evolution_subnet" "subnets" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    project_id = "00000000-0000-0000-0000-000000000000"
    # NOTE: это опциональный параметр
    availability_zone_ids = ["00000000-0000-0000-0000-000000000000"]
    # NOTE: это опциональный параметр
    # routed_network = false
    # NOTE: это опциональный параметр
    # tag_ids = ["00000000-0000-0000-0000-000000000000"]
    # NOTE: это опциональный параметр
    # name = "subnet-816839"
    # NOTE: это опциональный параметр
    # subnet_address = "10.1.2.0/24"
  }
}

locals {
  demo_subnets = [
    for s in data.cloudru_evolution_subnet.subnets.resources : s
  ]

  demo_subnet = local.demo_subnets.0
}
