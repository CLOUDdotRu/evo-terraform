data "cloudru_evolution_security_group" "security_groups" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    # project_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # availability_zone_id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # tag_ids = ["00000000-0000-0000-0000-000000000000"]

    # NOTE: Это опциональный параметр
    # name = "test"
  }
}

locals {
  demo_security_groups = [
    for s in data.cloudru_evolution_security_group.security_groups.resources : s if s.name == "Default"
  ]

  demo_security_group = local.demo_security_groups.0
}
