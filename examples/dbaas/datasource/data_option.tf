data "cloudru_postgresql_option" "pg_options" {
  filter {
    # NOTE: Это обязательный параметр
    product_type = "postgres"
    version_id   = local.demo_postgres_version_16.id
  }
}

locals {
  demo_postgres_options = [
    for s in data.cloudru_postgresql_option.pg_options.options : s if s.display_name == "4vCPU/8GB RAM (Business)"
  ]
  demo_postgres_option_4_8_business = local.demo_postgres_options.0
}
