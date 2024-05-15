resource "cloudru_evolution_security_group" "test_security_group" {
  # NOTE: Это вычисляемый параметр
  # id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  name = "test_security_group"

  # NOTE: Это опциональный параметр
  description = "123"

  # NOTE: Это опциональный параметр, по умолчанию используется project_id указанный в секции provider
  project {
    # NOTE: Это опциональный параметр
    id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это вычисляемый параметр
    # product_instance_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Это обязательный параметр
  availability_zone {
    # NOTE: Это обязательный параметр
    id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это вычисляемый параметр
    # name = "SSD"
  }

  # NOTE: Это вычисляемый параметр
  # default = false

  # NOTE: Это вычисляемый параметр
  # has_interfaces = false

  # NOTE: Это вычисляемый параметр
  # ingress_rules_count = 0

  # NOTE: Это вычисляемый параметр
  # egress_rules_count = 0

  # NOTE: Это вычисляемый параметр
  # state = "created"

  # NOTE: Это опциональный параметр
  tags {
    #     NOTE: Это обязательный параметр
    id = "00000000-0000-0000-0000-000000000000"

    #     NOTE: Это вычисляемый параметр
    #     name = "test_tag"
    #
    #     NOTE: Это вычисляемый параметр
    #     color = "test_color"
  }

  # NOTE: Это вычисляемый параметр
  # created_time  = "2023-10-26T10:27:04Z"

  # NOTE: Это вычисляемый параметр
  # modified_time = "2023-10-26T10:28:21Z"

  # NOTE: Это опциональный параметр
  rules {
    # NOTE: Это вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это обязательный параметр
    direction = "egress"

    # NOTE: Это обязательный параметр
    ether_type = "IPv6"

    # NOTE: Это обязательный параметр
    ip_protocol = "any"

    # NOTE: Это обязательный параметр
    port_range = "any"

    # NOTE: Это обязательный параметр
    remote_ip_prefix = "::/0"

    # NOTE: Это опциональный параметр
    # description = ""

    # NOTE: Это опциональный параметр
    # description = ""

    # NOTE: Это вычисляемый параметр
    # state = "created"
  }
  rules {
    # NOTE: Это вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это обязательный параметр
    direction = "ingress"

    # NOTE: Это обязательный параметр
    ether_type = "IPv4"

    # NOTE: Это обязательный параметр
    ip_protocol = "tcp"

    # NOTE: Это обязательный параметр
    port_range = "80:80"

    # NOTE: Это обязательный параметр
    remote_ip_prefix = "0.0.0.0/0"

    # NOTE: Это опциональный параметр
    description = "HTTP"

    # NOTE: Это опциональный параметр
    # description = ""

    # NOTE: Это вычисляемый параметр
    # state = "created"
  }
}
