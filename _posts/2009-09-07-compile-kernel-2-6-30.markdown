---
layout: post
title:  "Compile Kernel Linux 2.6.30"
date:   2009-09-07 12:26:56 +0800
categories: kernel
---

# Bismillah,

Alhamdulillah, dapat kesempatan menulis lagi, kali ini tentang compile kernel linux.

PENTING: sebagian command dijalankan sebagai root, bila anda pemula dalam hal linux, jangan meng compile kernel sendiri tanpa di dampingi oleh teman yang lebih ahli, untuk mencegah kerusakan system linux anda. pastikan anda selalu mengerti makna command yang anda ketik!!!

mengapa mengkompile kernel? jabawannya:
Pertama, adalah kadang terdapat kelemahan pada kernel, dalam hal security nya. Oleh itu maka kita download lah kernel terbaru, untuk menambal lobang security tadi. Pada contoh ini, adalah kernel linux 2.6.27.7 yang akan di ganti dengan kernel 2.6.30.5.

Kedua, untuk memilih konfigurasi sesuai spek hardware kita. misalnya kernel default distro ditujukan untuk prosessor i586, sedang kita punya yang lebih tinggi.

Ketiga, menonaktifkan driver yang hardware nya tiada di mesin, meng aktifkan yang belum di compile di kernel default distro bila perlu, memilih optimasi sesuai kebutuhan misalnya (Preemptible Kernel (Low-Latency Desktop)). dll

cek versi kernel sebelum compile
```text
muntaza@pisang:~/Download/misal$ uname -sr
Linux 2.6.27.7-smp
```

Proses compile kernel

A. Download kernel stabil terbaru, misalnya dari http://kambing.ui.ac.id/linux/v2.6

B. letakkan kernel tadi di direktori /usr/src dan masuk ke direktori itu

C. langkah selanjutnya sbb:
```text
root@pisang:/usr/src# tar -xjf linux-2.6.30.5.tar.bz2
root@pisang:/usr/src# cd linux-2.6.30.5
root@pisang:/usr/src/linux-2.6.30.5# make clean
root@pisang:/usr/src/linux-2.6.30.5# make mrproper
root@pisang:/usr/src/linux-2.6.30.5# make menuconfig

1. "General setup"
[ ] Prompt for development and/or incomplete code/drivers "hilangkan tanda *"
[ ] Export task/process statistics through netlink (EXPERIMENTAL) "hilangkan tanda *"
[ ] Profiling support (EXPERIMENTAL) "hilangkan tanda *"

2. [ ] Enable loadable module support  ---> "hilangkan tanda *"

3. -*- Enable the block layer  --->

4.  Processor type and features  --->
[ ] Support for extended (non-PC) x86 platforms "hilangkan tanda *"
____Processor family (Core 2/newer Xeon)  ---> "pilih core 2/newer xeon"
[*] Toshiba Laptop support "tambahkan *" #catatan: hanya bila mesin adalah laptop toshiba

5.  Power management and ACPI options  ---> "tiada perubahan"
6.  Bus options (PCI etc.)  ---> "tiada perubahan"
7.  Executable file formats / Emulations  ---> "tiada perubahan"
8.[*] Networking support  --->  "tiada perubahan"
9.  Device Drivers  ---> "tiada perubahan"
10. Firmware Drivers  ---> "tiada perubahan"

11. File systems  --->
____masuk DOS/FAT/NT Filesystems  --->
__________[*] NTFS file system support "tambahkan *"

12. Kernel hacking  ---> "tiada perubahan"
13. Security options  ---> "tiada perubahan"
-*- Cryptographic API  ---> "tiada perubahan"
15. [ ] Virtualization  ---> "hilangkan tanda *"
16. Library routines  ---> "tiada perubahan"

"exit"
```

catatan: konfigurasi kernel diatas adalah contoh saja, sebagai perubahan minimal pada konfigurasi default kernel, bisa disesuaikan bila perlu misalnya:

```text
___Processor type and features  --->
_______(2) Maximum number of CPUs
_______Preemption Model (Preemptible Kernel (Low-Latency Desktop))
_______[ ]   AMD microcode patch loading support (hilangkan tanda *)
___File systems  --->
_______[*] FUSE (Filesystem in Userspace) support

```



```text
root@pisang:/usr/src/linux-2.6.30.5#
root@pisang:/usr/src/linux-2.6.30.5# make 1> /dev/null 2> /dev/null
root@pisang:/usr/src/linux-2.6.30.5# cp arch/x86/boot/bzImage /boot/linux_2.6.30.5

/* catatan: nama kernel hasil compile adalah "bzImage" di direktori linux-2.6.30.5/arch/x86/boot */
```


D. setelah proses compile selesai dan kernel "bzImage" di copy ke /boot/linux_2.6.30.5, maka dilakukan perubahan pada boot loader. Boot loader yang digunakan pada contoh ini adalah grub, sbb:

```text
root@pisang:/usr/src/linux-2.6.30.5# vi /media/disk-1/boot/grub/menu.lst
```

tambahkan dua baris dibawah pada file menu.lst
```text
title linux_26_30_5
kernel (hd0,9)/boot/linux_2.6.30.5
```


catatan: file menu.lst adalah file konfigurasi grub, untuk booting.
```text
(hd0,9) bermakna:
hd0 => hardisk primary master
9 => partisi ke sepuluh
baca manual grub bila perlu, ketik "info grub".
```

Selesai sudah mengganti kernel, lalu reboot......., pilih di menu grub "linux_26_30_5"

setelah login, cek versi kernel
```text
muntaza@pisang:~/Download/misal$ uname -sr
Linux 2.6.30.5
```

berarti sudah menggunakan kernel 2.6.30.5.

Penutup:
kalau bisa, lalukan update berkala setiap rilis kernel stabil. Mungkin Hal ini sama dengan yang disebut patch pada OS lain. update kernel linux adalah sebagian kecil cara untuk mempertahankan security sistem linux.

# UPDATE 2020-02-09

Versi kernel sampai hari ini adalah kernel linux 5.5.2, tutorial ini saya tulis sekitar 10 tahun yang lalu, menggunakan kernel terbaru saat itu. Untuk tutorial cara compile kernel versi 5.3, silahkan lihat di [sini](https://www.cyberciti.biz/linux-news/linux-kernel-5-3-released-and-here-is-how-to-install-it/).

Wallahu Ta'ala A'lam

# Alhamdulillah
