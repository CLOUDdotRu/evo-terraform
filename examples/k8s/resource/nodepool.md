---
page_title: "cloudru_k8s_nodepool Resource - cloudru"
subcategory: "k8s"
description: "Управление группами узлами в кластере Kubernetes"
  Evolution Kubernetes NodePool
---

# Управление группами узлов cloudru_k8s_nodepool (Resource)

В разделе рассмотрены примеры управления группой узлов, а также приведено описание всех полей ресурса cloudru_k8s_nodepool.

## Примеры использования

Примеры описывают несколько вариантов создания группы узлов: 

- только с обязательными настройками;
- с расширенными настройками;
- с настройками, которые могут быть заполнены с помощью источников данных;
- с автоматическим масштабированием размера группы.

### Базовая конфигурация

В примере рассматривается создание группы узлов с настройкой только обязательных полей.

```terraform
resource "cloudru_k8s_nodepool" "example-nodepool" {

  # NOTE: Обязательный параметр.
  # Идентификатор кластера, в котором будет создана группа узлов.
  cluster_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Обязательный параметр.
  # Название группы узлов. Должно быть уникальным.
  # Может содержать буквы, цифры, подчеркивание.
  # Допустимое количество символов от 4 до 60.
  name = "example-nodepool"

  # NOTE: Обязательный параметр.
  # Политика масштабирования группы узлов.
  # Нужно указать только один из следующих блоков: fixed_scale или auto_scale.
  scale_policy = {

    # NOTE: Обязательный параметр.
    # Группа узлов с фиксированным числом узлов.
    fixed_scale = {

      # NOTE: Обязательный параметр.
      # Количество узлов в группе.
      count = 1
    }
  }

  # NOTE: Обязательный параметр.
  # Описание инфраструктуры узлов группы.
  hardware_compute = {

    # NOTE: Обязательный параметр.
    # Размер подключаемого диска в ГБ.
    disk_size = 10

    # NOTE: Обязательный параметр.
    # Идентификатор шаблона конфигурации.
    flavor_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Обязательный параметр.
  # Конфигурация сети группы узлов.
  nodes_network_configuration = {

    # NOTE: Обязательный параметр, если не указан nodes_subnet_id.
    # Адрес сети узлов.
    # Должен принадлежать диапазонам 10.0.0.0/20–28, 172.16.0.0/20–28 или 192.168.0.0/20–28.
    # Не должен пересекаться с сетью сервисов или сетью подов кластера.
    # Если указать это значение, то сеть будет создана автоматически.
    nodes_subnet_cidr = "192.168.123.0/24"
  }
}
```

### Расширенная конфигурация

В примере рассматривается создание группы узлов с указанием политик ограничений `taints` и метками `label`.
Подробнее см. [в схеме ниже](#nested-schema-for-taints).

```terraform
resource "cloudru_k8s_nodepool" "example-nodepool" {

  # NOTE: Обязательный параметр.
  # Идентификатор кластера, в котором будет создана группа узлов.
  cluster_id = cloudru_k8s_cluster.example-cluster.id

  name = "example-nodepool"

  scale_policy = {
    fixed_scale = {
      count = 3
    }
  }

  hardware_compute = {
    disk_size = 10
    disk_type = "DISK_TYPE_SSD_NVME"
    flavor_id = "00000000-0000-0000-0000-000000000000"
  }

  nodes_network_configuration = {
    # Идентификатор подсети узлов.
    nodes_subnet_id = "00000000-0000-0000-0000-000000000000"
  }

  timeouts = {
    # Время, необходимое для создания, чтения, обновления и удаления.
    # Может сильно различаться в зависимости от количества узлов в группе узлов.
    create = "50m"
    read   = "15s"
    update = "40m"
    delete = "40m"
  }

  taints = [
    {
      key    = "key1"
      value  = "value1"
      effect = "EFFECT_NO_SCHEDULE"
    },
  ]

  labels = {
    "key1" = "value1"
    "key2" = "value2"
  }

  depends_on = [
    cloudru_k8s_cluster.example-cluster
  ]
}
```

> **NOTE:** Рекомендуем указывать зависимость группы узлов от кластера в секции `depends_on` для простоты управления ресурсами.

Также можно использовать `replace_triggered_by` для пересоздания группы узлов, если кластер заменяется. Для этого добавьте следующий блок к `cloudru_k8s_nodepool`:

```terraform
  lifecycle {
    replace_triggered_by = [
      # Пересоздание группы узлов каждый раз, когда `cloudru_k8s_cluster` заменяется.
      cloudru_k8s_cluster.example-cluster.id
    ]
  }
```

### Конфигурация с использованием источников данных

Некоторые поля при создании группы узлов могут быть заполнены данными из источников данных.
Следующий пример показывает указание идентификатора конфигурации для `lowcost10-2-4` и идентификатора подсети узлов, используя источники данных:

```terraform
# Источник данных для получения информации о доступных шаблонах конфигураций.
data "cloudru_k8s_zone_flavors" "k8s_flavors" {}

# Источник данных для получения существующих подсетей для заданного проекта.
data "cloudru_evolution_subnet" "subnets" {}

resource "cloudru_k8s_nodepool" "example-nodepool" {
  cluster_id = cloudru_k8s_cluster.example-cluster.id

  name = "example-nodepool"

  scale_policy = {
    fixed_scale = {
      count = 3
    }
  }

  hardware_compute = {
    disk_size = 10
    disk_type = "DISK_TYPE_SSD_NVME"

    # NOTE: Обязательный параметр.
    # Идентификатор шаблона конфигурации.
    # Доступен к получению через datasource cloudru_k8s_zone_flavors.
    # В данном примере передается идентификатор шаблона конфигурации с наименованием "lowcost10-2-4".
    flavor_id = data.cloudru_k8s_zone_flavors.k8s_flavors.flavors[index(data.cloudru_k8s_zone_flavors.k8s_flavors.flavors.*.name, "lowcost10-2-4")].id
  }

  nodes_network_configuration = {

    # NOTE: Обязательный параметр, если не указан nodes_subnet_cidr.
    # Идентификатор существующей сети для группы узлов. Указывается либо он, либо nodes_subnet_cidr.
    # В примере передается идентификатор сети с наименованием "my_nodes_subnet".
    nodes_subnet_id = tolist(data.cloudru_evolution_subnet.subnets.resources)[index(tolist(data.cloudru_evolution_subnet.subnets.resources).*.name, "my_nodes_subnet")].id
  }

  depends_on = [
    cloudru_k8s_cluster.example-cluster
  ]
}
```

### Пример создания группы узлов с автомасштабированием

```terraform
resource "cloudru_k8s_nodepool" "example-nodepool" {

  # NOTE: Обязательный параметр.
  # Идентификатор кластера, в котором будет создана группа узлов.
  cluster_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Обязательный параметр.
  # Название группы узлов. Должно быть уникальным.
  # Может содержать буквы, цифры, подчеркивание.
  # Допустимое количество символов от 4 до 60.
  name = "example-nodepool"

  # NOTE: Обязательный параметр.
  # Политика масштабирования группы узлов.
  # Нужно указать только один из следующих блоков: fixed_scale или auto_scale.
  scale_policy = {

    # NOTE: Обязательный параметр.
    # Группа узлов с поддержкой автоматического масштабирования.
    auto_scale = {

      # NOTE: Обязательный параметр.
      # Минимальное количество узлов в группе узлов.
      min_count = 1

      # NOTE: Обязательный параметр.
      # Максимальное количество узлов в группе узлов.
      max_count = 10

      # NOTE: Обязательный параметр.
      # Начальное количество узлов.
      # Обязателен при создании группы узлов.
      # При редактировании группы узлов является опциональным.
      initial_count = 1
    }
  }

  # NOTE: Обязательный параметр.
  # Описание инфраструктуры узлов группы.
  hardware_compute = {

    # NOTE: Обязательный параметр.
    # Размер подключаемого диска в ГБ.
    disk_size = 10

    # NOTE: Обязательный параметр.
    # Идентификатор шаблона конфигурации.
    flavor_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Обязательный параметр.
  # Конфигурация сети группы узлов.
  nodes_network_configuration = {

    # NOTE: Обязательный параметр, если не указан nodes_subnet_id.
    # Адрес сети узлов.
    # Должен принадлежать диапазонам 10.0.0.0/20–28, 172.16.0.0/20–28 или 192.168.0.0/20–28.
    # Не должен пересекаться с сетью сервисов или сетью подов кластера.
    # Если указать это значение, то сеть будет создана автоматически.
    nodes_subnet_cidr = "192.168.123.0/24"
  }
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `cluster_id` (String) Идентификатор кластера, в котором будет создана группа узлов.
- `hardware_compute` (Attributes) Запрос конфигурации виртуальной машины. (see [below for nested schema](#nestedatt--hardware_compute))
- `name` (String) Название группы узлов. Должно быть уникальным. Может содержать буквы, цифры, подчеркивание. Допустимое количество символов от 4 до 60.
- `nodes_network_configuration` (Attributes) Конфигурация сети группы узлов. (see [below for nested schema](#nestedatt--nodes_network_configuration))
- `scale_policy` (Attributes) Политика масштабирования группы узлов в кластере. (see [below for nested schema](#nestedatt--scale_policy))

### Optional

- `labels` (Map of String) Набор меток (labels), которые будут применены к узлам в группе. Метки добавляются в дополнение к стандартным меткам, которые может применить Kubernetes. В случае конфликтов поведение неопределенно и может меняться в зависимости от версии Kubernetes, поэтому лучше избегать таких конфликтов. Подробнее см. [в документации Kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
- `taints` (Attributes List) Список ограничений (taints), применяемых к узлам в группе, Подробнее см. [в документации Kubernetes](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) (see [below for nested schema](#nestedatt--taints))
- `timeouts` (Attributes) (see [below for nested schema](#nestedatt--timeouts))

### Read-Only

- `created_at` (String) Время создания группы узлов.
- `created_by` (String) Идентификатор пользователя, создавшего группу узлов.
- `id` (String) Идентификатор группы узлов.
- `state` (String) Состояние группы узлов. Возможные значения: `OBJECT_STATE_UNSPECIFIED` `OBJECT_STATE_PENDING` `OBJECT_STATE_PAUSING` `OBJECT_STATE_RESUMING` `OBJECT_STATE_STOPPED` `OBJECT_STATE_SUSPENDED` `OBJECT_STATE_RUNNING` `OBJECT_STATE_PAUSED` `OBJECT_STATE_UPDATING` `OBJECT_STATE_ERROR` `OBJECT_STATE_SCALING_UP` `OBJECT_STATE_SUSPENDING` `OBJECT_STATE_PROVISIONING` `OBJECT_STATE_SCALING_DOWN` `OBJECT_STATE_STOPPING` `OBJECT_STATE_DELETING`.
- `task_id` (String) Информация о задаче, связанной с группой узлов.
- `updated_at` (String) Время последнего обновления группы узлов.
- `updated_by` (String) Идентификатор пользователя, обновившего группу узлов.
- `version` (String) Версия Kubernetes, которая используется на узлах группы. Список доступных версий может быть получен через k8s_version_datasource.

<a id="nestedatt--hardware_compute"></a>
### Nested Schema for `hardware_compute`

Required:

- `disk_size` (Number) Размер подключаемого диска в ГБ. Размер диска от 10 до 64 ГБ. Если не указан, то размер диска по умолчанию для кластера — 10 ГБ.
- `disk_type` (String) Тип диска. Возможные значения: `DISK_TYPE_UNSPECIFIED` `DISK_TYPE_SSD_NVME`.
- `flavor_id` (String) Идентификатор шаблона конфигурации.


<a id="nestedatt--nodes_network_configuration"></a>
### Nested Schema for `nodes_network_configuration`

Optional:

- `nodes_subnet_cidr` (String) Адрес сети узлов. Должен принадлежать диапазонам 10.0.0.0/20–28, 172.16.0.0/20–28 или 192.168.0.0/20–28. Если указать это значение, то сеть будет создана автоматически. Либо это поле, либо поле nodes_subnet_id должно быть указано.
- `nodes_subnet_id` (String) Идентификатор существующей сети узлов. Либо это поле, либо nodes_subnet_cidr должно быть указано.
- `security_group_id` (String) Идентификатор группы безопасности.


<a id="nestedatt--scale_policy"></a>
### Nested Schema for `scale_policy`

Optional:

- `auto_scale` (Attributes) Группа узлов с поддержкой автоматического масштабирования. (see [below for nested schema](#nestedatt--scale_policy--auto_scale))
- `fixed_scale` (Attributes) Группа узлов с фиксированным числом узлов. (see [below for nested schema](#nestedatt--scale_policy--fixed_scale))

<a id="nestedatt--scale_policy--auto_scale"></a>
### Nested Schema for `scale_policy.auto_scale`

Required:

- `initial_count` (Number) Начальное количество узлов.
- `max_count` (Number) Максимальное количество узлов в группе узлов.
- `min_count` (Number) Минимальное количество узлов в группе узлов.


<a id="nestedatt--scale_policy--fixed_scale"></a>
### Nested Schema for `scale_policy.fixed_scale`

Required:

- `count` (Number) Количество узлов в группе.



<a id="nestedatt--taints"></a>
### Nested Schema for `taints`

Required:

- `effect` (String) Типы эффектов ограничения. Возможные значения: `EFFECT_UNSPECIFIED` `EFFECT_NO_SCHEDULE` `EFFECT_PREFER_NO_SCHEDULE` `EFFECT_NO_EXECUTE`.
- `key` (String) Ключ.
- `value` (String) Значение.


<a id="nestedatt--timeouts"></a>
### Nested Schema for `timeouts`

Optional:

- `create` (String) По умолчанию 40m0s.
- `delete` (String) По умолчанию 30m0s.
- `read` (String) По умолчанию 15s.
- `update` (String) По умолчанию 30m0s.

## Импорт

Импорт может быть выполнен с помощью следующей команды:

```shell
terraform import cloudru_k8s_nodepool.test nodepool_id_goes_here
```

## Редактирование группы узлов

После создания группы узлов в кластере можно изменить название `name` и политику масштабирования `scale_polic`.

Изменение других полей потребует пересоздания группы узлов. Это означает, что существующая группа узлов будет удалена и после этого создана новая. Для предотвращения случайного удаления группы узлов используйте lifecycle policy.

```terraform
resource "cloudru_k8s_nodepool" "example-nodepool" {
  cluster_id = "00000000-0000-0000-0000-000000000000"

  name = "example-nodepool"

  scale_policy = {
    fixed_scale = {
      count = 1
    }
  }

  hardware_compute = {
    disk_size = 10
    # Идентификатор шаблона конфигурации виртуальной машины.
    flavor_id = "00000000-0000-0000-0000-000000000000"
  }

  nodes_network_configuration = {
    nodes_subnet_cidr = "192.168.123.0/24"
  }

  # Предотвращает пересоздание группы узлов во время обновления.
  lifecycle {
    prevent_destroy = true
  }
  depends_on = [
    cloudru_k8s_cluster.example-cluster
  ]
}
```