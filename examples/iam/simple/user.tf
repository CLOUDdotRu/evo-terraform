# Создание пользователя
resource "cloudru_iam_user" "project-admin" {
  # Email
  # Обязательный параметр
  email = "test-tf@yourdomain.com"
}

# Добавление разрешения
resource "cloudru_iam_permission" "p" {
  # Роль
  # Обязательный параметр
  role         = "platform.project.admin"

  # ID субъекта, которому выдается роль
  # Обязательный параметр
  subject_id   = cloudru_iam_user.project-admin.id

  # Тип субъекта, которому выдается роль (user/service_account)
  # Обязательный параметр
  subject_type = "user"

  # ID объекта, на который выдается роль
  # Обязательный параметр
  object_id    = "project id"

  # Тип объекта, на который выдается роль (customer/resource)
  # Обязательный параметр
  object_type  = "resource"
}

# Список пользователей на проекте
data "cloudru_iam_user" "project-users" {
  filter = {
    # ID проекта
    # Обязательный параметр
    project_id = "project_id"

    # Фильтрации по email
    # Не обязательный параметр
    email = "test-tf@yourdomain.com"
  }
}
