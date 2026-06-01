output "out_info" {
  value = [
   ({
      "${local.web}" = {
        external_ip = yandex_compute_instance.platform_web.network_interface[0].nat_ip_address
        internal_ip = yandex_compute_instance.platform_web.network_interface[0].ip_address
        fqdn        = yandex_compute_instance.platform_web.fqdn
      }
      "${local.db}" = {
        external_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
        internal_ip = yandex_compute_instance.platform_db.network_interface[0].ip_address
        fqdn        = yandex_compute_instance.platform_db.fqdn
      }
    })
  ]
  }
