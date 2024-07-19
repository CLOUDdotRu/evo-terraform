data "cloudru_evolution_flavor" "flavors" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр
    # availability_zone_id = local.demo_az.id

    # NOTE: Это опциональный параметр
    # name = "default"

    # NOTE: Это опциональный параметр
    # cpu = 1

    # NOTE: Это опциональный параметр
    # ram = 8

    # NOTE: Это опциональный параметр
    # type = ""

    # NOTE: Это опциональный параметр
    # oversubscription = ""
  }
}

locals {
  demo_flavors = [
    for s in data.cloudru_evolution_flavor.flavors.resources : s if s.name == "low-1-1"
  ]
  demo_flavor = local.demo_flavors.0
}
