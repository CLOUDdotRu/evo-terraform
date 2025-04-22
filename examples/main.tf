terraform {
  required_providers {
    cloudru = {
      source  = "cloud.ru/cloudru/cloud"
      version = "1.3.2"
    }
  }
}

provider "cloudru" {
  # NOTE: Это опциональный параметр
  project_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр при использованиии CloudPlatform
  # customer_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  auth_key_id         = "********************************"

  # NOTE: Это обязательный параметр
  auth_secret         = "********************************"

  # NOTE: Это опциональный параметр, требуется для работы с IAM (в следующей версии станет обязательным)
  iam_endpoint = "iam.api.cloud.ru:443"

  # NOTE: Это опциональный параметр, требуется для работы с K8S
  k8s_endpoint = "mk8s.api.cloud.ru:443"

  # NOTE: Это опциональный параметр, требуется для работы с Evolution
  evolution_endpoint = "https://compute.api.cloud.ru"

  # NOTE: Это опциональный параметр, требуется для работы с CloudPlatform
  cloudplatform_endpoint = "organization.api.cloud.ru:443"

  # NOTE: Это опциональный параметр, требуется для работы с DBaaS
  dbaas_endpoint = "dbaas.api.cloud.ru:443"



}
