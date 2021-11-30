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



