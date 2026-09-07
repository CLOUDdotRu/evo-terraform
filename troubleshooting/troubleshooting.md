# Инструкции по устранению проблем с Terraform Provider для Cloud.ru Evolution

Terraform Provider для Cloud.ru Evolution — это инструмент, который позволяет управлять ресурсами облачной инфраструктуры с помощью кода (Infrastructure as Code). Провайдер работает как мост между Terraform и API Cloud.ru, позволяя создавать, изменять и удалять облачные ресурсы декларативным способом.

## Как работает провайдер

1. Terraform читает ваши конфигурационные файлы (.tf).
2. Через провайдер отправляет запросы к API Cloud.ru.
3. API Gateway обрабатывает запросы и направляет их в соответствующие сервисы.
4. Результаты операций возвращаются в Terraform.
5. Состояние ресурсов сохраняется в файле `terraform.tfstate`.

### Архитектурная (компонентная) схема взаимодействия Terraform с облаком Cloud.ru

```text
┌──────────────────────────────────────────────────────────┐        ┌──────────────────────────────────────────────────────────┐
│ Локальная среда (рабочая станция / CI)                   │        │ Cloud.ru                                                 │
│                                                          │        │                                                          │
│  ┌────────────┐      ┌──────────┐                        │        │  ┌────────────────────────────────────────────────────┐  │
│  │ Terraform  │ ───▶ │ provider │ ───────────────────────┼──────────▶│ AGW (API Gateway)                                  │  │
│  └────────────┘      └──────────┘                        │        │  │                                                    │  │
│        │                   │                             │        │  │  compute gateway         ───▶ compute backend      │  │
│        │                   ├── читает/применяет:         │        │  │  load balancer gateway   ───▶ load balancer backend│  │
│        │                   │     ┌───────────────────┐   │        │  │  dbaas gateway           ───▶ dbaas backend        │  │
│        │                   │     │ HCL файлы (IaC)   │   │        │  │  ...                                               │  │
│        │                   │     │ (манифесты)       │   │        │  └────────────────────────────────────────────────────┘  │
│        │                   │     └───────────────────┘   │        │                                                          │
│        │                   │                             │        │                                                          │
│        │                   └── читает/пишет:             │        │                                                          │
│        │                        ┌─────────────────────┐  │        │                                                          │
│        └───────────────────────▶│ state               │  │        │                                                          │
│                                 │ (terraform.tfstate) │  │        │                                                          │
│                                 └─────────────────────┘  │        │                                                          │
└──────────────────────────────────────────────────────────┘        └──────────────────────────────────────────────────────────┘
```

Terraform запускается локально или на удаленной машине, например внутри CI/CD пайплайна. 
Terraform читает HCL-манифесты и через провайдер формирует запросы на создание/изменение ресурсов.

Provider — это терраформ-провайдер Cloud.ru, который доступен для скачивания из официального [GitHub-репозитория](https://github.com/cloud-ru/evo-terraform). 

Provider реализует обращения к API облака и ведет состояние (файл `terraform.tfstate`), чтобы помнить текущее/желаемое состояние ресурсов.

В Cloud.ru провайдер направляет все запросы через API Gateway. Далее запросы маршрутизируются в бэкенд соответствующего продукта (например, `compute gateway`, `load balancer gateway`, `dbaas gateway`) и соответствующие backend-сервисы.

## Частые проблемы и их решения

Ниже приведены наиболее часто встречающиеся ошибки, а так же способы их решения.

### 1. Проблемы при инициализации (terraform init)

#### Ошибка: "does not offer a Terraform provider registry"

**Пример ошибки**

```
Error: Invalid provider registry host
The host "registry.terraform.io" given in provider source address "registry.terraform.io/hashicorp/cloudrru" does not offer a Terraform provider registry.
```

**Решение**

Проверьте правильность имени провайдера в файле конфигурации. Корректно — `cloudru`:

```none
terraform {
  required_providers {
    cloudru = {
      source = "cloudru/cloud"
      version = ">= 1.0.0"
    }
  }
}

provider "cloudru" {
  project_id = var.project_id
}
```

#### Ошибка: "Failed to query available provider packages"

**Пример ошибки**

```
Error: Failed to query available provider packages
Could not retrieve the list of available versions for provider cloudru/cloud:
could not connect to registry.terraform.io: dial tcp: i/o timeout
```

**Решение**

1. Проверьте подключение к интернету.
2. Убедитесь, что корпоративный файрвол не блокирует доступ к `registry.terraform.io`.
3. При использовании прокси настройте переменные окружения:

   ```bash
   export HTTP_PROXY=http://proxy.company.com:3128
   export HTTPS_PROXY=http://proxy.company.com:3128
   export NO_PROXY=localhost,127.0.0.1
   ```

#### Ошибка: "no available releases match the given constraints"

**Решение**

Обновите зависимости провайдера:

```bash
terraform init -upgrade
```

### 2. Проблемы с конфигурацией ресурсов

#### Ошибка: "Missing required argument"

**Пример ошибки**

```
Error: Missing required argument
The argument "project_id" is required, but no definition was found.
```

**Решение**

Добавьте отсутствующий обязательный параметр в блок провайдера или определите его через переменные:

```none
provider "cloudru" {
  project_id = var.project_id  # Добавьте эту строку
}
```

#### Ошибка: "Unsupported argument"

**Пример ошибки**

```
Error: Unsupported argument
An argument named "project" is not expected here.
```

**Решение**

Проверьте правильность имен параметров в документации ресурса — возможно вы используете устаревшее имя параметра.

#### Ошибка: "Invalid for_each argument"

**Пример ошибки**

```
Error: Invalid for_each argument
The "for_each" argument must be a map, or set of strings, and you have provided a value of type list of string.
```

**Решение**

Преобразуйте список в множество или карту:

```none
# Вместо:
for_each = var.list_of_strings

# Используйте:
for_each = toset(var.list_of_strings)
# или
for_each = { for idx, val in var.list_of_strings : idx => val }
```

### 3. Проблемы с доступом к API

#### Ошибка: "received unexpected HTTP status 401 Unauthorized"

**Решение**

1. Проверьте актуальность API-ключа сервисного аккаунта.
2. Убедитесь, что сервисный аккаунт не был отключен.
3. Проверьте правильность указания учетных данных в конфигурации.

#### Ошибка: "received unexpected HTTP status 403 Forbidden"

**Решение**

1. Проверьте, что у сервисного аккаунта есть необходимые права в проекте.
2. Убедитесь, что проект существует и доступен.
3. Проверьте, что вы используете правильный ID проекта.

#### Ошибка: "received unexpected HTTP status 429 Too Many Requests"

**Решение**

1. Уменьшите количество параллельных запросов.
2. Добавьте паузы между операциями.
3. Используйте параметр `-parallelism` для ограничения параллелизма:

   ```bash
   terraform apply -parallelism=2
   ```

### 4. Сетевые проблемы

#### Ошибка: "dial tcp: i/o timeout"

**Решение**
1. Проверьте доступность API Cloud.ru:

   ```bash
   curl -v https://compute.api.cloud.ru/
   ```
2. Убедитесь, что файрвол разрешает исходящие соединения на порт 443.
3. Проверьте настройки DNS.

#### Ошибка: "x509: certificate signed by unknown authority"

**Решение**

1. Если используется корпоративный прокси с TLS-инспекцией, добавьте корпоративный сертификат в доверенные.
2. Отключите TLS-инспекцию для доменов *.cloud.ru

#### Ошибка: "connection refused"

**Решение**

1. Проверьте настройки прокси.
2. Убедитесь, что порт 443 не заблокирован.
3. Попробуйте выполнить команду с другого сетевого окружения.

### 5. Проблемы с состоянием (state)

#### Ошибка расхождения состояния с реальностью

**Решение**

1. Проверьте текущее состояние:

   ```bash
   terraform show
   ```

2. Обновите состояние:

   ```bash
   terraform refresh
   ```

3. При необходимости импортируйте существующие ресурсы:

   ```bash
   terraform import cloudru_evolution_compute.example <resource_id>
   ```

## Полезные команды для диагностики

### Проверка конфигурации
```bash
terraform validate  # Проверка синтаксиса
terraform fmt      # Форматирование файлов
terraform plan     # Просмотр плана изменений
```

### Работа с состоянием
```bash
terraform state list          # Список управляемых ресурсов
terraform state show <name>   # Детальная информация о ресурсе
terraform show                # Полное состояние
```

### Диагностика версий
```bash
terraform version    # Версия Terraform и провайдеров
terraform providers  # Дерево провайдеров
```

### Включение отладки
```bash
export TF_LOG=debug
terraform plan
```

## Рекомендации по предотвращению проблем

1. Всегда проверяйте конфигурацию перед применением:

   ```bash
   terraform validate && terraform plan
   ```

2. Используйте системы контроля версий для отслеживания изменений.

3. Храните состояние в надежном месте (GitLab, S3 с блокировкой).

4. Регулярно обновляйте провайдер до последней стабильной версии.

5. Используйте переменные для конфиденциальных данных:

   ```none
   variable "api_key" {
     type = string
     sensitive = true
   }
   ```

6. Создавайте ресурсы поэтапно, особенно при сложной инфраструктуре.

## Дополнительная информация

- [Документация Terraform Provider для Cloud.ru](https://cloud.ru/docs/terraform-evolution/ug/index?source-platform=Evolution)
- [Примеры ресурсов и датасорсов](https://cloud.ru/docs/terraform-evolution/ug/topics/reference?source-platform=Evolution)
- [Репозиторий провайдера на GitHub](https://github.com/cloud-ru/evo-terraform)

Если проблема не решается с помощью этого руководства, обратитесь [в техническую поддержку Cloud.ru](https://cloud.ru/docs/overview/support/index), предоставив:
- Полный текст ошибки.
- Версию Terraform и провайдера.
- Минимальный пример конфигурации, воспроизводящий проблему.
- Результат выполнения команд с включенным режимом отладки (`TF_LOG=debug`).