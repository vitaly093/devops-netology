1. Ответ: 

```
route-views>show ip route 185.13.112.230
Routing entry for 185.13.112.0/22
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 6d14h ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 6d14h ago
      Route metric is 0, traffic share count is 1
      AS Hops 4
      Route tag 2497
      MPLS label: none
route-views>

```
route-views>show bgp 185.13.112.230
BGP routing table entry for 185.13.112.0/22, version 1388732254
Paths: (24 available, best #14, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 1273:12276 1273:32090 3303:1004 3303:1006 3303:3056
      path 7FE0FCB213D8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 174 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE09CA7BF60 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 1299 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE139B6E388 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1050 7660:9003
      path 7FE166C24018 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 6830 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1273:12276 1273:32090 6830:17000 6830:17473 6830:33122 17152:1 57866:501
      path 7FE12536A248 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE0131C4DC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 1273:12276 1273:32090
      path 7FE0EF6CBF78 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 12389 12389 12389 12389 12389 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE0F3448958 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 12389 12389 12389 12389 12389 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:4000 3257:8794 3257:50001 3257:50110 3257:54900 3257:54901 20912:65004
      path 7FE1327B6378 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1273:12276 1273:32090 8283:1 8283:101
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE08D5DB590 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1273:12276 1273:32090 3356:3 3356:22 3356:86 3356:575 3356:666 3356:903 3356:2011
      path 7FE09A98A260 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE044DCFF58 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3356 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE179E83788 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external, best
      path 7FE022088570 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  20130 6939 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE180516148 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0065C7D30 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 12389 12389 12389 12389 12389 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:4000 3257:8794 3257:50001 3257:50110 3257:54900 3257:54901
      path 7FE0BCDF6ED8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1273:12276 1273:32090 3356:3 3356:22 3356:86 3356:575 3356:666 3356:903 3356:2011 3549:2581 3549:30840
      path 7FE0E6302C40 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 174 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21000 174:22013 53767:5000
      path 7FE11D71A058 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 174 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 174:21000 174:22013
      Extended Community: RT:101:22100
      path 7FE12BA2BB70 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 209 3356 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE14830FD88 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE006F23E50 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE04271D650 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  19214 174 1273 12389 42610 29069, (aggregated by 29069 172.16.16.6)
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin IGP, localpref 100, valid, external
      Community: 174:21000 174:22013
      path 7FE10C73F158 RPKI State not found
      rx pathid: 0, tx pathid: 0
route-views>

```

2. Ответ: 

```bash
root@vagrant:~# cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto dummy0
iface dummy0 inet static
    address 10.2.2.2/32
    pre-up ip link add dummy0 type dummy
    post-down ip link del dummy0
root@vagrant:~#

root@vagrant:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 75647sec preferred_lft 75647sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 82:16:4a:90:28:1c brd ff:ff:ff:ff:ff:ff
    inet 10.2.2.2/32 brd 10.2.2.2 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::8016:4aff:fe90:281c/64 scope link
       valid_lft forever preferred_lft forever
root@vagrant:~#

```

Добавлена пара временных статических маршрутов:

```bash

root@vagrant:~# ip route add 172.16.10.0/24 via 10.2.2.2

root@vagrant:~# ip route add 172.16.10.0/24 dev eth0 metric 100

root@vagrant:~# ip ro
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
172.16.10.0/24 via 10.2.2.2 dev dummy0
172.16.10.0/24 dev eth0 scope link metric 100
```

3. Ответ: проверка открытых TCP портов:

```bash

root@vagrant:~# ss -ltp
State     Recv-Q    Send-Q       Local Address:Port           Peer Address:Port    Process
LISTEN    0         4096               0.0.0.0:sunrpc              0.0.0.0:*        users:(("rpcbind",pid=610,fd=4),("systemd",pid=1,fd=88))
LISTEN    0         4096         127.0.0.53%lo:domain              0.0.0.0:*        users:(("systemd-resolve",pid=611,fd=13))
LISTEN    0         128                0.0.0.0:ssh                 0.0.0.0:*        users:(("sshd",pid=851,fd=3))
LISTEN    0         4096                  [::]:sunrpc                 [::]:*        users:(("rpcbind",pid=610,fd=6),("systemd",pid=1,fd=90))
LISTEN    0         128                   [::]:ssh                    [::]:*        users:(("sshd",pid=851,fd=4))
root@vagrant:~#

```

Из вывода с ключами l t p видно: соединения, которые "слушает" сервер, TCP соединения, процессы, которые их используют.

Получается, что слушающие указанные порты процессы это - "rpcbind",pid=610,fd=4; "systemd-resolve",pid=611,fd=13 и "sshd",pid=851,fd=3
Systemd-resolve - DNS сервер (53-й порт), поскольку в настройках прописан IP DNS сервера:

```bash
root@vagrant:~# cat /etc/resolv.conf
# This file is managed by man:systemd-resolved(8). Do not edit.
#
# This is a dynamic resolv.conf file for connecting local clients to the
# internal DNS stub resolver of systemd-resolved. This file lists all
# configured search domains.
#
# Run "resolvectl status" to see details about the uplink DNS servers
# currently in use.
#
# Third party programs must not access this file directly, but only through the
# symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a different way,
# replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 127.0.0.53
options edns0 trust-ad
root@vagrant:~#

```

То есть локальный хост.


sshd - 22 TCP порт, это процесс, отвечающий за соединения с этим сервером по ssh. То есть сервер слушает входящие соединения на 22 TCP порт.

sunrpc - 111 TCP порт. Сервис удаленного вызова процедур.

4. Ответ: UDP сокеты можно просмотреть аналогичной командой:

```bash

root@vagrant:~# ss -lup
State     Recv-Q    Send-Q        Local Address:Port          Peer Address:Port    Process
UNCONN    0         0             127.0.0.53%lo:domain             0.0.0.0:*        users:(("systemd-resolve",pid=611,fd=12))
UNCONN    0         0            10.0.2.15%eth0:bootpc             0.0.0.0:*        users:(("systemd-network",pid=411,fd=15))
UNCONN    0         0                   0.0.0.0:sunrpc             0.0.0.0:*        users:(("rpcbind",pid=610,fd=5),("systemd",pid=1,fd=89))
UNCONN    0         0                      [::]:sunrpc                [::]:*        users:(("rpcbind",pid=610,fd=7),("systemd",pid=1,fd=91))
root@vagrant:~#

```

Здесь как и в примере выше - 53 UDP порт используется для прослушивания DNS запросов на локальный хост.

sunrpc - 111 UDP порт, как и в предыдущем случае - сервис вызова удаленных процедур, но использующий протокол UDP.

bootpc - bootstrap protocol. Протокол, который используется для автоматического получения клиентом IP адреса во время загрузки сервера. 



5. Ответ: прикрепляю картинку:






