---
author: muntaza
comments: true
date: 2011-01-25 08:31:46+00:00
layout: post
link: https://muntaza.wordpress.com/2011/01/25/squid-di-openbsd/
slug: squid-di-openbsd
title: squid di OpenBSD
wordpress_id: 211
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

ringkasan cara pakai squid di OpenBSD 4.8:

1. install squid:
pkg_add squid-2.7.STABLE9-snmp

2. edit squid.conf untuk menempatkan dir cache:
cache_dir ufs /var/squid/cache 1000 16 256

3. edit squid.conf untuk izinkan akses dari local network:
acl localnet src 192.168.0.0/24 # RFC1918 possible internal network
http_access allow localnet
http_access deny all

4. edit squid.conf untuk listen di 127.0.0.1 port 3128 dan transparan:
http_port 127.0.0.1:3128 transparent

5. buat direktori cache dan rubah kepemilikan nya ke _squid:
squid -z
chown -R _squid:_squid /var/squid

5. jalankan squid
squid

catatan: setiap perubahan setting di /etc/squid/squid.conf, restart squid:
squid -k reconfigure

6. untuk pf, belokkan paket dari localnet ke internet port 80 ke 127.0.0.1 port 3128

$int_if="ste1"
$localnet="192.168.0.0/24"
pass in quick on $int_if proto tcp from $localnet to any port 80 \

rdr-to lo0 port 3128





semoga bermanfaat.

Muhammad Muntaza bin Hatta
Dari Provinsi Kalimantan Selatan
