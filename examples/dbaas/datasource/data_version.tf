data "cloudru_postgresql_version" "pg_versions" {
  filter {
    # NOTE: Это обязательный параметр
    product_type = "postgres"
  }
}

locals {
  demo_postgres_versions = [
    for s in data.cloudru_postgresql_version.pg_versions.versions : s if s.version == "16"
  ]
  demo_postgres_version_16 = local.demo_postgres_versions.0
}
