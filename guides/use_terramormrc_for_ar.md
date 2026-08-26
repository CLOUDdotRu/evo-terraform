## Использование провайдера из Artifact Registry

В данной инструкции описывается два варианта того, как можно получить и использовать файл провайдера из Artifact Registry

### Кейс 1

Существует возможность переопределить Terraform на **получение** провайдера из реестра. Для этого в домашней директории нужно **создать** файл `.terraformrc` (для macOS и Linux)
- *Примечание*: если вы используете ОС Windows, то файл должен именоваться `terraform.rc` и находиться в `%APPDATA%`

В созданном файле нужно создать блок `provider_installation`, который отвечает за то, **откуда** Terraform будет "брать" провайдер. Использование блока `network_mirror` позволяет указать URL, а также маски, по которым Terraform будет искать провайдер

*Пример*:

```
provider_installation {
  network_mirror {
    url = "https://evo-tf-provider-generic.ar.cloud.ru/"
    include = ["cloudru/*"]
  }
  direct {
    exclude = ["cloudru/*"]
  }
}
```
, где:
- **url** - базовый URL до реестра (слэш в конце URL **обязателен**)
- **include** - список масок, по которому происходит поиск провайдера (*примечание:* зеркало используется **ТОЛЬКО** для провайдеров организации cloud.ru)
- **direct** - блок, который используется для остальных провайдеров, в случае если по указанному URL провайдер не был найден
- **exclude** - параметр, который исключает провайдеры по маскам

> **ВАЖНО!** Если вы используете механизм `network_mirror`, то в вашем `main.tf` нужно указать версию провайдера в блоке `required_providers`
> 
> *Пример:*
> ```
> terraform {
>   required_providers {
>     cloudru = {
>       source = "cloudru/cloud"
>       version = "2.1.2"
>     }
>   }
> }

После выполнения команды `terraform init` файл провайдера будет находится в директории вашего проекта

### Кейс 2

#### 1. Получение провайдера из AR

Также готовый бинарный файл нужной версии и для нужной ОС можно скачать из Artifact Registry на cloud.ru

Адрес реестра - [https://evo-tf-generic.ar.cloud.ru/](https://evo-tf-generic.ar.cloud.ru)

#### 2. Переопределение через terraformrc

После получения бинарного файла провайдера из Artifact Registry, в `.terraformrc` нужно создать блок `dev_overrides` в `provider_installation`. Этот блок позволяет отключить механизм скачивания провайдера и начать использовать тот провайдер, который указан в пути

*Пример*:
```
provider_installation {
  dev_overrides {
    "cloudru/cloud" = "/Users/testuser/.terraform.d/plugins/cloud.ru/cloudru/cloud/2.1.2/terraform-provider-cloud_2.1.2_darwin_arm64"
  }                                        
  direct {}
}
```
, где:
- **cloudru/cloud** - полное имя провайдера
- **/Users/testuser/...** - путь до файла провайдера
- **direct** - блок, который используется для остальных провайдеров