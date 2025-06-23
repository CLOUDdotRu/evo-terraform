data "cloudru_mcm_vm" "vms" {
    # NOTE: Это опциональный параметр
    filter {
        # NOTE: Это опциональный параметр, по умолчанию используется project_id указанный в секции provider
        project_id = "00000000-0000-0000-0000-000000000000"
    }
}

output "vms_list" {
    value = data.cloudru_mcm_vm.vms.resources
}
