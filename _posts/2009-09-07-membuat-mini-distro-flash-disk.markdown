---
layout: post
title:  "Membuat Distro Mini pada Flash Disk"
date:   2009-09-07 12:36:56 +0800
categories: linux
---

# Bismillah,

__PENTING__: ini hanya catatan, bukan toturial, tidak untuk pemula linux. Pastikan anda selalu mengerti makna command yang anda ketik!!!

sumber penulisan:
-   [Pocket Linux Guide](http://www.tldp.org/LDP/Pocket-Linux-Guide/html/Pocket-Linux-Guide.html)
-   [Slackware_12_2  ./source/a/mkinitrd/](http://kambing.ui.ac.id/slackware/slackware-12.2/source/a/mkinitrd/)

A. buat partisi pada flash disk.
cek hardisk yang digunakan:

```text
root@pisang:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root              5826936   5434676     96264  99% /
/dev/sda8              1185872    303288    822344  27% /usr/src
/dev/sda2             84989060  46497564  38491496  55% /mnt/win_c
tmpfs                   511308         0    511308   0% /dev/shm
/dev/sda9              8087616   7918228    169388  98% /media/disk
/dev/sda6              8262036   7689412    152928  99% /mnt/sda6
```

pada hasil diatas, hardisk berada pada /dev/sda. tancapkan flash disk yang akan digunakan, cek posisi nya:
```text
root@pisang:~# dmesg | tail -10
[10004.529084] scsi 6:0:0:0: Direct-Access ************* PMAP PQ: 0 ANSI: 0 CCS
[10004.529239] sd 6:0:0:0: Attached scsi generic sg2 type 0
[10005.690803] sd 6:0:0:0: [sdb] 7936000 512-byte hardware sectors: (4.06 GB/3.78 GiB)
[10005.691421] usb-storage: device scan complete
[10005.691450] sd 6:0:0:0: [sdb] Write Protect is off
[10005.691454] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[10005.691457] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[10005.693652] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[10005.693659]  sdb: sdb1
[10005.741702] sd 6:0:0:0: [sdb] Attached SCSI removable disk
```

terlihat bahwa flash disk dengan ukuran 4GB berada pada /dev/sdb. penentuan posisi device ini PENTING, karena kita akan menggunakan tool fdisk untuk mempartisi flash disk. bila salah menentukan dan yang kena adalah hard disk, maka dapat merusak semua data.

buat partisi linux di flash disk

```text
root@pisang:~# fdisk /dev/sdb

Command (m for help): p

Disk /dev/sdb: 4063 MB, 4063232000 bytes
125 heads, 62 sectors/track, 1024 cylinders
Units = cylinders of 7750 * 512 = 3968000 bytes
Disk identifier: 0xde8e7bb0

Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         813     3150344    b  W95 FAT32

Command (m for help): n
Command action
e   extended
p   primary partition (1-4)
p
Partition number (1-4): 2
First cylinder (814-1024, default 814):
Using default value 814
Last cylinder, +cylinders or +size{K,M,G} (814-1024, default 1024):
Using default value 1024

Command (m for help): p

Disk /dev/sdb: 4063 MB, 4063232000 bytes
125 heads, 62 sectors/track, 1024 cylinders
Units = cylinders of 7750 * 512 = 3968000 bytes
Disk identifier: 0xde8e7bb0

Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         813     3150344    b  W95 FAT32
/dev/sdb2             814        1024      817625   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
root@pisang:~#
```

format partisi tadi dengan filesystem ext3, buat mount point, lalu mount:
```text
root@pisang:~# mkfs.ext3 /dev/sdb2
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
................
...............
root@pisang:~#
root@pisang:~# mkdir /mnt/distro
root@pisang:~# mount /dev/sdb2 /mnt/distro
root@pisang:~# df | grep distro
/dev/sdb2               804740     17212    746648   3% /mnt/distro
root@pisang:~#
```

install grub pada /mnt/distro
```text
root@pisang:~# grub-install --root-directory=/mnt/distro /dev/sdb
Probing devices to guess BIOS drives. This may take a long time.
Installation finished. No error reported.
This is the contents of the device map /mnt/distro/boot/grub/device.map.
Check if this is correct or not. If any of the lines is incorrect,
fix it and re-run the script `grub-install'.

(fd0)   /dev/fd0
(hd0)   /dev/sda
(hd1)   /dev/sdb
root@pisang:~#
```

compile busybox
```text
root@pisang:/usr/src/busybox# tar -xjf busybox-1.7.2.tar.bz2
root@pisang:/usr/src/busybox# cd busybox-1.7.2
root@pisang:/usr/src/busybox/busybox-1.7.2# patch -p1 < ../busybox-1.7.2.no-gc-sections.diff
patching file Makefile
root@pisang:/usr/src/busybox/busybox-1.7.2# patch -p1 < ../busybox-1.7.2.remove_warning.diff
patching file applets/applets.c
root@pisang:/usr/src/busybox/busybox-1.7.2#
root@pisang:/usr/src/busybox/busybox-1.7.2# make clean 1> /dev/null 2> /dev/null
root@pisang:/usr/src/busybox/busybox-1.7.2# make menuconfig

Busybox Settings  --->
___General Configuration  --->
______[ ] See lots more (probably unnecessary) configuration options. "hilangkan *"
______(/bin/busybox) Path to BusyBox executable "rubah menjadi /bin/busybox"
___Build Options  --->
______[*] Build BusyBox as a static binary (no shared libs) "tambahkan *"
___Installation Options  --->
______[*] Don't use /usr

.......... // tiada perubahan
.......... // tiada perubahan

ipsvd utilities  --->
___[ ] tcpsvd "hilangkan *"
___[ ] udpsvd "hilangkan *"

"exit"

root@pisang:/usr/src/busybox/busybox-1.7.2# make 1> /dev/null 2> /dev/null
root@pisang:/usr/src/busybox/busybox-1.7.2# exit
exit
muntaza@pisang:~$
```

catatan: busybox dan patch nya bisa di download di [sini](http://kambing.ui.ac.id/slackware/slackware-12.2/source/a/mkinitrd/).




Buat ram file system
```text
muntaza@pisang:~$ mkdir distro
muntaza@pisang:~$ cd distro/
muntaza@pisang:~/distro$ mkdir lampihong
muntaza@pisang:~/distro$ cd lampihong/

muntaza@pisang:~/distro/lampihong$ mkdir {bin,dev,etc,proc,sbin,sys}
muntaza@pisang:~/distro/lampihong$ ls
bin/  dev/  etc/  proc/  sbin/  sys/

muntaza@pisang:~/distro/lampihong$ touch etc/mdev.conf
muntaza@pisang:~/distro/lampihong$ ls etc/
mdev.conf
muntaza@pisang:~/distro/lampihong$ cp /usr/src/busybox/busybox-1.7.2/busybox bin/
muntaza@pisang:~/distro/lampihong$ ls bin/
busybox*
muntaza@pisang:~/distro/lampihong$

muntaza@pisang:~/distro/lampihong$ vi init
=============
#!/bin/busybox sh

busybox --install -s

mount -t proc proc /proc
mount -t sysfs sysfs /sys

echo 0 > /proc/sys/kernel/printk
clear

mknod /dev/null c 1 3
mknod /dev/tty c 5 0
mknod /dev/tty1 c 4 1
mdev -s

echo "selamat datang di distro mini Lampihong Linux"
/linuxrc > /dev/null
=============
muntaza@pisang:~/distro/lampihong$ chmod +x init
muntaza@pisang:~/distro/lampihong$ ls -R
.:
bin/  dev/  etc/  init*  proc/  sbin/  sys/

./bin:
busybox*

./dev:

./etc:
mdev.conf

./proc:

./sbin:

./sys:
muntaza@pisang:~/distro/lampihong$
muntaza@pisang:~/distro/lampihong$ find . | cpio -H newc -o > ../lampihong.cpio
2863 blocks
muntaza@pisang:~/distro/lampihong$ cd ..
muntaza@pisang:~/distro$ gzip lampihong.cpio
muntaza@pisang:~/distro$ ls
lampihong/  lampihong.cpio.gz
muntaza@pisang:~/distro$
```

Ram file system sudah jadi, dengan nama lampihong.cpio.gz. selanjutnya adalah compile kernel linux, caranya bisa dilihat pada tulisan saya mengenai compile kernel. copy bzImage hasil compile kernel ke /mnt/distro,

```text
misalnya:
root@pisang:/usr/src/linux-2.6.30.5# cp arch/x86/boot/bzImage /mnt/distro/
```

copy juga ram file system tadi ke /mnt/distro

```text
root@pisang:/mnt/distro# ls
boot  bzImage
root@pisang:/mnt/distro# cp /home/muntaza/distro/lampihong.cpio.gz /mnt/distro/
root@pisang:/mnt/distro# ls
boot  bzImage  lampihong.cpio.gz

root@pisang:/mnt/distro# df -h | grep sdb2
/dev/sdb2             786M   22M  725M   3% /mnt/distro
root@pisang:/mnt/distro#
```

buat file menu.lst di direktori boot/grub

```text
root@pisang:/mnt/distro# vi boot/grub/menu.lst
=============
timeout 10
default 0

title Lampihong
kernel (hd0,1)/bzImage
initrd (hd0,1)/lampihong.cpio.gz
=============
root@pisang:/mnt/distro# ls -R
.:
boot  bzImage  lampihong.cpio.gz

./boot:
grub

./boot/grub:
default        fat_stage1_5      jfs_stage1_5    reiserfs_stage1_5  ufs2_stage1_5
device.map     ffs_stage1_5      menu.lst        stage1             vstafs_stage1_5
e2fs_stage1_5  iso9660_stage1_5  minix_stage1_5  stage2             xfs_stage1_5
root@pisang:/mnt/distro#
```

Selesai, reboot........ pilih urutan booting dari flash disk, untuk mencoba linux mini.

tampilannya adalah sbb:

```text
selamat datang di distro mini Lampihong Linux
#

```

untuk reboot, ketik /sbin/reboot.

# UPDATE 2020-02-09

Tutorial ini saya tulis sekitar 10 tahun yang lalu, disini saya tampilkan daftar tutorial lain
yang menggunakan kernel dan tool yang lebih update, namun saya pribadi belum pernah mencoba
mengikuti tutorial tersebut:

- [Minimal Linux Live](https://github.com/ivandavidov/minimal)
- [Minimal Linux Script](https://github.com/ivandavidov/minimal-linux-script)
- [Build Your Own Linux](http://www.buildyourownlinux.com/)
- [DIY: Build a Custom Minimal Linux Distribution from Source](https://www.linuxjournal.com/content/diy-build-custom-minimal-linux-distribution-source)
- [Build a Custom Minimal Linux Distribution from Source, Part II](https://www.linuxjournal.com/content/build-custom-minimal-linux-distribution-source-part-ii)

# Tanya Jawab

1.  Mengapa saya belajar membuat distro sendiri?

    Jawab:

    Membuat distro linux sendiri dari code sumber melatih skill command line anda,
    sehingga, insyaAllah, anda akan mendapat pengalaman berharga dari latihan ini.

Wallahu Ta'ala A'lam


# Alhamdulillah
