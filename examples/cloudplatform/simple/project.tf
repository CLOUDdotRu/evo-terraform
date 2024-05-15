# Создание департамента
resource "cloudru_organization_unit" "test-department" {
  # Название департамента
  # Обязательный параметр
  name = "Тестовый департамент"

  # Описание департамента
  # Не обязательный параметр
  description = "Тестовый департамент"
}

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

# Список департаментов у клиента
data "cloudru_organization_unit" "org-units" {}

# Список проектов в департаменте
data "cloudru_project" "projects" {
  filter = {
    # ID департамента
    organization_unit_id = data.cloudru_organization_unit.org-units[0].id
  }
}
