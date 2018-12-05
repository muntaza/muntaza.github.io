---
author: muntaza
comments: true
date: 2010-11-23 00:55:05+00:00
layout: post
link: https://muntaza.wordpress.com/2010/11/23/instalasi-openbsd-4-8-di-laptop-toshiba-satellite-l310/
slug: instalasi-openbsd-4-8-di-laptop-toshiba-satellite-l310
title: Instalasi OpenBSD 4.8 di Laptop Toshiba Satellite L310
wordpress_id: 197
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

Cukup sulit proses instalasi OpenBSD 4.8 pada Laptop ini, karena hang sewaktu mau instal nya. Beberapa kali saya coba, ternyata tetap tidak bisa jalan. Lalu saya coba menggunakan UKC. Setelah dilihat dengan perintah "verbose", tampaknya "acpi" dan "pcibios" harus di disable agar bisa booting. gambarannya adalah sbb:

boot> boot /4.8/i386/bsd.rd -c
...........
UKC> disable acpi
UKC> disable pcibios
UKC> quit

ternyata benar, dengan di disable nya "acpi" dan "pcibios", maka bisa booting dengan lancar dan proses instalasi berjalan sebagai mana biasanya.

setelah instal, maka harus setting loadernya, karena saya punya linux dengan lilo nya, maka kini perlu setting lilo. Pada lilo.conf saya tambahkan baris dibawah ini agar bisa booting OpenBSD:
---------
other = /dev/sda3
label = OpenBSD
table = /dev/sda
---------

lalu jalankan perintah "lilo"

# lilo

Oke, kini sudah bisa pilih booting ke OpenBSD, maka untuk booting yang pertama ini, tetap harus men disable "acpi" dan "pcibios". gambarannya:

boot> boot /bsd.mp -c
...........
UKC> disable acpi
UKC> disable pcibios
UKC> quit

Setelah berhasil booting dan login sebagai root, kini saatnya saya edit binary kernel agar tiap booting tidak perlu repot lagi ke UKC. gambarannya:

# cd /
# cp bsd bsd-old
# cp bsd.mp bsd

# config -e -o bsd.new /bsd
ukc> disable acpi
ukc> disable pcibios
ukc> quit

# mv bsd.new bsd
# reboot

Kini sudah bisa booting dengan normal ke OpenBSD.

SELESAI.
