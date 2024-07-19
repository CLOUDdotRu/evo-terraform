resource "cloudru_postgresql_cluster" "my-pg-cluster" {
  # название кластера.
  name = "example-postgres-cluster"
  # название продукта: postgres или timescaledb
  product_type = "postgres"
  # описание кластера.
  description = "DBaaS Evolution Postgres"
  # идентификатор подсети.
  subnet_id = "00000000-0000-0000-0000-000000000000"
  # название базы данных, которая будет создана в экземпляре сервиса по умолчанию
  initial_database = "mydb"
  # параметры кластера
  cluster_spec = {
    # идентификатор версии продукта
    version_id = local.demo_postgres_version_16.id
    # идентификатор опции, назначенной кластеру
    option_id = local.demo_postgres_option_4_8_business.id
    # включает или отключает пулер соединений PgBouncer
    pooler_enabled = true
    # определяет отказоустойчивость кластера. Возможные значения:
    #  - true --- отказоустойчивая конфигурация с двумя синхронизированными узлами: основным и резервным.
    #  - false --- одноузловая конфигурация.
    primary_standby_mode = false
    # количество реплик на чтение
    replicas = 2
    # защищает от случайного удаления базы данных
    safe_delete = true
    # синхронную репликацию
    sync_replication = false
    # Необязательно. Параметры автоматического резервного копирования
    backup = {
      #  срок хранения автоматически созданных резервных копий.
      # Максимальное значение --- 90 дней.
      retention_policy_days = 30
      # расписание автоматического резервного копирования в формате CRON-выражения
      schedule = "0 0 * * *"
    }
    # параметры диска
    disk = {
      # идентификатор диска
      id = local.demo_postgres_disk_ssd.id
      # размер диска в гигабайтах
      size_gigs = 50
    }
  }
}
