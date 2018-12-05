---
author: muntaza
comments: true
date: 2011-10-13 02:11:31+00:00
layout: post
link: https://muntaza.wordpress.com/2011/10/13/network-time-protocol-dengan-openbsd-openntpd/
slug: network-time-protocol-dengan-openbsd-openntpd
title: Network Time Protocol dengan OpenBSD OpenNTPD
wordpress_id: 324
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

Bismillah,

Ini adalah setting penggunaan Network Time Protocol dengan OpenNTPD yang tersedia di OpenBSD. Aplikasi ini digunakan untuk mensingkronkan waktu pada komputer server. Pada penggunaan jangka panjang, jam yang ada di komputer bisa berubah, jadi perlu terus-menerus di singkronkan dengan Time server di Internet untuk menjaga waktu di komputer kita tetap presisi.

Di OpenBSD, tersedia OpenNTPD yang akan kita gunakan sebagai client dan juga server bagi local clientnya. di bawah ini langkah yang saya lakukan:

1. cek status ntp di komputer

[sourcecode languange="bash" wraplines="false"]
$ ps ax | grep ntp 
26900 p0  R+/1    0:00.00 grep ntp

[/sourcecode]

terlihat bahwa openNTPD belum jalan di komputer ini, lalu saya edit file /etc/ntpd.conf dengan setting ini:

[sourcecode languange="bash" wraplines="false"]
$ cat /etc/ntpd.conf | grep -v "^#" 

listen on 10.0.0.1
servers pool.ntp.org
sensor *

[/sourcecode]

hanya dengan tiga baris diatas, yang penjelasannya sebagai berikut:
- listen on 10.0.0.1 => berarti OpenNTPD akan berjalan sebagai time server dan mendengarkan di IP 10.0.0.1
- server pool.ntp.org => berarti alamat time server di internet yang kita gunakan
- sensor * => gunakan sensor yang tersedia bila ada

selanjutnya, saya coba menjalankan OpenNTPD yang outputnya ke terminal

[sourcecode languange="bash" wraplines="false"]
$ sudo /usr/sbin/ntpd -s -d
Password:
listening on 10.0.0.1
ntp engine ready
reply from xxx.134.1.10: offset -0.009891 delay 0.016349, next query 9s
set local clock to Thu Oct 13 09:54:41 CIT 2011 (offset -0.009891s)
reply from xxx.118.24.8: offset 0.008909 delay 0.017080, next query 8s
reply from xxx.89.31.13: offset 0.134570 delay 0.033521, next query 9s
reply from xxx.118.24.8: offset -0.001688 delay 0.054221, next query 6
^Cntp engine exiting
Terminating

[/sourcecode]

terlihat bahwa OpenNTPD bisa berjalan dengan baik, kita saatnya di jalankan sebagai server di belakang layar (tidak menampilkan output ke terminal), 

[sourcecode languange="bash" wraplines="false"]

$ ps ax | grep ntp
24518 p0  R+/1    0:00.00 grep ntp

$ sudo /usr/sbin/ntpd -s 
Password:

$ ps ax | grep ntp
22421 ??  Ss      0:00.01 ntpd: dns engine (ntpd)
23583 ??  Ss      0:00.02 ntpd: ntp engine (ntpd)
22794 ??  Ss      0:00.00 ntpd: [priv] (ntpd)
27512 p0  R+/0    0:00.00 grep ntp

[/sourcecode]

terlihat bahwa OpenNTPD sudah jalan, dengan option "-s" maka akan menyebabkan OpenNTPD langsung mengoreksi jam di komputer begitu ia di jalankan, dan agar OpenNTPD selalu jalan bila booting ulang, maka perlu di tambahkan setting ke file /etc/rc.conf.local seperti ini:

[sourcecode languange="bash" wraplines="false"]
$ cat /etc/rc.conf.local | grep ntp

ntpd_flags="-s"         # enabled during install

[/sourcecode]

sekian dari saya, semoga bermanfaat bagi Unix User, Walhamdulillah

Abu Husnul Khatimah Muhammad Muntaza bin Hatta bin Ahmad

Catatan: Semoga Allah memudahkan saya untuk tinggal di kota Banjarbaru.
