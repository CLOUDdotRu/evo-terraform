data "cloudru_evolution_compute" "computes" {
  # NOTE: Это обязательный параметр
  filter {
    # NOTE: это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    project_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: это опциональный параметр
    # name = "test"

    # NOTE: это опциональный параметр
    empty_fip = true

    # NOTE: это опциональный параметр
    # tag_ids = ["00000000-0000-0000-0000-000000000000"]

    # NOTE: это опциональный параметр
    # availability_zone_ids = ["00000000-0000-0000-0000-000000000000"]

    # NOTE: это опциональный параметр
    # image_ids = ["00000000-0000-0000-0000-000000000000"]

    # NOTE: это опциональный параметр
    # flavor_ids = ["00000000-0000-0000-0000-000000000000"]

    # NOTE: это опциональный параметр
    # statuses = ["created"]
  }
}

output "filtered_computes" {
  value = data.cloudru_evolution_compute.computes.resources
}
