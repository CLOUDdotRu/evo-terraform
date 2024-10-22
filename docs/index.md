# Cloud.ru Evolution Terraform Provider 0.2.2 (preview)
Terraform позволяет быстро разворачивать и поддерживать инфраструктуру в облаке Cloud.ru Evolution с помощью конфигурационных файлов. Вы описываете в коде виртуальные машины, подсети, группы безопасности и другие облачные ресурсы в виде объектов с параметрами, а Terraform исполняет этот код и создает объекты инфраструктуры или обновляет их, если конфигурация изменилась. Такой подход ускоряет подготовку инфраструктуры и минимизирует ошибки, связанные с человеческим фактором.

Конфигурационные файлы пишутся на языке HCL, который поддерживает переменные, условия, циклы, функции и другие конструкции. Это позволяет использовать один конфигурационный файл для разных сред. Например, для тестовой и промышленной среды можно задавать разное количество воркеров Kubernetes® или виртуальных машин для фронтенда приложения.

Terraform полезен инженерам и администраторам, которые хотят упростить и автоматизировать управление большим количеством облачных ресурсов.

## Установка terraform

☝🏻Перед началом работы, убедитель что у Вас установлен terraform: [terraform](https://developer.hashicorp.com/terraform/install){target=_blank} 

## Установка провайдера

В рамках beta-тестирования, установка Terraform-провайдера Cloud.ru Evolution производится через File system mirror. В зависимости от архитектуры и ОС вашего компьютера, выберите нужный вариант.

### Mac(Apple)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/darwin_arm64/terraform-provider-cloud_1.0.0_darwin_arm64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.0.0/terraform-provider-cloud_1.0.0_darwin_arm64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/darwin_arm64/terraform-provider-cloud_1.0.0_darwin_arm64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Mac(Intel)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \  
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/darwin_amd64/terraform-provider-cloud_1.0.0_darwin_amd64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.0.0/terraform-provider-cloud_1.0.0_darwin_amd64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/darwin_amd64/terraform-provider-cloud_1.0.0_darwin_amd64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Linux(x64)

Для скачивания текущей версии провайдера, выполните следующую команду:

``` bash
cd \
  && curl -L --create-dirs -o .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/linux_amd64/terraform-provider-cloud_1.0.0_linux_amd64 \
  https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.0.0/terraform-provider-cloud_1.0.0_linux_amd64 \
  && chmod +x .terraform.d/plugins/cloud.ru/cloudru/cloud/1.0.0/linux_amd64/terraform-provider-cloud_1.0.0_linux_amd64
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```

### Windows 10/11(x64)

``` bash
curl -L -o terraform-provider-cloud_1.0.0_windows_amd64 https://github.com/CLOUDdotRu/evo-terraform/releases/download/1.0.0/terraform-provider-cloud_1.0.0_windows_amd64
mkdir -p %APPDATA%\terraform.d\plugins\cloud.ru\cloudru\cloud\1.0.0\windows_amd64
move terraform-provider-cloud_1.0.0_windows_amd64 %APPDATA%\terraform.d\plugins\cloud.ru\cloudru\cloud\1.0.0\windows_amd64\
```

Далее, перейдите в каталог с вашими .tf файлами и выполните команду:

``` bash
terraform init
```


☝🏻Исполняемые файлы провайдера доступны здесь: [evo-terraform](https://github.com/CLOUDdotRu/evo-terraform/releases){target=_blank} 


## Настройка провайдера

Перед началом работы с провайдером, необхдодимо получить следующие данные:

- auth_key_id
- auth_secret
- project_id

Первые два пункта можно вязть здесь: [keys](https://cloud.ru/ru/docs/console_api/ug/topics/guides__service_accounts_key.html#guides-service-accounts-key-create)

project_id можно скопировать из адрессной строки своего проекта на портале console.cloud.ru

Далее, необходимо записать эти значения в файле main.tf и расположить его в том же каталоге, что и другие .tf файлы.

--- адреса энедпоинтов и структура ресурсов и провайдеров будут изменены позже в любое время

## Работа с IAM
С помощью Terraform можно добавлять новых пользователей и управлять их ролями. 

Управлять пользователями отдельного проекта или всего облака могут пользователи с соответствующими административными ролями.
Чтобы узнать подробнее о доступных действиях для каждой роли изучите статью [Роли](https://cloud.ru/ru/docs/administration/ug/topics/concepts__roles.html){target=_blank} 

Файлы примеров для работы с IAM расположены в каталоге: [IAM Examples](https://github.com/CLOUDdotRu/evo-terraform/tree/main/examples/iam)

## Работа с CloudPlatform
С помощью Terraform возможно создание и управление проектами. Проекты позволяют распределять облачные ресурсы между проектными задачами и командами. В каждом проекте можно подключать только нужные платформы и сервисы.

Файлы примеров для работы с CloudPlatform расположены в каталоге: [CloudPlatform Examples](https://github.com/CLOUDdotRu/evo-terraform/tree/main/examples/cloudplatform)

## Работа с Compute
При работе с сервисом Compute  через Terraform можно создавать и управлять виртуальными машинами различной конфигурации. Виртуальные машины — виртуальные серверы, развернутые на вычислительных ресурсах платформы виртуализации Evolution.

Файлы примеров для работы с Compute расположены в каталоге: [Compute Examples](https://github.com/CLOUDdotRu/evo-terraform/tree/main/examples/compute)

## Работа с Managed Kubernetes

Managed Kubernetes — сервис управления кластерами Kubernetes на вычислительных ресурсах облачной архитектуры Cloud.ru.
Сервис позволяет автоматизировать настройку и сопровождение контейнерной инфраструктуры, упростить развертывание приложений и обеспечить гибкое масштабирование. Можно быстро создать кластер и управлять им без ограничений с помощью Terraform.

Файлы примеров для работы с K8s расположены в каталоге: [K8s Examples](https://github.com/CLOUDdotRu/evo-terraform/tree/main/examples/k8s)


