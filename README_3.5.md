1. Ответ: Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).

2. Ответ: нет не могут. Жесткая ссылка (hardlink) неразрывно связана с самим файлом, так как она не просто указывает на файл, а именно обеспечивает связь между записью в файловой таблице (Inode) и самим файлом (объектом на диске). Если вызвать команду stat по некому файлу и по hardlink на него, то будет видно, что оба объекта имеют одинаковый номер inode и одинаковое количество links, то есть ведут себя как один и тот же объект (или идентичный объект).

3. Ответ: ВМ с неразмеченными дисками создана:

```bash
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
```

4. Ответ: диск sdb разбит на два раздела:

```bash
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  500M  0 part
sdc                    8:32   0  2.5G  0 disk
vagrant@vagrant:~$
```

5. Ответ: Выполнено:

```bash
root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x1ac27d86.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 500 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x1ac27d86

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5220351 1024000  500M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
root@vagrant:~#



root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  500M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
└─sdc2                 8:34   0  500M  0 part
```


6. Ответ: Собрано:

```bash
root@vagrant:~# mdadm --create RAID1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdb2                 8:18   0  500M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdc2                 8:34   0  500M  0 part
```

7. Ответ: сделано


```bash
root@vagrant:~# mdadm --create RAID0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/RAID0 started.


root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdb2                 8:18   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdc2                 8:34   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
```

8. Ответ: выполнено

```bash
root@vagrant:~# pvcreate /dev/md127 /dev/md126
  Physical volume "/dev/md127" successfully created.
  Physical volume "/dev/md126" successfully created.
root@vagrant:~#
root@vagrant:~#
root@vagrant:~#
root@vagrant:~# pvs
  PV         VG        Fmt  Attr PSize   PFree
  /dev/md126           lvm2 ---  996.00m 996.00m
  /dev/md127           lvm2 ---   <2.00g  <2.00g
  /dev/sda5  vgvagrant lvm2 a--  <63.50g      0

```

9. Ответ: сделано

```bash
root@vagrant:~# vgcreate vg1 /dev/md126 /dev/md127
  Volume group "vg1" successfully created
root@vagrant:~#
root@vagrant:~#
root@vagrant:~#
root@vagrant:~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg1         2   0   0 wz--n-   2.96g 2.96g
  vgvagrant   1   2   0 wz--n- <63.50g    0
```

10. Ответ: сделано

```bash
root@vagrant:~# lvcreate -L 100M vg1 /dev/md126
  Logical volume "lvol0" created.
root@vagrant:~#
root@vagrant:~#
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdb2                 8:18   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdc2                 8:34   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm
```

11. Ответ: 

```bash
root@vagrant:~# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

root@vagrant:~#

```
12. Ответ:

```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vg1/lvol0 /tmp/new
```
13. Ответ: файл скопирован

```bash
root@vagrant:~# ll /tmp/new/
total 22152
drwxr-xr-x  3 root root     4096 Dec  4 23:36 ./
drwxrwxrwt 10 root root     4096 Dec  4 23:35 ../
drwx------  2 root root    16384 Dec  4 23:34 lost+found/
-rw-r--r--  1 root root 22655915 Dec  4 18:26 test.gz
```

14.  Ответ: 

```bash
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdb2                 8:18   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
└─sdc2                 8:34   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
```

15. Ответ: выполнено

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

16. Ответ: 

```bash
root@vagrant:~# pvmove /dev/md126
  /dev/md126: Moved: 20.00%
  /dev/md126: Moved: 100.00%


root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
│   └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md127              9:127  0    2G  0 raid1
│   └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  500M  0 part
  └─md126              9:126  0  996M  0 raid0
```

17. Ответ: 

```bash
root@vagrant:~# mdadm /dev/md127 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md127
```

18. Ответ:

```bash
[ 3688.598425] md/raid1:md127: Disk failure on sdc1, disabling device.
               md/raid1:md127: Operation continuing on 1 devices.

```
19. Ответ: 

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~#
root@vagrant:~#
root@vagrant:~# echo $?
0
```

20. Ответ:

```bash
PS C:\Users\vfkuhtenko\vagrant_configs> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```

