data "cloudru_evolution_tag" "tags" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр, default by provider meta
    # project_id = "00000000-0000-0000-0000-000000000000"
  }
}

locals {
  demo_tags = [
    for s in data.cloudru_evolution_tag.tags.resources : s if s.name != "Default"
  ]

  demo_tag = local.demo_tags.0
}
