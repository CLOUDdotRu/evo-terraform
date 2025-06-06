resource "cloudru_k8s_nodepool" "example-nodepool" {

  # NOTE: Обязательный параметр.
  # Идентификатор кластера, в котором будет создана группа узлов.
  cluster_id = cloudru_k8s_cluster.example-cluster.id

  # NOTE: Обязательный параметр.
  # Название группы узлов. Должно быть уникальным.
  # Может содержать буквы, цифры, подчеркивание.
  # Допустимое количество символов от 4 до 60.
  name = "example-nodepool"

  # NOTE: Обязательный параметр.
  # Политика масштабирования группы узлов.
  # Нужно указать только один из следующих блоков: fixed_scale или auto_scale, но не оба одновременно.
  scale_policy = {

    # NOTE: Обязательный параметр.
    # Группа узлов с фиксированным числом узлов.
    fixed_scale = {

      # NOTE: Обязательный параметр.
      # Количество узлов в группе.
      count = 1
    }

    # # NOTE: Обязательный параметр..
    # # Группа узлов с поддержкой автоматического масштабирования.
    # auto_scale = {

    #   # NOTE: Обязательный параметр.
    #   # Минимальное количество узлов в группе узлов.
    #   min_count = 1

    #   # NOTE: Обязательный параметр.
    #   # Максимальное количество узлов в группе узлов.
    #   max_count = 10

    #   # NOTE: Обязательный параметр.
    #   # Начальное количество узлов.
    #   # Обязателен при создании группы узлов.
    #   # При редактировании группы узлов является опциональным.
    #   initial_count = 1
    # }
  }

  # NOTE: Обязательный параметр.
  # Описание инфраструктуры узлов группы.
  hardware_compute = {

    # NOTE: Обязательный параметр.
    # Размер подключаемого диска в ГБ.
    disk_size = 10

    # NOTE: Опциональный параметр. По умолчанию будет выбран DISK_TYPE_SSD_NVME.
    # Тип диска.
    disk_type = "DISK_TYPE_SSD_NVME"

    # NOTE: Обязательный параметр.
    # Идентификатор шаблона конфигурации.
    # Доступен к получению через datasource cloudru_k8s_zone_flavors.
    flavor_id = data.cloudru_k8s_zone_flavors.k8s_flavors.flavors[index(data.cloudru_k8s_zone_flavors.k8s_flavors.flavors.*.name, "lowcost10-2-4")].id
  }

  # NOTE: Обязательный параметр.
  # Конфигурация сети группы узлов.
  nodes_network_configuration = {

    # NOTE: Обязательный параметр, если не указан nodes_subnet_id.
    # Адрес сети узлов формате RFC1918.
    # Не должен пересекаться с сетью сервисов или сетью подов кластера.
    # Если указать это значение, то сеть будет создана автоматически.
    nodes_subnet_cidr = "192.168.123.0/24"

    # NOTE: Обязательный параметр, если не указан nodes_subnet_cidr.
    # Идентификатор существующей сети узлов. Указывается либо он, либо nodes_subnet_cidr.
    # nodes_subnet_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Опциональный параметр.
  timeouts = {

    # NOTE: Опциональный параметр.
    # Ограничение по времени создания объекта.
    # Если объект не успел создаться за указанное время, то вернется ошибка, при этом автоматического удаления не последует.
    # Время создания группы узлов в числе прочих факторов зависит и от количество узлов в группе. Чем больше узлов, тем дольше группа узлов будет создаваться.
    create = "30m"

    # NOTE: Опциональный параметр.
    # Ограничение по времени получения объекта.
    read = "15s"

    # NOTE: Опциональный параметр.
    # Ограничение по времени редактирования объекта.
    update = "30m"

    # NOTE: Опциональный параметр.
    # Ограничение по времени удаления объекта.
    delete = "30m"
  }

  # NOTE: Опциональный параметр.
  # Список ограничений (taints), применяемых к узлам в группе, https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/.
  # taints = [
  #  {
  #    key = "key1"
  #    value = "value1"
  #    effect = "EFFECT_NO_SCHEDULE"
  #  },
  # ]

  # NOTE: Опциональный параметр.
  # Набор меток (labels), которые будут применены к узлам в группе.
  # Метки добавляются в дополнение к стандартным меткам, которые может применить Kubernetes.
  # В случае конфликтов поведение неопределенно и может меняться в зависимости от версии Kubernetes,
  # поэтому лучше избегать таких конфликтов. https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  # labels = {
  #  "key1" = "value1"
  #  "key2" = "value2"
  # }

  # NOTE: Опциональный параметр.
  # Конфигурация удаленного доступа к виртуальной машине в группе (RemoteAccess).
  # remote_access = {
  # Идентификатор SSH-ключа.
  #  ssh_key_id = "00000000-0000-0000-0000-000000000000"
  # Имя пользователя.
  #  username = "your_username"
  #}

  # NOTE: Опциональный параметр.
  # Конфигурация обновления группы узлов.
  # update_configuration = {

  # NOTE: Опциональный параметр.
  # Стратегия обновления.
  # strategy = "NODE_POOL_UPDATE_STRATEGY_ROLLING_UPDATE"

  # Параметры политики обновления RollingUpdate (опциональный блок).
  # rolling_update_policy = {
  # Максимальное количество дополнительных узлов (%). Обязательный параметр при наличии rolling_update_policy.
  # max_surge = 10

  # Максимальное количество одновременно недоступных узлов (%). Обязательный параметр при наличии rolling_update_policy.
  # max_unavailable = 20
  # }
  #}

  # NOTE: Опциональный параметр.
  # Зона доступности, в которой будут размещены узлы группы.
  # zone = "00000000-0000-0000-0000-000000000000"

  # NOTE: Опциональный параметр.
  # Задает связь группы узлов и кластера.
  depends_on = [
    cloudru_k8s_cluster.example-cluster
  ]

  # NOTE: Вычисляемый параметр.
  # Идентификатор группы узлов
  # id         = "00000000-0000-0000-0000-000000000000"

  # NOTE: Вычисляемый параметр.
  # Идентификатор задачи, связанной с группой узлов.
  # task_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Вычисляемый параметр.
  # Состояние группы узлов.
  # state = "OBJECT_STATE_RUNNING"
}
