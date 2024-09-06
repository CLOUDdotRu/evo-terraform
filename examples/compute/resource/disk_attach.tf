resource "cloudru_evolution_compute" "test_compute" {
  // .. описание ресурса
}

resource "cloudru_evolution_disk" "test_disk" {
  // .. описание ресурса
}

resource "cloudru_evolution_disk_attachment" "compute_to_disk" {
  compute_id = cloudru_evolution_compute.test_compute.id
  disk_id    = cloudru_evolution_disk.test_disk.id
}
