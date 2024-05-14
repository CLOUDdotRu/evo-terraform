# Возвращает список установленных в кластере аддонов
data "cloudru_k8s_addons" "addons" {
  # Идентификатор кластера
  cluster_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это опциональный параметр.
  # Если установлен, то список аддонов будет включать в себя как активные, так и удаленные аддоны.
  # По умолчанию - false
  # show_deleted = true
}

output "installed_addons" {
  value = data.cloudru_k8s_addons.addons
}
