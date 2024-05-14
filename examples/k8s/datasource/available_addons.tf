# Возвращает список доступных к установке плагинов
data "cloudru_k8s_available_addons" "addons" {}

output "k8s_addons" {
  value = data.cloudru_k8s_available_addons.addons
}
