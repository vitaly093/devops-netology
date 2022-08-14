terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-state-test-backend"
    region     = "ru-central1"
    key        = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

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

data "yandex_compute_image" "ubuntu-2004" {
  folder_id	= "standard-images"
  name		= "ubuntu-20-04-lts-v20220704"
}

locals {
  min_disk_size = {
    stage = "10"
	prod  = "50"
  }
  image_instances = {
    "my-test-image" = data.yandex_compute_image.ubuntu-2004.id
    "my-test-image-01" = data.yandex_compute_image.ubuntu-2004.id
  
  }
}


resource "yandex_compute_image" "test_image" {
  for_each = local.image_instances
  name          = each.key
  source_image  = each.value
  folder_id     = "b1gk5uhgm7kbkd0ajf1i"
  os_type       = "LINUX"
  min_disk_size = local.min_disk_size[terraform.workspace]
}
