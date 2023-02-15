output  "ipaddress_and_ports_loop" {
 value = [for i in docker_container.nodered_container[*]: join(":",[i.ip_address], i.ports[*]["external"])]
 sensitive = true
}