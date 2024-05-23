# Список всех пользователей организации
data "cloudru_iam_user" "customer-users" {
  filter = {
    # ID организации
    # Обязательный параметр
    customer_id = "customer_id"
  }
}

# Список локальных пользователей организации с фильтрацией по email
data "cloudru_iam_user" "customer-users" {
  filter = {
    # ID организации
    # Обязательный параметр
    customer_id = "customer_id"

    # Фильтрации по email
    # Не обязательный параметр
    email = "test-tf@yourdomain.com"

    # Тип аккаунта пользователя (local/federated)
    # Не обязательный параметр
    account_type = "local"
  }
}

# Список федеративных пользователей организации
data "cloudru_iam_user" "customer-users" {
  filter = {
    # ID организации
    # Обязательный параметр
    customer_id = "customer_id"

    # Фильтрации по email
    # Не обязательный параметр
    email = "test-tf@yourdomain.com"

    # Тип аккаунта пользователя (local/federated)
    # Не обязательный параметр
    account_type = "federated"
  }
}
