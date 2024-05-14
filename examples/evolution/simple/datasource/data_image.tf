data "cloudru_evolution_image" "images" {
  # NOTE: Это опциональный параметр
  filter {
    # NOTE: Это опциональный параметр
    availability_zone_id = local.demo_az.id

    # NOTE: Это опциональный параметр
    # name = "Ubuntu-22.04"
  }
}

locals {
  test_images = [
    for s in data.cloudru_evolution_image.images.resources : s if s.name == "Ubuntu-22.04"
  ]
  test_image = local.test_images.0
}
