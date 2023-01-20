# -------------------------- MAIN/outputs.tf ---------------------------#

output "lb_dns_out_root" {
    value = module.loadbalancing.lb_dns
}


output "root_instances_info" {
    value = [for i in module.compute.instance_info : join(" --> ", [i.tags.Name], [join(":", [i.public_ip], [module.compute.instance_port])])]
    sensitive = true
}
