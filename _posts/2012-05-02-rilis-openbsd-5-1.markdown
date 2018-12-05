---
author: muntaza
comments: true
date: 2012-05-02 03:55:30+00:00
layout: post
link: https://muntaza.wordpress.com/2012/05/02/rilis-openbsd-5-1/
slug: rilis-openbsd-5-1
title: Rilis OpenBSD 5.1
wordpress_id: 356
categories:
- Firewall
- kisah muhammad muntaza
- Networking
- OpenBSD
- PF
tags:
- Openbsd
---

OpenBSD 5.1 sudah bisa di download sejak hari ini, tanggal 2 Mei 2012. berita lengkap bisa di cek di http://openbsd.org/51.html 

untuk download, dialamat ini http://ftp.openbsd.org/pub/OpenBSD/5.1/

Catatan khusus bagi user yang masih menggunakan OpenBSD PF versi 4.8 dan 4.9, yang akan mengupdrade ke OpenBSD PF versi 5.1, untuk membolehkan akses FTP dari user LAN dengan perintah "divert-to" menggantikan perintah "rdr-to" sebagai berikut:

pass in quick on $int_if inet proto tcp to port 21 divert-to 127.0.0.1 port 8021

selengkapnya ada di http://www.openbsd.org/faq/pf/ftp.html

Install Ulang atau Upgrade.
Saya memiliki cara pandang tersendiri tentang upgarade dan install ulang. Saya memilih untuk Install Ulang dalam selang 1 tahun, yaitu di Bulan Desember dengan rilis November. Adapun untuk rilis Mei, saya hanya melakukan update kernel dengan cara di http://muntaza.wordpress.com/2011/01/13/compile-kernel-openbsd-4-8-stable/ 

setelah muncul rilis November, solusi untuk upgrade dari versi genap (November) misal 4.6 ke versi 4.8, tidak disarankan dan tidak disupport oleh develover. Maka Install Ulang adalah solusinya. Catat semua konfigurasi pada server saat ini, back-up file yang dianggap penting, lalu INSTALL ULANG. 

Adapun kalau saat ini server anda telah berada di versi 5.0, tidak masalah untuk melakukan UPGRADE ke versi 5.1, dan saya ucapkan selamat melakukan UPGRADE, he... he...

Bila server anda adalah versi 4.9 kebawah, INSTALL ULANG adalah solusinya, dan saya Ucapkan selamat melakukan INSTALL ULANG, he... he...


