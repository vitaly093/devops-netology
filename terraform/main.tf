terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "b1g2395348lsfc3abbpr"
  folder_id = "b1gk5uhgm7kbkd0ajf1i"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}


resource "yandex_compute_image" "test_image" {
  name       	= "my-test-image"
  source_image	= "fd81u2vhv3mc49l1ccbb"
  folder_id	= "b1gk5uhgm7kbkd0ajf1i"
  os_type	= "LINUX"
}
