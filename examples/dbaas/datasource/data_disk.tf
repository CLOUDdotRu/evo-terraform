data "cloudru_infrastructure_disk" "pg_disk" {
  filter {
    #     NOTE: Это обязательный параметр
    product_type = "postgres"
  }
}

locals {
  demo_postgres_disks = [
    for s in data.cloudru_infrastructure_disk.pg_disk.disks : s if s.display_name == "SSD 16384G"
  ]
  demo_postgres_disk_ssd = local.demo_postgres_disks.0
}
