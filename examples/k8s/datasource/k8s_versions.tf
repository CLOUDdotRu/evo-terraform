# Возвращает список доступных к использованию версий Kubernetes
data "cloudru_k8s_versions" "versions" {
}

output "k8s_versions" {
  value = data.cloudru_k8s_versions.versions
}
