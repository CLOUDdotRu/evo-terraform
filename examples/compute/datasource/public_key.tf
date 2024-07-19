data "cloudru_evolution_public_key" "public_keys" {}

locals {
  public_keys = [for s in data.cloudru_evolution_public_key.public_keys.resources : s if s.type == "SSH"]

  public_key = local.public_keys.0
}

output "public_keys" {
  value = local.public_key
}
