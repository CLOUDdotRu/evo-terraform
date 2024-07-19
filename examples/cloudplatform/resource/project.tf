# Создание проекта
resource "cloudru_project" "test_project" {
  # Название проекта
  # Обязательный параметр
  name = "Тестовый проект"

  # Описание проекта
  # Не обязательный параметр
  description = "Тестовый проект"

  # ID департамента
  # Обязательный параметр
  organization_unit_id = cloudru_organization_unit.test-department.id
}
