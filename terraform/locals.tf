locals {
  vms_ssh_public_root_key = data.local_file.ssh_auth_yc
}

locals {
  web = "${var.vms_resources.web.name}_${var.vms_resources.web.zone}"
  db  = "${var.vms_resources.db.name}_${var.vms_resources.db.zone}"
}