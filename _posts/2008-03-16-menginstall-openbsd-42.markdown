---
author: muntaza
comments: true
date: 2008-03-16 07:55:25+00:00
layout: post
link: https://muntaza.wordpress.com/2008/03/16/menginstall-openbsd-42/
slug: menginstall-openbsd-42
title: Menginstall OpenBSD 4.2
wordpress_id: 11
categories:
- OpenBSD
---

Bahagia sekali rasanya bisa mengungkapkan tulisan lewat blog, jadi bila suatu hari lupa, bisa browsing ke blog pribadi ini he..he..

Ini bukan toturial cuma cerita aja jadi tidak menjelaskan step by step menginstal OpenBSD, lengkapnya cara install OpenBSD ada di situsnya yaitu [www.openbsd.org](http://www.openbsd.org).

Kemarin aku belajar membongkar file cd42.iso (cuma 5M he..he..) dan memasukkan file-file terpisah yang ku download, yaitu

base42.tgz, bsd, etc42.tgz, man42.tgz, dan xetc42.tgz. cuma itu doang yang ku download, soalnya bandwith terbatas he..he..  . Proses download itupun memakan waktu lama He... he...

Aku memproses pembuatan file iso ini di system operasi Microsoft Windows XP (tm). Semua aplikasi yang digunakan adalah aplikasi freeware, yaitu:

1. IZArc dari [www.izarc.org](http://www.izarc.org)

2. FinalBurner dari [www.protectedsoft.com](http://www.protectedsoft.com)

3. ImgBurn dari [www.imgburn.com](http://www.imgburn.com)

4. bootpart.exe dari [www.winimage.com/bootpart.htm](http://www.winimage.com/bootpart.htm) (untuk mengedit "boot.ini" agar bisa booting ke OpenBSD)

pertama yang ku lakukan adalah membuat folder create_iso, lalu ku copy file cd42.iso dan ku extrack disitu dengan aplikasi "IZArc", ku delete file cd42.iso setelah di extrack.

ada 3 buah folder dan satu file hasil extrack tadi, yaitu:

1. 4.2/I386

2. ETC

3. boot.images (disini ada file no_emul.00, yang digunakan sbg boot image

4. dan file "TRANS.TBL"

Lalu aku buat satu folder "OS" di dalam folder "4.2" (4.2/OS/) dan ku copy semua file *.tgz diatas dan file "bsd" kedalam folder tersebut (4.2/OS)

OKE, file sudah siap, kini saatnya untuk membuat file isonya dari folder create_iso. aku menggunakan aplikasi "FinalBurner". dengan FinalBurner, ku ambil semua file dan folder dalam direktori create_iso lalu ku set cd agar bootable dan masukkan file boot.image nya yaitu di create_iso/boot.images/no_emul.00. dan buat isonya dengan nama fb_obsd.iso.

Setelah fb_obsd.iso selesai, aku membakarnya dengan ImgBurn. Jadi deh cd instalasi OpenBSD ku he..he..

-----Instalasi OpenBSD----

Saatnya untuk menginstall OpenBSD. masukkan cdnya dan reboot....... setelah boot, filih boot via cdrom. tampil deh prosedur instalasi OpenBSD. yang pertama dilakukan adalah membuat partisi dengan kode A6. Pada hardisk ada 3 partisi yaitu:

1. Partisi Pertama Primary (33 GB, Drive C di Windows XP (tm))

2. Partisi Kedua Primary (18 GB, Drive D di Windows XP (tm))

3 Partisi ketiga Primary (sekitar 20 GB, Drive F di Windows XP (tm))

aku akan merubah partisi primary ketiga untuk menjadi Partisi OpenBSD. yaitu dengan gambaran sbb:

fdisk> edit 2   (yaitu mengedit partisi primary ketiga)

Partition id ('0' to disable)  [0 - FF]: [0] (? for help) a6

fdisk> edit in chs "NO" ? "enter"

fdisk> ofset [xxxxxxx] "enter"

fdisk> size [xxxxxxx] "enter"

fdisk> write

fdisk> quit

aku tidak menjadikan partisi OpenBSD dengan "flag partisi aktif", flag partisi tetap pada Partisi pertama dengan id "0". hal ini karena aku akan menggunakan "bootpart.exe" untuk mengedit boot.ini untuk memboot OpenBSD dengan NT boot Manager. sebagaimana disarankan pada [http://www.openbsd.org/faq/faq4.html](http://www.openbsd.org/faq/faq4.html)

Setelah itu aku membuat disklabel dengan ukuran sbb:

wd0a ==>  / ===> 300M

wd0b ==>  swap ===> 300M

wd0d ==>  /tmp ===> 500M

wd0e ==>  /var ===> 1000M

wd0f ==>  /usr ===> 4000M

wd0g ==>  /home ===> 3000M

lalu jalankan proses selanjutnya yaitu instalasi file *.tgz nya, yang cuma terdiri dari base42.tgz, bsd, etc42.tgz, man42.tgz, dan xetc42.tgz. fileset xetc42.tgz tidak ku install, karena xbase42.tgz nya tidak ada he..he..

Lalu setting jaringan dan lainnya dan akhirnya OpenBSD 4.2 selesai terinstal. Masalah berikutnya adalah tidak ada boot manajer seperti Grub atau Lilo yang akan mengatur proses booting, dan seperti diatas kusampaikan bahwa booting akan menggunakan NT boot Manager. NT boot Manager menggunakan file "boot.ini" di drive C sebagai file configurasinya.

Aku booting ke MS Windows XP (tm), lalu menjalankan "cmd", dan menjalankan program bootpart. gambarannya adalah sbb:

C:\> bootpart.exe (melihat partisi)

C:\> bootpart.exe 2 obsd.bot OpenBSD (mengambil image untuk boot OpenBSD dari Partisi Primary "KETIGA", menamakan obsd.bot dan "mengedit file boot.ini" agar Bisa memboot OpenBSD)

C:\> bootpart.exe list (melihat isi file "boot.ini" dan ternyata baris OpenBSD sudah masuk......:) )

REBOOT...................

booting lagi dan ada pilihan Windows XP dan OpenBSD, lalu aku coba memilih OpenBSD dan BERHASIL masuk ke OpenBSD. ... he..he.. Hebat sekali menurutku aplikasi bootpart.exe ini ........

------selesai--------

Ditulis di Paringin tanggal 16 Maret oleh Muhammad Muntaza bin Hatta
