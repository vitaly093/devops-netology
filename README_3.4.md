1. Ответ: скачан файл node_exporter с github и запущен процесс:

vagrant@vagrant:~$ ps aux | grep node
node_ex+    1905  0.0  0.9 805860  9372 ?        Ssl  21:31   0:00 /usr/local/bin/node_exporter

Создан Unit файл процесса и конфигурационный файлы для сервиса node_exporter:

vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.config=/opt/node_exporter/config.yml

[Install]
WantedBy=multi-user.target


vagrant@vagrant:~$ cat /opt/node_exporter/config.yml
#some_config

Сервис добавлен в автозагрузку и при перезапуске - включается:

vagrant@vagrant:~$ sudo systemctl restart node_exporter
vagrant@vagrant:~$ sudo systemctl status node_exporter
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-11-29 21:45:50 UTC; 2s ago
   Main PID: 2004 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 1.6M
     CGroup: /system.slice/node_exporter.service
             └─2004 /usr/local/bin/node_exporter --web.config=/opt/node_exporter/config.yml

Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=thermal_zone
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=time
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=timex
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=uname
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=xfs
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:115 level=info collector=zfs
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.181Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Nov 29 21:45:50 vagrant node_exporter[2004]: ts=2021-11-29T21:45:50.182Z caller=tls_config.go:231 level=info msg="TLS is disabled." http2=false


2. Ответ: я бы выбрал следующие:

node_cpu_seconds_total{cpu="0",mode="idle"}
node_cpu_seconds_total{cpu="0",mode="iowait"}

node_memory_MemAvailable_bytes
node_memory_MemFree_bytes

node_disk_io_now{device="dm-0"} 0
node_disk_io_now{device="dm-1"} 0
node_disk_io_now{device="sda"} 0

node_disk_io_time_seconds_total{device="dm-0"}
node_disk_io_time_seconds_total{device="dm-1"}
node_disk_io_time_seconds_total{device="sda"} 
 
node_network_receive_drop_total
node_network_transmit_drop_total
node_network_up
node_network_receive_bytes_total
node_network_transmit_bytes_total


3. Ответ: netstat установлен, порт открыт, с локальной машины подключиться удалось:

vagrant@vagrant:~$ netstat tulpn

Active Internet connections (w/o servers)

Proto Recv-Q Send-Q Local Address           Foreign Address         State

tcp        0      0 vagrant:19999           _gateway:54058          ESTABLISHED

![image](https://user-images.githubusercontent.com/60869933/144112613-1126e3fa-f926-4521-bb8d-8c9c41e58f13.png)


4. Ответ: да, можно, это видно как минимум вот по этим строкам:

[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] Hypervisor detected: KVM


5. Ответ: fs.nr_open - это лимит на количество открытых дескрипторов. Имеет следующее значение:

sysctl fs.nr_open
fs.nr_open = 1048576

Для пользователя по умолчанию установлено ограничение open files  (-n) 1024, то есть 1024 открытых дескриптора для текущей сессии терминала.



6. Ответ:

sudo unshare -f --pid --mount-proc /bin/bash

Далее запущен процесс sleep 1h, и видно, что он в отдельном неймспейсе:

root@vagrant:~# nsenter --target 2167 --pid --mount
root@vagrant:/#
root@vagrant:/#
root@vagrant:/#
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.4   9836  4040 pts/0    S    19:45   0:00 /bin/bash
root          16  0.0  0.0   8076   584 pts/0    S+   19:54   0:00 sleep 1h
root          26  0.0  0.4   9836  4088 pts/1    S    19:54   0:00 -bash
root          35  0.0  0.3  11492  3324 pts/1    R+   19:54   0:00 ps aux


7. Ответ: :(){ :|:& };: - это функция, которая внутри составной команды {} запускает два своих экземпляра. Каждый экземпляр далее запускает еще по два, и так далее, пока ресурсы машины, на которой эта функция была запущена не будут исчерпаны.

Этот процесс останавливается благодаря тому, что для текущей сессии для одного пользователя имеется ограничение на количество процессов.

root@vagrant:~# ulimit -a | grep proc
max user processes              (-u) 3571


В выводе dmesg видно, что следующий клонируемый процесс, номер которого превышает ограничение, вызывает отклонение этой операции на основании имеющегося ограничения: 

[ 4024.853602] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-7.scope




