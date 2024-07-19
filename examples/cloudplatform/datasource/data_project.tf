# Список проектов в департаменте
data "cloudru_project" "projects" {
  filter = {
    # ID департамента
    organization_unit_id = data.cloudru_organization_unit.org-units[0].id
  }
}