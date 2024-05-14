terraform {
  required_providers {
    cloudru = {
      source  = "cloud.ru/cloudru/cloud"
      version = "0.1.0"
    }
  }
}

provider "cloudru" {
  # NOTE: Это опциональный параметр
  project_id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это опциональный параметр
  # customer_id             = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  auth_endpoint = "https://auth.iam.sbercloud.ru"

  # NOTE: Это обязательный параметр
  auth_key_id         = "********************************"

  # NOTE: Это обязательный параметр
  auth_secret         = "********************************"

  # NOTE: Это опциональный параметр, требуется для работы с IAM
  iam_endpoint = "api.iam.sbercloud.ru:443"

  # NOTE: Это опциональный параметр, требуется для работы с K8S
  k8s_endpoint = "mk8s.api.cloud.ru:443"

  # NOTE: Это опциональный параметр, требуется для работы с Evolution
  evolution_endpoint = "https://console.cloud.ru/api/svp/svc"

  # NOTE: Это опциональный параметр, требуется для работы с CloudPlatform
  cloudplatform_endpoint = "https://organization.api.cloud.ru"
}
