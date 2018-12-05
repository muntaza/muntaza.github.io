---
author: muntaza
comments: true
date: 2011-03-07 03:03:24+00:00
layout: post
link: https://muntaza.wordpress.com/2011/03/07/lilo-dan-grub/
slug: lilo-dan-grub
title: LILO dan GRUB
wordpress_id: 251
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
- opensolaris
---

Bismillah,

saat ini saya berpindah dari lilo ke grub karena saya menginstall opensolaris 2009.06 sehingga opensolaris tadi meng overwrite lilo saya di mbr. ini isi /etc/lilo.conf saya pada awalnya.


diedit untuk penyesuaian dan agar ringkas

[sourcecode languange="bash"]
bash-4.1$ cat /etc/lilo.conf | grep -v "^#"
boot = /dev/sda

prompt
timeout = 300
lba32
vga = normal

other = /dev/sda2
label = Windows
table = /dev/sda

image = /boot/vmlinuz
initrd = /boot/initrd_asli.gz
root = /dev/sda5
label = Linux

other = /dev/sda1
label = OpenBSD
table = /dev/sda


[/sourcecode]

partisi /boot saya berada di /dev/sda8 dan partisi / aka root di /dev/sda5
oleh grub /dev/sda8 = (hd0,7) dan /dev/sda5 = (hd0,4)

hd0 berarti primary master
hd1 berarti secondary master
hd2 berarti primary slave
hd3 berarti secondary slave

partisi diawali dengan 0, hingga hd0,0 adalah partisi pertama pada primary master.

jadi partisi ke-5 pada primary master adalah hd0,4.

Saya akan tampilkan dari menu.lst grub di opensolaris sebagai berikut:
[sourcecode languange="bash"]
splashimage /boot/grub/splash.xpm.gz
background 215ECA
timeout 30
default 0
#---------- ADDED BY BOOTADM - DO NOT EDIT ----------
title OpenSolaris 2009.06
findroot (pool_rpool,2,a)
bootfs rpool/ROOT/opensolaris
splashimage /boot/solaris.xpm
foreground d25f00
background 115d93
kernel$ /platform/i86pc/kernel/$ISADIR/unix -B $ZFS-BOOTFS,console=graphics
module$ /platform/i86pc/$ISADIR/boot_archive
#---------------------END BOOTADM--------------------

# Unknown partition of type 39 found on /dev/rdsk/c8t0d0p0 partition: 1
# It maps to the GRUB device: (hd0,0) .

title Windows
rootnoverify (hd0,1)
chainloader +1

#ditambahkan oleh muntaza
#mulai-------
title Linux
root (hd0,4)
kernel (hd0,7)/vmlinuz
initrd (hd0,7)/initrd_asli.gz

title OpenBSD
rootnoverify (hd0,0)
chainloader +1
#selesai-----

# Unknown partition of type 5 found on /dev/rdsk/c8t0d0p0 partition: 4
# It maps to the GRUB device: (hd0,3) .
[/sourcecode]

Dengan GRUB, tidak perlu menjalankan "lilo" bila pergantian kernel, tapi partisi /boot linux menggunakan ext3, belum bisa ext4. Mungkin di grub2 sudah bisa ext4.

Walhamdulillah

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Tabaraka Wa Ta’ala memudahkan saya untuk tinggal di Kota Banjarbaru.
