data "cloudru_evolution_disk_type" "disk_types" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр
    # availability_zone_id = "00000000-0000-0000-0000-000000000000"
  }
}

locals {
  demo_disk_types = [
    for s in data.cloudru_evolution_disk_type.disk_types.resources : s if s.name == "SSD"
  ]
  demo_disk_type = local.demo_disk_types.0
}
