data "cloudru_evolution_availability_zone" "azs" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр, default by provider meta
    # project_id = 00000000-0000-0000-0000-000000000000"
  }
}

locals {
  demo_azs = [
    for s in data.cloudru_evolution_availability_zone.azs.resources : s if s.name == "ru.AZ-1"
  ]
  demo_az = local.demo_azs.0
}
