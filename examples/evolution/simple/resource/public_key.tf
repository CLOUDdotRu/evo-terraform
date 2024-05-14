resource "cloudru_evolution_public_key" "key1" {
  # NOTE: Это вычисляемый параметр
  # id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  name = "key1"

  # NOTE: Это опциональный параметр
  description = ""

  # NOTE: Это опциональный параметр, по умолчанию параметр устанавливается из мета данных провайдера
  project_id = ""

  # NOTE: Это вычисляемый параметр
  # type = ""

  # NOTE: Это вычисляемый параметр
  # fingerprint = ""

  # NOTE: Это обязательный параметр
  public_key = "abc..."

  # NOTE: Это опциональный параметр
  tags {
    # NOTE: Это обязательный параметр
    id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это вычисляемый параметр
    # name = "test_tag"

    # NOTE: Это вычисляемый параметр
    # color = "test_color"
  }
}