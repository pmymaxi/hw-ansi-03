#Network
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# NAT gateway and route table
resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id = var.folder_id
  name      = var.nat_gateway.develop-nat_gateway.name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "dev-rt" {
  folder_id  = var.folder_id
  name       = var.route_table.develop-stat-route.name
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = var.route_table.develop-stat-route.static_route.destination_prefix[0]
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# VM Web
resource "yandex_vpc_subnet" "develop_web" {
  name           = var.vpc_name_web
  zone           = var.vms_resources.web.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_web
  route_table_id = yandex_vpc_route_table.dev-rt.id
}

data "yandex_compute_image" "ubuntu_web" {
  family = var.vms_resources.web.family
}
resource "yandex_compute_instance" "platform_web" {
  name        = local.web
  hostname    = var.vms_resources.web.hostname 
  platform_id = var.vms_resources.web.platform_id
  zone        = var.vms_resources.web.zone
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
      size     = var.vms_resources.web.disk_size
      type     = var.vms_resources.web.disk_type
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.web.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_web.id
    nat       = var.vms_resources.web.nat
  }

  metadata = {
    serial-port-enable = "${var.vms_resources_metadata.all.serial-port-enable}"
    ssh-keys           = "${var.vms_resources_metadata.all.ssh-user}:${data.local_file.ssh_auth_yc.content}"
  }
  allow_stopping_for_update = true
}

# VM db
data "yandex_compute_image" "ubuntu_db" {
  family = var.vms_resources.db.family
}
resource "yandex_compute_instance" "platform_db" {
  name        = local.db
  hostname    = var.vms_resources.db.hostname
  platform_id = var.vms_resources.db.platform_id
  zone        = var.vms_resources.db.zone
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
      size     = var.vms_resources.db.disk_size
      type     = var.vms_resources.db.disk_type
    }
  }
  scheduling_policy {
    preemptible = var.vms_resources.web.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_web.id
    nat       = var.vms_resources.web.nat
  }

  metadata = {
    serial-port-enable = "${var.vms_resources_metadata.all.serial-port-enable}"
    ssh-keys           = "${var.vms_resources_metadata.all.ssh-user}:${data.local_file.ssh_auth_yc.content}"
  }
  allow_stopping_for_update = true
}