# Возвращает kubeconfig для кластера
data "cloudru_k8s_kubeconfig" "kubeconfig" {
  # NOTE: Это обязательный параметр
  # Идентификатор кластера
  cluster_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  # Тип сети, для которой нужно вернуть kubeconfig
  network_type = "NETWORK_TYPE_PRIVATE"
}

output "mycluster_kubeconfig" {
  value     = data.cloudru_k8s_kubeconfig.kubeconfig
  sensitive = true
}
