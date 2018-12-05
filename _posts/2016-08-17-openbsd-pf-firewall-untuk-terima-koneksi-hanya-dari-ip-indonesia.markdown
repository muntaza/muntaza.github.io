---
author: muntaza
comments: true
date: 2016-08-17 03:17:27+00:00
layout: post
link: https://muntaza.wordpress.com/2016/08/17/openbsd-pf-firewall-untuk-terima-koneksi-hanya-dari-ip-indonesia/
slug: openbsd-pf-firewall-untuk-terima-koneksi-hanya-dari-ip-indonesia
title: OpenBSD PF Firewall untuk terima Koneksi hanya dari IP Indonesia
wordpress_id: 465
categories:
- Firewall
- Networking
- OpenBSD
- PF
---

Bismillah

Disini kembali saya mengupdate kembali tulisan saya yang lalu tentang PF Firewall dengan OpenBSD; yang mana hal ini bertujuan agar saya tidak lupa cara mensetting PF ini he...he..

Ada hal penting yang menurut saya bisa dilakukan untuk meningkatkan security pada mesin firewall; yaitu hanya mengizinkan blok IP dari Indonesia yang mengakses ke server kita. Apakah berpengaruh pada layanan online kita? Tergantung. Server kami yang saya sebagai administrator jaringannya hanya melayani pengguna dari Indonesia; mengapa saya harus buka akses ke seluruh Dunia... he.. he...

Untuk Pengguna PC/Laptop:
Tidak ada masalah; Insya Allah; karena IP Publik ISP di Indonesia ini sudah terdaftar pada blok IP yang di definisikan

Untuk pengguna Android:
Beberapa aplikasi; misalnya Opera Mini yang koneksinya melalui proxi tidak bisa koneksi ke server kami. Jadi hanya koneksi langsung dengan browser bawaan Android atau Google Chrome atau Opera Browser yang di terima server kami

Saya mengambil blok IP untuk wilayah indonesia di website ini
http://www.ipdeny.com/ipblocks/

OK; langsung ke konfigurasi PF yaitu isi file pf.conf
[sourcecode languange="text" wraplines="false"]
#	$Id: pf.conf_gateway,v 1.9 2015/01/05 05:37:27 muntaza Exp $
#	$OpenBSD: pf.conf,v 1.53 2014/01/25 10:28:36 dtucker Exp $

# macros
ext_if = "axe0"
int_if = "axe1"

server = "192.168.0.3"
tcp_services = "https"

laptop_admin = "192.168.0.1"
local = "ssh"

# options
set skip on lo

# match rules
match out on $ext_if inet from $server to any nat-to $ext_if:0

# filter rules
block return	# block stateless traffic

table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/ip_indonesia"
 
pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

pass out on $int_if inet proto tcp to $server \
    port $tcp_services


pass in on $int_if inet proto tcp from $laptop_admin to $int_if \
    port $local

pass out on $int_if inet proto tcp from $int_if to $laptop_admin \
    port $local


block in quick from urpf-failed to any	# use with care

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

[/sourcecode]

Perbadaan pada tulisan saya sebelumnya adalah adanya
setting ini:

[sourcecode languange="text" wraplines="false"]
table <ip_indonesia> persist file "/etc/ip_indonesia"
 
pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \

[/sourcecode]

yang bermakna bahwa hanya blok IP yang terdaftar pada file
 /etc/ip_indonesia yang dapat koneksi ke server file ini saya download di sini http://www.ipdeny.com/ipblocks/data/countries/id.zone


Kemudian; agar firewall mengizinkan kembali IP yang kedapatan melakuakan abusive; saya flush table abusive_hosts dengan file /home/muntaza/bin/flush.sh yang berisi:

[sourcecode languange="text" wraplines="false"]
/sbin/pfctl -t abusive_hosts -T show >> /home/muntaza/daftar
/sbin/pfctl -t abusive_hosts -T flush 1>> /home/muntaza/daftar \
     2>> /home/muntaza/daftar

[/sourcecode]

saya jalankan dengan cron tiap 1 (satu) menit. ini tambahan pada crontab:
[sourcecode languange="text" wraplines="false"]
# flush table pf
*       *       *       *       *       /bin/sh /home/muntaza/bin/flush.sh

[/sourcecode]

Sekian dari saya; Alhamdulillah


Muhammad Muntaza bin Hatta
