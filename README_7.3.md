# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

Ответ:

```
Бэкенд в Яндекс Облаке успешно зарегистрирован:

~/netology/DevOps/devops-netology/terraform$ terraform init -backend-config="access_key=$access_key" -backend-config="secret_key=$secret_key"

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.77.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  

Ответ:
```
Вывод terraform init представлен в предыдущей задаче.
```
Вот скриншот из s3 корзины с файлом tfstate:
![image](https://user-images.githubusercontent.com/60869933/184502277-15fe4a97-879c-472c-875c-5e6bbdd375d8.png)


2. Создайте два воркспейса `stage` и `prod`.

Ответ:

```
~/netology/DevOps/devops-netology/terraform$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

~/netology/DevOps/devops-netology/terraform$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

~/netology/DevOps/devops-netology/terraform$ terraform workspace list
  default
* prod
  stage
```
3. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.

Ответ:

```
Поскольку я использую Яндекс Облако и ранее работал с созданием образов ВМ в предыдущих задачах, то данный пункт адаптировал под модификацию одного из параметров создаваемого образа на основе workspace.
Для этих целей я выбрал параметр min_disk_size для образа ВМ. И в случае если работа ведется в workspace stage, то данный параметр выставляется в значение "10", а в случае работы в workspace prod, параметр берется равным "50".

Часть кода в файле main.tf, которая за это отвечает:

locals {
  min_disk_size = {
    stage = "10"
    prod  = "50"
  }
}


resource "yandex_compute_image" "test_image" {
  name          = "my-test-image"
  source_image  = "fd81u2vhv3mc49l1ccbb"
  folder_id     = "b1gk5uhgm7kbkd0ajf1i"
  os_type       = "LINUX"
  min_disk_size = local.min_disk_size[terraform.workspace]
}

И далее при выполении terraform plan в разных workspace, параметр получается таким, каким требуется по задумке, workspace stage:

~/netology/DevOps/devops-netology/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test_image will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = 10 			# <--------- Работаем в workspace stage => минимальный размер диска 10     
      + name            = "my-test-image"
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
~/netology/DevOps/devops-netology/terraform$ terraform workspace select prod
Switched to workspace "prod".
~/netology/DevOps/devops-netology/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test_image will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = 50		# <-------------- workspace prod => min_disk_size = 50
      + name            = "my-test-image"
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

4. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
5. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.

Добавил цикл for_each для создания двух образов:

```
Часть файла main.tf, отвечающая за цикл и создание образов:

data "yandex_compute_image" "ubuntu-2004" {
  folder_id  = "standard-images"
  name   = "ubuntu-20-04-lts-v20220704"
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

Результат выполнения terraform plan:

~/netology/DevOps/devops-netology/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test_image["my-test-image"] will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = 50
      + name            = "my-test-image"		#<--------------- Согласно циклу создается образ ВМ с названием my-test-image
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_compute_image.test_image["my-test-image-01"] will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = 50
      + name            = "my-test-image-01"		#<------------ Согласно циклу создается образ ВМ с названием my-test-image01
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```

6. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
7. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

Ответ:

```
~/netology/DevOps/devops-netology/terraform$ terraform workspace list
  default
* prod
  stage

terraform plan для workspace prod:

~/netology/DevOps/devops-netology/terraform$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test_image will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "my-test-image"
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.


При этом для workspace default я уже создал сети ранее, поэтому вывод такой:

~/netology/DevOps/devops-netology/terraform$ terraform plan
yandex_vpc_network.default: Refreshing state... [id=enpdv25o2t8f2esto0do]
yandex_vpc_subnet.default: Refreshing state... [id=e9bjtsigvg5qb9nq1a5m]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # yandex_vpc_network.default has changed
  ~ resource "yandex_vpc_network" "default" {
        id         = "enpdv25o2t8f2esto0do"
        name       = "net"
      ~ subnet_ids = [
          + "e9bjtsigvg5qb9nq1a5m",
        ]
        # (3 unchanged attributes hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these
changes.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.test_image will be created
  + resource "yandex_compute_image" "test_image" {
      + created_at      = (known after apply)
      + folder_id       = "b1gk5uhgm7kbkd0ajf1i"
      + id              = (known after apply)
      + min_disk_size   = (known after apply)
      + name            = "my-test-image"
      + os_type         = "LINUX"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = (known after apply)
      + source_image    = "fd81u2vhv3mc49l1ccbb"
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.


То есть согласно настройкам в воркспейсе prod будет создана вся инфраструктура, описанная в main.tf файле. В то же время в workspace default будет создан только новый образ ВМ, а сети уже были созданы ранее.

Содержимое файла main.tf:

~/netology/DevOps/devops-netology/terraform$ cat main.tf
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
  folder_id  = "standard-images"
  name   = "ubuntu-20-04-lts-v20220704"
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
