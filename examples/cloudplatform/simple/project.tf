# Создание департамента
resource "cloudru_organization_unit" "meat-department" {
  # Название департамента
  # Обязательный параметр
  name = "Мясной департамент"

  # Описание департамента
  # Не обязательный параметр
  description = "Департамент"
}

# Создание проекта
resource "cloudru_project" "soy_meat" {
  # Название проекта
  # Обязательный параметр
  name = "Проект соевого мясо"

  # Описание проекта
  # Не обязательный параметр
  description = "Проект"

  # ID департамента
  # Обязательный параметр
  organization_unit_id = cloudru_organization_unit.meat-department.id
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
