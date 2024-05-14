data "cloudru_evolution_disk" "disks" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр, default by provider meta
    project_id = ""

    # NOTE: Это опциональный параметр
    availability_zone_id = ""

    # NOTE: Это опциональный параметр
    name = ""
  }
}

locals {
  system_disks = [for s in data.cloudru_evolution_disk.disks.resources : s if s.bootable && s.name=="system"]
  system_disk  = local.system_disks.0
}


output "system_disk" {
  value = local.system_disk
}
