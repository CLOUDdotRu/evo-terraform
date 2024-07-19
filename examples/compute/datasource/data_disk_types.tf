data "cloudru_evolution_disk_type" "disk_types" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр
    # availability_zone_id = local.demo_az.id
  }
}

output "list_disk_types" {
  value = data.cloudru_evolution_disk_type.disk_types.resources
}
