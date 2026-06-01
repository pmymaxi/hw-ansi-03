# Config VM
vms_resources = {
  web = {
    name          = "netology-develop-platform-web"
    hostname      = "hw-02-web"
    family        = "rocky-9-oslogin"
    platform_id   = "standard-v3"
    zone          = "ru-central1-a"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    preemptible   = true
    subnet_id     = "subnet-ru-central1-a"
    nat           = true
  }

  db = {
    name          = "netology-develop-platform-db"
    hostname      = "hw-02-db"
    family        = "rocky-9-oslogin"
    platform_id   = "standard-v3"
    zone          = "ru-central1-a"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    preemptible   = true
    subnet_id     = "subnet-ru-central1-a"
    nat           = true
  }
}

vms_resources_metadata = {
  all = {
    serial-port-enable = "1"
    ssh-user = "ubuntu"
  }
}

# Config NAT and route table
nat_gateway = {
  develop-nat_gateway = {
    name = "develop-nat-gt"
  }
}

route_table = {
  develop-stat-route = {
    name = "develop-route-table"
    static_route = {
      destination_prefix = ["0.0.0.0/0"]
    }
  }
}