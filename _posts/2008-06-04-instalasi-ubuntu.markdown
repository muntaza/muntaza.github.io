---
author: muntaza
comments: true
date: 2008-06-04 00:57:31+00:00
layout: post
link: https://muntaza.wordpress.com/2008/06/04/instalasi-ubuntu/
slug: instalasi-ubuntu
title: Instalasi Ubuntu
wordpress_id: 19
categories:
- linux
---

Kemaren tanggal 3 Juni 2008, aku menginstall Ubuntu 8.04-desktop. Menginstallnya dari windows dengan file iso. Aku mendapat file iso dari temanku lalu ku copy file iso ke hardisk, lalu di mount dengan program MagicDisc ([http://www.magiciso.com/tutorials/miso-magicdisc-overview.htm](http://www.magiciso.com/tutorials/miso-magicdisc-overview.htm)). Program MagicDisc ini sangat bermanfaat menurutku, karena di windows tidak bisa memount file iso langsung, beda dengan Linux yang bisa langsung memount file iso dengan program "mount".

MagicDisc ini juga bisa membuat iso dari sebuah cd/dvd, jadi lebih mengawetkan cd/dvd dan drive-nya.

Kembali ke pembicaraan tadi, setelah dimount dengan Magicdisc, aku masuk ke drive tempat me mount, lalu klik file "wubi", tampil menu instalasi, klik Install inside Windows, lalu tampil menu pilihan drive yang akan diinstall, pilih drive hardisknyanya (yang ada ruang kosong 10GB, misal drive C), masukkan username, masukkan password, lalu install........ *

setelah file image nya tercopy kedisk, lalu reboot......**

setelah booting, lalu ada menu pilihan windows dan Ubuntu, aku pilih Ubuntu, lalu masuk ke Ubuntu dan melanjutkan proses instalasinya.

setelah selesai, reboot, boot lagi ke Ubuntu, cek sound ternyata OK he..he..

Kesimpulan:

Sangat ku sarankan bagi pemula-pemula yang bingung cara mempartisi dilinux untuk menginstall Ubuntu dari Windows seperti ini, karena tidak perlu takut kehilangan data karena salah mempartisi. ***

Salam, Muhammad Muntaza bin Hatta

tinggal di kota Paringin, Kab. Balangan, Prov. Kalimantan Selatan

---------------------------------------------------------------------------

*(proses instalasi ini sama sekali tidak berhubungan dengan partisi disk yang agak menyulitkan pemula linux)

**(Ubuntu ini, menggunakan NT loader untuk booting, jadi mengedit file boot.ini di drive C, file boot.ini ku isinya menjadi seperti ini:

[boot loader]
timeout=15
default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS
[operating systems]
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Home Edition" /noexecute=optin /fastdetect
c:\wubildr.mbr="Ubuntu"

***(Salam untuk temanku Hendra Wirawan di Bati-bati. Hen, Use your real name if you in the Internet ....he.. he.., and coba pakai Ubuntu ini untuk Komputer mu. Thanks)
