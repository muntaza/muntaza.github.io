---
author: muntaza
comments: true
date: 2011-02-24 06:24:21+00:00
layout: post
link: https://muntaza.wordpress.com/2011/02/24/wireless-di-linux/
slug: wireless-di-linux
title: Wireless di Linux
wordpress_id: 245
categories:
- kisah muhammad muntaza
- linux
- Networking
tags:
- Linux
- Muhammad Muntaza
---

Bismillah,

script yang saya buat untuk connect ke wireless akses point yang tanpa WPA atau tanpa encripsi. saya menulis ini untuk dokumentasi saja dan tidak menyarankan wireless tanpa di encript dengan WPA misalnya. di ~/bin/ dengan nama wireless.sh

scan dulu jaringan Wireless yang tersedia:

[sourcecode languange="bash"]
$ sudo /sbin/ifconfig wlan0 up

$ sudo iwlist scan
[/sourcecode]

masukkan nama jaringan yang tampil sebagai essid yang digunakan. disini contohnya adalah "NAMA JARINGAN"

[sourcecode languange="bash"]
#!/bin/bash

#untuk konek ke access point "NAMA JARINGAN"
echo -n "Setting wireless:"

ifconfig eth0 down
ifconfig wlan0 up

iwconfig wlan0 essid "NAMA JARINGAN" # key 1a1b1c1d1e (bila pakai WEP)
#dhclient wlan0

ifconfig wlan0 192.168.0.190
route add default gw 192.168.0.1
echo "nameserver 192.168.0.1" > /etc/resolv.conf

echo " OK"

[/sourcecode]

untuk connect

[sourcecode languange="bash"]
$ sudo ~/bin/wireless.sh
[/sourcecode]

Walhamdulillah


Daftar Pustaka:

Rusmanto, Ari Koeswoyo, Hendri Saptono, Kurniadi, Toto Harjendro. 2008. _Linux Network Setup Guide_. Jakarta: P.T. Dian Rakyat

---



catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah   Rabbuna Jalla Wa ‘Ala  memudahkan saya untuk tinggal di Kota Banjarbaru.
