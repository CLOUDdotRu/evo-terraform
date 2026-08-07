# Оглавление

- [Cloud.ru Evolution Terraform Provider 1.7.1](#cloudru-evolution-terraform-provider-130)
- [Установка terraform](#установка-terraform)
- [Установка провайдера](#установка-провайдера)
  - [Mac(Apple)](#macapple)
  - [Mac(Intel)](#macintel)
  - [Linux(x64)](#linuxx64)
  - [Windows 10/11(x64)](#windows-1011x64)
- [Настройка провайдера](#настройка-провайдера)
- [Поддерживаемые провайдером ресурсы](#поддерживаемые-провайдером-ресурсы)
- [Обратная связь](#обратная-связь)
  
# Cloud.ru Evolution Terraform Provider 1.7.1
Terraform позволяет быстро разворачивать и поддерживать инфраструктуру в облаке Cloud.ru Evolution с помощью конфигурационных файлов. Вы описываете в конфигурационных файлах виртуальные машины, подсети, группы безопасности и другие облачные ресурсы в виде объектов с параметрами, а Terraform на основе конфигурационных файлов создает объекты инфраструктуры или обновляет их, если конфигурация изменилась. Такой подход ускоряет подготовку инфраструктуры и минимизирует ошибки, связанные с человеческим фактором.

Конфигурационные файлы пишутся на языке HCL, который поддерживает переменные, условия, циклы, функции и другие конструкции. Это позволяет использовать один конфигурационный файл для разных сред. Например, для тестовой и промышленной среды можно задавать разное количество воркеров Kubernetes® или виртуальных машин для фронтенда приложения.

Terraform полезен инженерам и администраторам, которые хотят упростить и автоматизировать управление облачной инфраструктурой.

## Установка terraform

☝🏻Перед началом работы, убедитель что у Вас установлен terraform: [terraform](https://developer.hashicorp.com/terraform/install)

## Установка провайдера

В рамках beta-тестирования, установка Terraform-провайдера Cloud.ru Evolution производится через File system mirror. В зависимости от архитектуры и ОС вашего компьютера, выберите нужный вариант.

### Mac(Apple)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/darwin_arm64/terraform-provider-cloud_1.7.1_darwin_arm64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.7.1/terraform-provider-cloud_1.7.1_darwin_arm64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/darwin_arm64/terraform-provider-cloud_1.7.1_darwin_arm64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Mac(Intel)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \  
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/darwin_amd64/terraform-provider-cloud_1.7.1_darwin_amd64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.7.1/terraform-provider-cloud_1.7.1_darwin_amd64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/darwin_amd64/terraform-provider-cloud_1.7.1_darwin_amd64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Linux(x64)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/linux_amd64/terraform-provider-cloud_1.7.1_linux_amd64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.7.1/terraform-provider-cloud_1.7.1_linux_amd64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.7.1/linux_amd64/terraform-provider-cloud_1.7.1_linux_amd64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Windows 10/11(x64)

``` bash
curl -L -o terraform-provider-cloud_1.7.1_windows_amd64 https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.7.1/terraform-provider-cloud_1.7.1_windows_amd64
mkdir -p %APPDATA%\terraform.d\plugins\cloud.ru\cloudru\cloud\1.7.1\windows_amd64
move terraform-provider-cloud_1.7.1_windows_amd64 %APPDATA%\terraform.d\plugins\cloud.ru\cloudru\cloud\1.7.1\windows_amd64\
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```


☝🏻Исполняемые файлы провайдера доступны здесь: [evo-terraform](https://github.com/CLOUDdotRu/evo-terraform/releases)


## Настройка провайдера

Перед началом работы с провайдером, необхдодимо получить следующие параметры:

- `auth_key_id`
- `auth_secret`
- `project_id`

Чтобы получить `auth_key_id и` `auth_secret`, необходимо сгенерировать ключ доступа по следующей [инструкции.](https://cloud.ru/ru/docs/console_api/ug/topics/guides__service_accounts_key.html#guides-service-accounts-key-create)

`project_id` можно скопировать из адресной строки своего проекта в веб-консоли console.cloud.ru

Далее, необходимо записать эти значения в файле main.tf в соответствующие поля, и расположить его в том же каталоге, что и другие .tf файлы.

**ВНИМАНИЕ:** адреса эндпоинтов и структура ресурсов могут быть изменены позже в любое время. Следите за обновлениями провайдера в разделе [релизов](https://github.com/CLOUDdotRu/evo-terraform/releases) 

## Поддерживаемые провайдером ресурсы
Продукты и сервисы платформы Evolution могут управляться:
* через веб-консоль console.cloud.ru
* REST API
* Terraform
  
Terraform провайдер для платформы Evolution активно разрабатывается, и на текущий момент поддерживает управление ограниченным количеством продуктов и сервисов платформы evolution.
В папке [examples](https://github.com/CLOUDdotRu/evo-terraform/tree/main/examples) находятся примеры .tf файлов для тех ресурсов, которые на текущий момент поддерживает terraform провайдер. Если вы не нашли примеров .tf файлов для нужного Вам продукта, Вы можете управлять им через веб-консоль или api.

## Обратная связь
Обратную связь по использованию terraform провайдера вы можете оставить в личном кабинете платформы cloud.ru Evolution. 
Для этого в правой верхней части консоли перейдите в раздел `Помощь и документация`, и затем нажмите кнопку `Есть предложения?`.

Ваш опыт использования terraform очень ценен, а отзывы и предложения помогают нам стать лучше!
