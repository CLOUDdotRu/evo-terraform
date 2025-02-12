---
page_title: "cloudru_k8s_cluster Resource - cloudru"
subcategory: "k8s"
description: "Управление кластерами Kubernetes"
  Evolution Kubernetes Cluster
---

# Управление кластерами cloudru_k8s_cluster (Resource)

В разделе рассмотрены примеры управления кластером, а также приведено описание всех полей ресурса cloudru_k8s_cluster.

## Примеры использования

Примеры описывают несколько вариантов создания кластера: 

- только с обязательными настройками;
- с расширенными настройками;
- с настройками, которые могут быть заполнены с помощью источников данных.

### Базовая конфигурация

В примере рассматривается создание кластера с настройкой только обязательных полей.
Кластер будет создан в проекте, `project_id` которого указан в глобальных настройках провайдера.

```terraform
resource "cloudru_k8s_cluster" "example-cluster" {

  # NOTE: Обязательный параметр.
  # Название кластера.
  # Может содержать буквы, цифры, дефис, подчеркивание.
  # Допустимое количество символов от 3 до 60.
  name = "example-cluster"

  # NOTE: Обязательный параметр.
  # Конфигурация плоскости управления.
  control_plane = {

    # NOTE: Обязательный параметр.
    # Количество узлов плоскости управления.
    count = 1

    # NOTE: Обязательный параметр.
    # Тип узла плоскости управления.
    type = "MASTER_TYPE_SMALL"

    # NOTE: Обязательный параметр.
    # Версия Kubernetes.
    version = "v1.29.9"
  }

  # NOTE: Обязательный параметр.
  # Описание сетевой инфраструктуры кластера.
  network_configuration = {

    # NOTE: Обязательный параметр.
    # Адрес подсети сервисов.
    # Должен принадлежать диапазонам 10.0.0.0/12–28, 172.16.0.0/12–28 или 192.168.0.0/16–28.
    # Не должен пересекаться с подовой сетью или сетью узлов.
    services_subnet_cidr = "10.0.0.0/20"

    # NOTE: Обязательный параметр, если не указан параметр nodes_subnet_id.
    # Адрес подсети узлов плоскости управления.
    # Должен принадлежать диапазонам 10.0.0.0/20–28, 172.16.0.0/20–28 или 192.168.0.0/20–28.
    # Не должен пересекаться с сетью сервисов или сетью подов.
    nodes_subnet_cidr = "192.168.20.0/24"

    # NOTE: Обязательный параметр.
    # Адрес подсети подов.
    # Должен принадлежать диапазонам 10.0.0.0/8–24, 172.16.0.0/12–24 или 192.168.0.0/16–24.
    # Не должен пересекаться с сетью сервисов или сетью узлов.
    pods_subnet_cidr = "172.16.0.0/12"

    # NOTE: Обязательный параметр.
    # Публикация kube-apiserver в интернет.
    kube_api_internet = true
  }
}
```

### Расширенная конфигурация

В примере рассматривается создание кластера с настройкой дополнительных полей. Например, идентификатора лог-группы для логирования событий компонентов кластера.

Для подсети мастер-узлов вместо адреса подсети можно указать идентификатор ранее созданной сети.

```terraform
resource "cloudru_k8s_cluster" "example-cluster" {

  # NOTE: Обязательный параметр.
  # Название кластера.
  # Может содержать буквы, цифры, дефис, подчеркивание.
  # Допустимое количество символов от 3 до 60.
  name = "example-cluster"

  # NOTE: Опциональный параметр, если указан project_id в конфигурации провайдера.
  # Если project_id не указан в конфигурации провайдера или его требуется переопределить, то project_id должен быть указан.
  # Идентификатор проекта.
  project_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Обязательный параметр.
  # Конфигурация плоскости управления.
  control_plane = {

    # NOTE: Опциональный параметр.
    # Указывает в каких зонах будут размещены узлы управления.
    # Доступен к получению через datasource cloudru_k8s_zone_flavors
    zones = [
      "00000000-0000-0000-0000-000000000000",
    ]

    # NOTE: Обязательный параметр.
    # Количество узлов плоскости управления.
    count = 3

    # NOTE: Обязательный параметр.
    # Тип узла плоскости управления.
    type = "MASTER_TYPE_SMALL"

    # NOTE: Обязательный параметр.
    # Версия Kubernetes.
    version = "v1.29.9"
  }

  # NOTE: Обязательный параметр.
  # Описание сетевой инфраструктуры кластера.
  network_configuration = {

    # NOTE: Обязательный параметр.
    # Адрес подсети сервисов.
    # Должен принадлежать диапазонам 10.0.0.0/12–28, 172.16.0.0/12–28 или 192.168.0.0/16–28.
    # Не должен пересекаться с подовой сетью или сетью узлов.
    services_subnet_cidr = "10.0.0.0/20"

    # NOTE: Обязательный параметр, если не указан nodes_subnet_cidr.
    # Идентификатор существующей сети узлов. Указывается либо он, либо nodes_subnet_cidr.
    nodes_subnet_id = "fe447d9e-41cb-49f9-bb75-d61c498baee7"

    # NOTE: Обязательный параметр.
    # Адрес подсети подов.
    # Должен принадлежать диапазонам 10.0.0.0/8–24, 172.16.0.0/12–24 или 192.168.0.0/16–24.  
    # Не должен пересекаться с сетью сервисов или сетью узлов.
    pods_subnet_cidr = "172.16.0.0/12"

    # NOTE: Обязательный параметр.
    # Публикация kube-apiserver в интернет.
    kube_api_internet = true
  }

  # Опциональный параметр.
  # Логирование событий компонентов кластера.
  logging_service = {

    # NOTE: Опциональный параметр.
    # Включение/выключение логирования событий компонентов кластера.
    # Возможные значения: true — логирование включено, false — логирование выключено.
    # По умолчанию логирование включено.
    # Если установлен параметр false, настройки лог-группы игнорируются.
    enabled = true

    # NOTE: Опциональный параметр.
    # Идентификатор лог-группы.
    # Если не указывается, используется значение по умолчанию.
    log_group_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Опциональный параметр.
  # Мониторинг компонентов кластера.
  monitoring_service = {

    # NOTE: Опциональный параметр.
    # Включение/выключение мониторинга компонентов кластера.
    # Возможные значения: true — мониторинг включен, false — мониторинг выключен.
    # По умолчанию мониторинг включен.
    enabled = true
  }

  # NOTE: Опциональный параметр.
  # Аудит-логирование событий компонентов кластера.
  audit_service = {

    # NOTE: Опциональный параметр.
    # Включение/выключение аудит-логирования событий компонентов кластера.
    # Возможные значения: true — аудит-логирование включено, false — аудит-логирование выключено.
    # По умолчанию аудит-логирование включено.
    enabled = true
  }

  # NOTE: Опциональный параметр.
  # Релизный канал, на который подписан кластер.
  # Возможные значения: RELEASE_CHANNEL_REGULAR, RELEASE_CHANNEL_RAPID, RELEASE_CHANNEL_STABLE.
  release_channel = "RELEASE_CHANNEL_STABLE"

  # NOTE: Опциональный параметр.
  # Конфигурация сервисного аккаунта кластера, который используется для интеграции с сервисами облака Evolution. Например, с Artifact Registry, Object Storage, сервисами логирования и мониторинга.
  identity_configuration = {

    # NOTE: Обязательный параметр.
    # Идентификатор сервисного аккаунта.
    # ID можно скопировать в личном кабинете из URL на странице сервисного аккаунта или получить через API.
    # Подробнее: https://cloud.ru/docs/console_api/ug/topics/guides__service_accounts_view.html 
    cluster_sa_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Опциональный параметр.
  timeouts = {

    # NOTE: Опциональный параметр.
    # Ограничение по времени создания объекта.
    # Если объект не успел создаться за указанное время, то вернется ошибка, при этом автоматического удаления не последует.
    # Время создания плоскости управления кластера в числе прочих факторов зависит и от количество узлов. 
    # Чем больше узлов, тем дольше группа узлов будет создаваться.
    create = "50m"

    # NOTE: Опциональный параметр.
    # Ограничение по времени получения объекта.
    read = "15s"

    # NOTE: Опциональный параметр.
    # Ограничение по времени редактирования объекта.
    update = "40m"

    # NOTE: Опциональный параметр.
    # Ограничение по времени удаления объекта.
    delete = "40m"
  }
}
```

### Конфигурация с использованием источников данных

Следующий пример показывает создание кластера, для которого параметры заполняются с помощью источников данных.
Обратите внимание на указанные в начале примера источники данных. В приведенном примере с помощью источников данных заполняются
поля:
- zones — с указанием зоны доступности для размещения узлов плоскости управления.
- nodes_subnet_id — с указанием идентификатора существующей подсети для узлов плоскости управления.

```terraform
# Источник данных для получения существующих подсетей для заданного проекта.
data "cloudru_evolution_subnet" "subnets" {}

# Источник данных для получения информации о зонах доступности.
data "cloudru_k8s_zone_flavors" "k8s_zones" {}

resource "cloudru_k8s_cluster" "example-cluster" {
  name = "example-cluster"

  control_plane = {
    count   = 1
    type    = "MASTER_TYPE_SMALL"
    version = "v1.29.9"

    # NOTE: Обязательный параметр.
    # Взаимодействует с флагом multizonal.
    # Указывает, в каких зонах будут размещены узлы управления.
    # Доступен к получению через datasource cloudru_k8s_zone_flavors.
    # В данном примере передается идентификатор зоны доступности с наименованием "ru.AZ-1".
    zones = [
      data.cloudru_k8s_zone_flavors.k8s_zones.availability_zones[index(data.cloudru_k8s_zone_flavors.k8s_zones.availability_zones.*.name, "ru.AZ-1")].id
    ]
  }

  network_configuration = {
    services_subnet_cidr = "10.0.0.0/20"

    # NOTE: обязательный параметр, если не указан nodes_subnet_cidr.
    # Идентификатор существующей сети для мастер-узлов.
    # Существующие подсети могут быть получены через datasource cloudru_evolution_subnet.
    # В данном примере передается идентификатор существующей подсети с наименованием "my_master_nodes_subnet".
    nodes_subnet_id   = tolist(data.cloudru_evolution_subnet.subnets.resources)[index(tolist(data.cloudru_evolution_subnet.subnets.resources).*.name, "my_master_nodes_subnet")].id
    pods_subnet_cidr  = "172.16.0.0/12"
    kube_api_internet = true
  }
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `control_plane` (Attributes) Конфигурация плоскости управления. (see [below for nested schema](#nestedatt--control_plane))
- `name` (String) Название кластера, которое ввел пользователь. Допустимое количество символов от 3 до 60.
- `network_configuration` (Attributes) Сетевая конфигурация кластера. (see [below for nested schema](#nestedatt--network_configuration))

### Optional

- `audit_service` (Attributes) Аудит-логирование событий компонентов кластера. (see [below for nested schema](#nestedatt--audit_service))
- `identity_configuration` (Attributes) Настройки для сервисного аккаунта. (see [below for nested schema](#nestedatt--identity_configuration))
- `logging_service` (Attributes) Параметры логирования событий компонентов кластера. (see [below for nested schema](#nestedatt--logging_service))
- `monitoring_service` (Attributes) Мониторинг компонентов кластера. (see [below for nested schema](#nestedatt--monitoring_service))
- `project_id` (String) Идентификатор проекта. Может быть указан для ресурса. Если указан и в настройках провайдера, и в описании ресурса, будет использован указанный в описании ресурса.
- `release_channel` (String) Релизный канал может быть одним из: `RELEASE_CHANNEL_UNSPECIFIED` `RELEASE_CHANNEL_RAPID` `RELEASE_CHANNEL_REGULAR` `RELEASE_CHANNEL_STABLE` .
- `timeouts` (Attributes) (see [below for nested schema](#nestedatt--timeouts))

### Read-Only

- `created_at` (String) Время создания кластера, присваивается автоматически при создании кластера.
- `created_by` (String) Идентификатор пользователя, создавшего кластер.
- `id` (String) Идентификатор кластера. Присваивается автоматически при создании кластера.
- `nodepools_info` (Attributes) Информация о группах узлов. (see [below for nested schema](#nestedatt--nodepools_info))
- `state` (String) Состояние кластера (мастеров). Возможные значения: `OBJECT_STATE_UPGRADING` `OBJECT_STATE_PAUSED` `OBJECT_STATE_RESUMING` `OBJECT_STATE_STOPPING` `OBJECT_STATE_SCALING_DOWN` `OBJECT_STATE_SUSPENDING` `OBJECT_STATE_UNSPECIFIED` `OBJECT_STATE_PENDING` `OBJECT_STATE_ERROR` `OBJECT_STATE_RUNNING` `OBJECT_STATE_UPDATING` `OBJECT_STATE_SCALING_UP` `OBJECT_STATE_STOPPED` `OBJECT_STATE_SUSPENDED` `OBJECT_STATE_PROVISIONING` `OBJECT_STATE_PAUSING` `OBJECT_STATE_DELETING`.
- `task_id` (String) Идентификатор задачи.
- `updated_at` (String) Время последнего редактирования кластера.
- `updated_by` (String) Идентификатор пользователя, который редактировал кластер последним.
- `version_upgrade` (Attributes) Информация о доступных версиях Kubernetes для обновления плоскости управления кластера. (see [below for nested schema](#nestedatt--version_upgrade))

<a id="nestedatt--control_plane"></a>
### Nested Schema for `control_plane`

Required:

- `count` (Number) Количество узлов плоскости управления. Возможные значения: `1`, `3`, `5`.
- `type` (String) Тип узла плоскости управления. Возможные значения: `MASTER_TYPE_EXTRALARGE` `MASTER_TYPE_UNSPECIFIED` `MASTER_TYPE_SMALL` `MASTER_TYPE_MEDIUM` `MASTER_TYPE_LARGE`.
- `version` (String) Версия Kubernetes. Список доступных версий может быть получен через источник данных k8s_version_datasource Версия должна быть в формате SemVer и начинаться с *v*: **v1.2.3**.

Optional:

- `zones` (List of String) Зоны доступности, в которых будут размещены узлы плоскости управления. Для зонального кластера указывается одна зона, для регионального — две или более.


<a id="nestedatt--network_configuration"></a>
### Nested Schema for `network_configuration`

Required:

- `kube_api_internet` (Boolean) Публикация kube-apiserver в интернет.
- `pods_subnet_cidr` (String) Адрес подсети подов. Должен принадлежать диапазонам 10.0.0.0/8–24, 172.16.0.0/12–24 или 192.168.0.0/16–24. Не должен пересекаться с сервисной подсетью или подсетью узлов плоскости управления.
- `services_subnet_cidr` (String) Адрес подсети сервисов. Не должен пересекаться с подовой или нодовой сетью. Должен принадлежать диапазонам 10.0.0.0/12–28, 172.16.0.0/12–28 или 192.168.0.0/16–28

Optional:

- `nodes_subnet_cidr` (String) Адрес подсети узлов плоскости управления. Не должен пересекаться с сервисной или подовой сетью. Должно принадлежать диапазонам 10.0.0.0/20–28, 172.16.0.0/20–28 или 192.168.0.0/20–28.Если указана, сеть будет создана автоматически. Либо это поле, либо поле `nodes_subnet_id` должно быть указано.
- `nodes_subnet_id` (String) Идентификатор существующей сети, которая должна использоваться для узлов плоскости управления. Либо это поле, либо `nodes_subnet_cidr` должно быть указано.

Read-Only:

- `control_plane_endpoints` (Map of String) Множество адресов, где ключ это тип сети. Возможные значения:`NETWORK_TYPE_PUBLIC` `NETWORK_TYPE_UNSPECIFIED` `NETWORK_TYPE_PRIVATE` и значения это адреса узлов управления в формате [https://domain:port](https://domain:port).


<a id="nestedatt--audit_service"></a>
### Nested Schema for `audit_service`

Optional:

- `enabled` (Boolean) Включение/выключение аудит-логирования событий компонентов кластера. Возможные значения: **true** — аудит-логирование включено, **false** — аудит-логирование выключено. По умолчанию аудит-логирование **включено**.


<a id="nestedatt--identity_configuration"></a>
### Nested Schema for `identity_configuration`

Optional:

- `cluster_sa_id` (String) Конфигурация сервисного аккаунта кластера, который используется для интеграции с сервисами облака Evolution.  Например, с Artifact Registry, Object Storage, сервисами логирования и мониторинга. ID сервисного аккаунта можно скопировать в личном кабинете из URL на странице сервисного аккаунта или получить через API — https://cloud.ru/docs/console_api/ug/topics/guides__service_accounts_view.html.


<a id="nestedatt--logging_service"></a>
### Nested Schema for `logging_service`

Optional:

- `enabled` (Boolean) Включение/выключение логирования событий компонентов кластера. Возможные значения: **true** — логирование включено, **false** — логирование выключено. По умолчанию логирование включено **true**. Если установлен параметр **false**, настройки лог-группы игнорируются.
- `log_group_id` (String) Идентификатор лог-группы. Если не указывается, используется значение по умолчанию.


<a id="nestedatt--monitoring_service"></a>
### Nested Schema for `monitoring_service`

Optional:

- `enabled` (Boolean) Включение/выключение мониторинга компонентов кластера. Возможные значения: **true** — мониторинг включен, **false** — мониторинг выключен. По умолчанию мониторинг **включен**.


<a id="nestedatt--timeouts"></a>
### Nested Schema for `timeouts`

Optional:

- `create` (String) По умолчанию 40m0s.
- `delete` (String) По умолчанию 40m0s.
- `read` (String) По умолчанию 15s.
- `update` (String) По умолчанию 30m0s.


<a id="nestedatt--nodepools_info"></a>
### Nested Schema for `nodepools_info`

Read-Only:

- `count` (Number) Количество групп узлов.
- `cpu` (Number) Количество ядер процессора виртуальных машин.
- `disk_size` (Number) Размер подключаемых дисков в ГБ.
- `ram` (Number) Оперативная память виртуальных машин в ГБ.


<a id="nestedatt--version_upgrade"></a>
### Nested Schema for `version_upgrade`

Read-Only:

- `available_versions` (List of String) Список доступных версий Kubernetes для обновления кластера.
- `upgrade_available` (Boolean) Флаг доступности новой версии Kubernetes.

## Импорт

Для импорта выполните команду:

```shell
terraform import cloudru_k8s_cluster.example-cluster cluster_id_goes_here
```
## Редактирование настроек кластера

После создания кластера можно изменить название `name` и количество мастер-узлов `control_plane.count`.

Изменение других полей требует пересоздания кластера. Это означает, что существующий кластер будет удален и после этого создан новый с требуемой конфигурацией.

> **NOTE:** Обратите внимание, что в случае удаления кластера будут также удалены и его группы узлов.

В качестве дополнительной меры предосторожности от случайного удаления можно воспользоваться следующим дополнением к конфигурации кластера:

```terraform
resource "cloudru_k8s_cluster" "example-cluster" {
  name = "example-cluster"

  control_plane = {
    count   = 1
    type    = "MASTER_TYPE_SMALL"
    version = "v1.29.9"
  }

  network_configuration = {
    services_subnet_cidr = "10.0.0.0/20"
    nodes_subnet_cidr    = "192.168.20.0/24"
    pods_subnet_cidr     = "172.16.0.0/12"
    kube_api_internet    = true
  }

  # Блокирует удаление в процессе пересоздания кластера.
  lifecycle {
    prevent_destroy = true
  }
}
```

> **NOTE:** не рекомендуется использовать `lifecycle.create_before_destroy` без изменения названия кластера при обновлении, так как название кластера должно быть уникальным в рамках проекта.
