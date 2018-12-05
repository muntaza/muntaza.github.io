---
author: muntaza
comments: true
date: 2016-08-17 04:15:05+00:00
layout: post
link: https://muntaza.wordpress.com/2016/08/17/upgrade-firewall-ke-openbsd-6-0-current/
slug: upgrade-firewall-ke-openbsd-6-0-current
title: Upgrade Firewall ke OpenBSD 6.0-current
wordpress_id: 469
categories:
- Firewall
- Networking
- OpenBSD
- PF
---

Bismillah

Baru saja saya melakukan Upgrade Firewall ke 6.0-current; dan Alhamdulillah lancar. Saya langsung download file bsd.rd dari http://kartolo.sby.datautama.net.id/pub/OpenBSD/snapshots/amd64/bsd.rd

lalu saya copy ke / kemudian reboot.
saat booting; saya ketik bsd.rd agar booting ke file instalasi.
kemudian saat ada pilihan untuk upgrade; saya pilih Upgrade; lalu tinggal Enter-Enter saja he... he...

sampai ke pilihan sumber; saya ketik http; lalu pilihan mengisi alamatnya; saya ketik kartolo.sby.datautama.net.id;
lalu pas pilihan paket yang di install; saya ketik -x* untuk tidak menginstall paket X server; duh ini mesin firewall bukan desktop; he..he..

tinggal Enter-Enter; lalu reboot. setelah reboot; saya ketik sysmerge untuk melihat adakah file yang berubah; ternyata hanya satu yaitu /etc/ssh/sshd_config lalu pada menu sysmerge saya tekan i untuk menginstall file config terbaru.

Lalu saya test koneksi ke server dari HP Android dan Alhamdulilah konek .....he... he...


Ini tampilah dmesg | head nya; duh ini kebiasaan Pengguna OpenBSD selalu suka nampilin dmesg nya.. he... he... dalam rangka pembuktian aja.
{% highlight bash %}
$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza), 0(wheel)
$
$ dmesg |head
OpenBSD 6.0-current (RAMDISK_CD) #2145: Tue Aug 16 09:49:18 MDT 2016
    deraadt@amd64.openbsd.org:/usr/src/sys/arch/amd64/compile/RAMDISK_CD
real mem = 4225024000 (4029MB)
avail mem = 4095258624 (3905MB)
mainbus0 at root
bios0 at mainbus0: SMBIOS rev. 2.7 @ 0xec030 (78 entries)
bios0: vendor LENOVO version "IEKT13AUS" date 07/16/2013
bios0: LENOVO 10130
acpi0 at bios0: rev 2
acpi0: tables DSDT FACP APIC FPDT SSDT SSDT MCFG HPET SSDT SSDT BGRT DMAR
$


{% endhighlight %}

Melalui tulisan ini saya ingin membantah pernyataan orang-orang yang menganggap OpenBSD adalah Operating System yang sulit di gunakan; Saya nyatakan disini; bahwa saya telah pernah menginstall beberapa Jenis Turunan Unix; diantaranya Linux; OpenIndiana; Minix; DragonflyBSD; maka yang paling mudah menurut saya adalah OpenBSD.



sekian; Alhamdulillah


Muhammad Muntaza




