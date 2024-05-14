data "cloudru_evolution_available_subnet" "subnets" {
  # NOTE: Это обязательный параметр
  filter {
    # NOTE: это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    project_id = "00000000-0000-0000-0000-000000000000"
    # NOTE: Это обязательный параметр
    subnet_mask = 24
    # NOTE: Это обязательный параметр
    base_subnet_address = "10.1.2.0/24"
  }
}

output "filtered_available_subnets" {
  value = data.cloudru_evolution_available_subnet.subnets.resources
}
