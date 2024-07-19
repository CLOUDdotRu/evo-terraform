# Список доступных версий плагина.
data "cloudru_k8s_addon_releases" "releases" {
  # NOTE: Это обязательный параметр
  # Название плагина.
  name = "ingress-nginx"
}

output "ingress" {
  value = data.cloudru_k8s_addon_releases.releases
}
