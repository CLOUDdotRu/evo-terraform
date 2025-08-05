# Получение конфигурации продукта Managed Kubernetes.
data "cloudru_k8s_product_configuration" "k8s_product_configuration" {

  # NOTE: Опциональный параметр, если указан project_id в конфигурации провайдера.
  # Если project_id не указан в конфигурации провайдера или его требуется переопределить, то project_id должен быть указан.
  # Идентификатор проекта.
  project_id = "00000000-0000-0000-0000-000000000000"
}

output "k8s_product_configuration" {
  value = data.cloudru_k8s_product_configuration.k8s_product_configuration
}