resource "cloudru_evolution_compute" "test_compute" {
  # NOTE: Это вычисляемый параметр
  # id = "00000000-0000-0000-0000-000000000000"

  # NOTE: Это обязательный параметр
  name = "test_compute_2"

  # NOTE: Это опциональный параметр
  description = "1234"

  # NOTE: Это опциональный параметр
  # tags {
    #     NOTE: Это обязательный параметр
    # id = "00000000-0000-0000-0000-000000000000"

    #     NOTE: Это вычисляемый параметр
    #     name = "test_tag"
    #
    #     NOTE: Это вычисляемый параметр
    #     color = "test_color"
  # }

  # NOTE: Это обязательный параметр
  flavor_id = local.demo_flavor.id

  # NOTE: Это вычисляемый параметр
  # state = "created"

  # NOTE: Это вычисляемый параметр
  # locked = false

  # NOTE: Это обязательный параметр
  image {
    # NOTE: Это обязательный параметр
    name = "ubuntu-22.04"

    # NOTE: Это обязательный параметр
    host_name = "test-host"

    # NOTE: Это обязательный параметр
    user_name = "test-user"

    # NOTE: Это обязательный параметр.
    public_key = "ssh-rsa ..."

    # NOTE: Это вычисляемый параметр.
    # password = ""
  }

  # NOTE: Это вычисляемый параметр
  # created_time  = "2023-10-26T10:27:04Z"

  # NOTE: Это вычисляемый параметр
  # modified_time = "2023-10-26T10:28:21Z"

  # NOTE: Это обязательный параметр
  boot_disk {
    # NOTE: Это вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это обязательный параметр
    name = "test_disk_2"

    # NOTE: Это обязательный параметр
    size = 16

    # NOTE: Это вычисляемый параметр
    # state         = "in_use"

    # NOTE: Это вычисляемый параметр
    # tags {
    # NOTE: Это вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это вычисляемый параметр
    # name = "test_tag"

    # NOTE: Это вычисляемый параметр
    # color = "test_color"
    # }

    # NOTE: Это обязательный параметр
    disk_type {
      # NOTE: Это обязательный параметр
      id = local.demo_disk_type.id

      # NOTE: Это вычисляемый параметр
      # name = "SDS"
    }
  }

  # NOTE: Это обязательный параметр
  network_interfaces {
    # NOTE: Это обязательный параметр
    subnet {
      # NOTE: Это вычисляемый параметр
      # id = "00000000-0000-0000-0000-000000000000"

      # NOTE: Это обязательный параметр
      name = "Default"

      # NOTE: Это вычисляемый параметр
      # subnet_address = "10.1.2.0/24"

      # NOTE: Это вычисляемый параметр
      # routed_network = false

      # NOTE: Это вычисляемый параметр
      # state = "created"
    }

    # NOTE: Это обязательный параметр
    security_groups {
      # NOTE: Это обязательный параметр
      id = local.demo_security_group.id

      # NOTE: Это вычисляемый параметр
      # name = "sg-816839"

      # NOTE: Это вычисляемый параметр
      # state = "created"
    }

    # NOTE: Это вычисляемый параметр
    # interface_security_enabled = true

    # NOTE: Это опциональный параметр
    fip {
      # NOTE: Это обязательный параметр
      id = local.demo_fip.id

      # NOTE: Это вычисляемый параметр
      # ip_address = "10.0.0.5"

      # NOTE: Это вычисляемый параметр
      # name = "ni-816839"

      # NOTE: Это вычисляемый параметр
      # state = "created"
    }

    # NOTE: Это опциональный параметр
    # ip_address = "10.1.2.132"

    # NOTE: Это вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это опциональный параметр
    # name = "ni-816839"

    # NOTE: Это опциональный параметр
    # description = "ni-816839-description"

    # NOTE: Это вычисляемый параметр
    # type = "regular"

    # NOTE: Это вычисляемый параметр
    # state = "created"

    # NOTE: Это вычисляемый параметр
    # primary = true

    # NOTE: Это опциональный параметр
    # allowed_address_pairs {
    # NOTE: Это обязательный параметр
    # ip_address = ""

    # NOTE: Это обязательный параметр
    # mac_address = ""
    # }

    # NOTE: Это вычисляемый параметр
    # created_time  = "2023-10-26T10:27:04Z"

    # NOTE: Это вычисляемый параметр
    # modified_time = "2023-10-26T10:28:21Z"
  }

  # NOTE: Это обязательный параметр
  project {
    # NOTE: Это опциональный параметр, по умолчанию используется project_id указанный в секции provider
    id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это вычисляемый параметр
    # product_instance_id = "00000000-0000-0000-0000-000000000000"
  }

  # NOTE: Это обязательный параметр
  availability_zone {
    # NOTE: Это  вычисляемый параметр
    # id = "00000000-0000-0000-0000-000000000000"

    # NOTE: Это обязательный параметр
    name = "pd37"
  }

  # NOTE: Это вычисляемый параметр
  # vnc_url = ""

  # NOTE: Это вычисляемый параметр
  # vnc_ws = ""
}
