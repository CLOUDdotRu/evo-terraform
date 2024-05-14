data "cloudru_k8s_zone_flavors" "flavors" {

  # NOTE: Это опциональный параметр, если указан project_id в конфигурации провайдера.
  # Если project_id не указан в конфигурации провайдера или его требуется переопределить, то project_id должен быть указан.
  # Идентификатор проекта.
  project_id = "00000000-0000-0000-0000-000000000000"
}

output "flavors" {
  value = data.cloudru_k8s_zone_flavors.flavors
}
