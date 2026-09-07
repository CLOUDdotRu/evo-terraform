# Развертывание виртуальной машины через Terraform

Инструкция описывает, как создать виртуальную машину в облаке Cloud.ru Evolution и все зависимые ресурсы.

## Требования
[Установите Terraform и настройте провайдер](https://cloud.ru/docs/terraform-evolution/ug/topics/quickstart?source-platform=Evolution), если он еще не установлен.

Создайте рабочую папку для проекта и проинициализируйте провайдер командой `terraform init`.

## Структура файлов

Для развертывания виртуальной машины в рабочей папке должны находиться следующие файлы:

| Файл | Описание |
|------|----------|
| `vm.tf` | Основная конфигурация Terraform — содержит все ресурсы, переменные и провайдер. Единственный обязательный файл для запуска `terraform apply`. |
| `cloud-init.yaml.tpl` | Шаблон cloud-init для первоначальной настройки ВМ (создание пользователя, SSH-ключи, hostname). Используется в `vm.tf` через функцию `templatefile`. |
| `inventory.sh` | Вспомогательный скрипт — генерирует `inventory.yaml` для Ansible на основе terraform output. Не участвует в развертывании, используется после создания ВМ. |

### cloud-init.yaml.tpl

Создайте в папке проекта файл `cloud-init.yaml.tpl` со следующим содержимым:

```none path=null start=null
#cloud-config
users:
  - name: ubuntu
    ssh-authorized-keys:
      - ${ssh_public_key}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    # Сгенерируйте пароль командой:
    # MacOS: openssl passwd -6 "YourPassword123!"
    # Linux: mkpasswd -m sha-512 "YourPassword123!"
    passwd: "<YOUR_PASSWORD>"
    lock_passwd: false
hostname: ${vm_name}
manage_etc_hosts: true
```

В поле `passwd` вставьте хеш пароля, сгенерированный одной из команд выше.

### inventory.sh

Создайте в папке проекта файл `inventory.sh` и сделайте его исполняемым (`chmod +x inventory.sh`):

```bash path=null start=null
#!/bin/bash

# Получаем значения из Terraform output
VM_INTERNAL_IP=$(terraform output -raw vm_internal_ip 2>/dev/null)
EXTERNAL_IP=$(terraform output -raw external_ip 2>/dev/null)

if [ -z "$VM_INTERNAL_IP" ] || [ -z "$EXTERNAL_IP" ]; then
    echo "Ошибка: не удалось получить IP адреса. Запустите terraform apply" >&2
    exit 1
fi

cat << EOF
all:
  hosts:
    evo-vm:
      ansible_host: ${EXTERNAL_IP}
      ansible_user: ubuntu
      ansible_python_interpreter: auto_silent
      ansible_ssh_private_key_file: ~/.ssh/id_rsa_agent
      ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
  children:
    cloudru_evolution:
      hosts:
        evo-vm:
          internal_ip: ${VM_INTERNAL_IP}
EOF
```

Скрипт запускается после успешного `terraform apply` и генерирует файл inventory для Ansible.

## Конфигурация ВМ и зависимых ресурсов

Создайте файл `vm.tf` и скопируйте в него код, приведенный ниже. Вставьте свои значения в переменных.

```none path=null start=null
# =============================================================================
# vm.tf — полная конфигурация terraform для создания ВМ
# со всеми зависимыми ресурсами на платформе Cloud.ru Evolution
# =============================================================================
# Используемый провайдер
# source и version обязательно должны соответствовать тому провайдеру,
# который используется
# =============================================================================

terraform {
  required_providers {
    cloudru = {
      source  = "cloudru/cloud"
      version = "2.1.2"
    }
  }
}

# =============================================================================
# Переменные — заполните своими значениями
# =============================================================================

variable "project_id" {
  type        = string
  description = "Идентификатор проекта из console.cloud.ru"
  default     = "" # <-- ВСТАВЬТЕ ВАШ PROJECT ID
}

variable "auth_key_id" {
  type        = string
  description = "Идентификатор ключа доступа сервисного аккаунта"
  sensitive   = true
  default     = "" # <-- ВСТАВЬТЕ ВАШ AUTH KEY ID
}

variable "auth_secret" {
  type        = string
  description = "Секрет ключа доступа сервисного аккаунта"
  sensitive   = true
  default     = "" # <-- ВСТАВЬТЕ ВАШ AUTH SECRET
}

variable "vpc_id" {
  type        = string
  description = "Идентификатор VPC"
  default     = "" # <-- ВСТАВЬТЕ ВАШ VPC ID
}

variable "my_ip_cidr" {
  type        = string
  description = "CIDR вашего IP-адреса для доступа по SSH (например 1.2.3.4/32)"
  default     = "0.0.0.0/32" # <-- ВСТАВЬТЕ ВАШ IP В ФОРМАТЕ CIDR
}

variable "subnet_address" {
  type        = string
  description = "CIDR подсети"
  default     = "10.0.0.0/24" # <-- ИЗМЕНИТЕ ПРИ НЕОБХОДИМОСТИ
}

variable "vm_name" {
  type        = string
  description = "Имя виртуальной машины"
  default     = "tf-evo-vm"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Путь к публичному SSH ключу"
  default     = "~/.ssh/id_rsa.pub"
}

variable "disk_size" {
  type        = number
  description = "Размер диска в ГБ"
  default     = 20
}

variable "disk_type" {
  type        = string
  description = "Тип диска"
  default     = "SSD"
}

variable "flavor" {
  type        = string
  description = "Flavor ВМ"
  default     = "gen-1-1"
}

variable "zone" {
  type        = string
  description = "Зона доступности"
  default     = "ru.AZ-1"
}

# =============================================================================
# Провайдер
# =============================================================================

provider "cloudru" {
  project_id  = var.project_id
  auth_key_id = var.auth_key_id
  auth_secret = var.auth_secret

  endpoints = {
    iam_endpoint     = "iam.api.cloud.ru:443"
    compute_endpoint = "compute.api.cloud.ru:443"
  }
}

# =============================================================================
# Источники данных
# =============================================================================

data "cloudru_evolution_compute_image_collection" "ubuntu" {
  project_id = var.project_id
  page_size  = 100
}

# =============================================================================
# Конфигурация cloud-init
# =============================================================================

locals {
  cloud_config = templatefile("${path.module}/cloud-init.yaml.tpl", {
    ssh_public_key = file(var.ssh_public_key_path)
    vm_name        = var.vm_name
  })
}

# =============================================================================
# Подсеть
# =============================================================================

resource "cloudru_evolution_compute_subnet" "example" {
  project_id = var.project_id

  name = "tf-evo-subnet"

  zone_identifier = {
    name = var.zone
  }

  description    = "Подсеть для ВМ"
  subnet_address = var.subnet_address
  routed_network = true
  default        = false
  vpc_id         = var.vpc_id

  dns_servers = {
    value = ["8.8.4.4", "8.8.8.8"]
  }
}

# =============================================================================
# Группа безопасности
# =============================================================================

resource "cloudru_evolution_compute_security_group" "example" {
  project_id = var.project_id

  name = "tf-evo-sg"

  zone_identifier = {
    name = var.zone
  }

  description = "Группа безопасности для ВМ"
}

# =============================================================================
# Правила группы безопасности
# =============================================================================

# SSH (22) — доступ только с вашего IP
resource "cloudru_evolution_compute_security_group_rule" "ingress_ssh" {
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "22:22"
  description       = "SSH доступ с моего IP"
  remote_ip_prefix  = var.my_ip_cidr
}

# HTTPS (443) — доступ отовсюду
resource "cloudru_evolution_compute_security_group_rule" "ingress_https" {
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "443:443"
  description       = "HTTPS доступ отовсюду"
  remote_ip_prefix  = "0.0.0.0/0"
}

# Исходящий TCP
resource "cloudru_evolution_compute_security_group_rule" "egress_tcp" {
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_EGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "1:65535"
  description       = "Разрешить весь исходящий TCP"
  remote_ip_prefix  = "0.0.0.0/0"
}

# Исходящий UDP
resource "cloudru_evolution_compute_security_group_rule" "egress_udp" {
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_EGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_UDP"
  port_range        = "1:65535"
  description       = "Разрешить весь исходящий UDP"
  remote_ip_prefix  = "0.0.0.0/0"
}

# =============================================================================
# Диск
# =============================================================================

resource "cloudru_evolution_compute_disk" "example" {
  project_id = var.project_id

  name = "tf-evo-disk"
  size = var.disk_size

  zone_identifier = {
    name = var.zone
  }

  disk_type_identifier = {
    name = var.disk_type
  }

  description = "Загрузочный диск для ВМ"
  bootable    = true
  image_id    = [for img in data.cloudru_evolution_compute_image_collection.ubuntu.images : img.id if img.name == "ubuntu-22.04"][0]
  encrypted   = false
  readonly    = false
  shared      = false
}

# =============================================================================
# Сетевой интерфейс
# =============================================================================

resource "cloudru_evolution_compute_interface" "example" {
  project_id = var.project_id

  name = "tf-evo-interface"

  zone_identifier = {
    name = var.zone
  }

  description                = "Сетевой интерфейс для ВМ"
  subnet_id                  = cloudru_evolution_compute_subnet.example.id
  interface_security_enabled = true

  security_groups_identifiers = {
    value = [{
      id = cloudru_evolution_compute_security_group.example.id
    }]
  }

  external_ip_specs = {
    new_external_ip = true
  }

  type = "INTERFACE_TYPE_REGULAR"
}

# =============================================================================
# Виртуальная машина
# =============================================================================

resource "cloudru_evolution_compute_vm" "example" {
  project_id = var.project_id

  name = var.vm_name

  zone_identifier = {
    name = var.zone
  }

  flavor_identifier = {
    name = var.flavor
  }

  description = "ВМ, созданная через Terraform"

  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.example.id
  }]

  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.example.id
  }]

  cloud_init_userdata = base64encode(local.cloud_config)
}

# =============================================================================
# Вывод значений
# =============================================================================

output "vm_id" {
  description = "ID виртуальной машины"
  value       = cloudru_evolution_compute_vm.example.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = cloudru_evolution_compute_vm.example.name
}

output "vm_internal_ip" {
  description = "Внутренний IP адрес"
  value       = cloudru_evolution_compute_interface.example.ip_address
}

output "external_ip" {
  description = "Внешний IP адрес"
  value       = cloudru_evolution_compute_interface.example.external_ip.ip_address
}
```

## Описание переменных

Перед запуском заполните переменные в блоке `variables` файла `vm.tf`.

### Обязательные переменные

| Переменная | Описание | Где получить |
|------------|----------|--------------|
| `project_id` | Идентификатор проекта | Консоль Cloud.ru — страница проекта |
| `auth_key_id` | Идентификатор ключа доступа сервисного аккаунта | Консоль Cloud.ru — раздел сервисных аккаунтов |
| `auth_secret` | Секрет ключа доступа сервисного аккаунта | Выдается при создании ключа доступа |
| `vpc_id` | Идентификатор VPC | Консоль Cloud.ru — раздел сетей |
| `my_ip_cidr` | CIDR вашего IP-адреса для SSH-доступа | Ваш внешний IP в формате `x.x.x.x/32` |

### Необязательные переменные

| Переменная | По умолчанию | Описание |
|------------|-------------|----------|
| `subnet_address` | `10.0.0.0/24` | CIDR создаваемой подсети |
| `vm_name` | `tf-evo-vm` | Имя виртуальной машины |
| `ssh_public_key_path` | `\~/.ssh/id_rsa.pub` | Путь к публичному SSH-ключу |
| `disk_size` | `20` | Размер загрузочного диска в ГБ |
| `disk_type` | `SSD` | Тип диска |
| `flavor` | `gen-1-1` | Флейвор (конфигурация) ВМ |
| `zone` | `ru.AZ-1` | Зона доступности |

## Развертывание

1. Инициализируйте Terraform и запустите создание ресурсов:

```bash path=null start=null
terraform init && terraform apply
```

2. Проверьте план создания ресурсов и подтвердите, введя `yes`.

3. После успешного завершения Terraform выведет IP-адреса созданной ВМ:

```bash path=null start=null
Outputs:

vm_id          = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
vm_name        = "tf-evo-vm"
vm_internal_ip = "10.0.0.x"
external_ip    = "x.x.x.x"
```

## Подключение к ВМ

После создания ВМ подключитесь к ней по SSH:

```bash path=null start=null
ssh ubuntu@<external_ip>
```

Где `<external_ip>` — внешний IP-адрес из вывода Terraform.

## Генерация inventory для Ansible

Если вы планируете использовать Ansible для дальнейшей настройки ВМ, сгенерируйте inventory-файл:

```bash path=null start=null
./inventory.sh > inventory.yaml
```

## Удаление ресурсов

Для удаления всех созданных ресурсов выполните:

```bash path=null start=null
terraform destroy
```

Проверьте список ресурсов, которые будут удалены, и подтвердите, введя `yes`.
