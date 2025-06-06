---
page_title: "cloudru_k8s_addon_releases Data Source - cloudru"
subcategory: "k8s"
description: "Релизы плагинов"
  Список доступных версий плагина.
---

# Версии плагина cloudru_k8s_addon_releases (Data Source)

В разделе рассмотрен пример получения доступных для установки версий плагина, а также приведено описание всех полей источника данных cloudru_k8s_addon_releases.

## Пример

```terraform
data "cloudru_k8s_addon_releases" "releases" {
  # Название плагина
  name = "ingress-nginx"
}

output "ingress" {
  value = data.cloudru_k8s_addon_releases.releases
}
```

> **NOTE**: Чтобы получить список доступных плагинов, можно использовать источник данных `cloudru_k8s_available_addons`. 

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `name` (String) Название плагина.

### Optional

- `timeouts` (Attributes) (see [below for nested schema](#nestedatt--timeouts))

### Read-Only

- `releases` (Attributes List) Список доступных версий плагина. (see [below for nested schema](#nestedatt--releases))

<a id="nestedatt--timeouts"></a>
### Nested Schema for `timeouts`

Optional:

- `read` (String) По умолчанию 15s.


<a id="nestedatt--releases"></a>
### Nested Schema for `releases`

Read-Only:

- `configuration_schema` (String) JSON-схема, относительно которой валидируется конфигурация плагина.
- `created_at` (String) Дата и время создания плагина.
- `namespace` (String) Пространство имен, в которое должен устанавливаться плагин.
- `support_mode` (String) Режим поддержки версии. Возможные значения: `SUPPORT_MODE_END_OF_SUPPORT` `SUPPORT_MODE_END_OF_LIFE` `SUPPORT_MODE_INACTIVE` `SUPPORT_MODE_UNSPECIFIED` `SUPPORT_MODE_ACTIVE` `SUPPORT_MODE_EXPERIMENTAL`.
- `updated_at` (String) Дата и время последнего обновления плагина.
- `version` (String) Версия плагина в формате SemVer.