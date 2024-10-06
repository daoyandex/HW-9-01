terraform {
	required_providers {
		yandex = {
			source = "yandex-cloud/yandex"
		}
	}
}

provider "yandex" {
	#token     = "${YC_TOKEN}" # var.yc_iam_token
  #cloud_id  = var.yc_cloud_id
  #folder_id = var.yc_folder_id
  zone      = "ru-central1-a"#var.region
}

resource "yandex_vpc_network" "network-9-04" {
	name = "network-9-04"
}

resource "yandex_vpc_subnet" "subnet-9-04" {
	name = "subnet-9-04"
	v4_cidr_blocks = ["172.24.8.0/24"]
	network_id = yandex_vpc_network.network-9-04.id
}

resource "yandex_compute_instance" "vm" {
    count = 2
	name = "vm${count.index}"
	platform_id = "standard-v3"
	scheduling_policy {
		 preemptible = true
	}
	boot_disk {
		initialize_params {
			image_id = "fd870suu28d40fqp8srr"
			type = "network-hdd"
			size = 10
		}
	}
	resources {
		memory = 2
    cores  = 2
		core_fraction = 20
	}
    network_interface {
        subnet_id = yandex_vpc_subnet.subnet-9-04.id
        nat = true
    }
    
    metadata = { 
        ssh-keys = "yc-user:${file("~/.ssh/yandexssh.pub")}"
        user-data="${file("user.yml")}" 
    }
}

resource "yandex_lb_target_group" "lb-tagretgroup-9-04" {
    name = "lb-targetgroup"
    target {
        subnet_id = "${yandex_vpc_subnet.subnet-9-04.id}"
        address = yandex_compute_instance.vm[0].network_interface.0.ip_address
    }
    target {
        subnet_id = "${yandex_vpc_subnet.subnet-9-04.id}"
        address = yandex_compute_instance.vm[1].network_interface.0.ip_address
    }
}

resource "yandex_lb_network_load_balancer" "lb-9-04" {
    name = "lb-9-04"
    deletion_protection = "false"
    listener {
        name = "lb-9-04"
        port = 80
        external_address_spec {
            ip_version = "ipv4"
        }
    }
    attached_target_group {
        target_group_id = yandex_lb_target_group.lb-tagretgroup-9-04.id
        healthcheck {
          name = "http"
          http_options {
            port = 80
            path = "/"
          }
        }
    }
}

output "lb-9-04-ip" {
  value = yandex_lb_network_load_balancer.lb-9-04.listener
}

output "vm-ips" {
  value = tomap ({
    for name, vm in yandex_compute_instance.vm : name => vm.network_interface.0.nat_ip_address
  })
}

output "vm-ip_addresses" {
  value = tomap ({
    for name, vm in yandex_compute_instance.vm : name => vm.network_interface.0.ip_address
  })
}