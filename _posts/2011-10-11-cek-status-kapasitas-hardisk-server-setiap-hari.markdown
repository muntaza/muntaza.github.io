---
author: muntaza
comments: true
date: 2011-10-11 04:22:39+00:00
layout: post
link: https://muntaza.wordpress.com/2011/10/11/cek-status-kapasitas-hardisk-server-setiap-hari/
slug: cek-status-kapasitas-hardisk-server-setiap-hari
title: Cek status kapasitas Hardisk server setiap hari
wordpress_id: 319
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
- opensolaris
---

Berikut ini saya tulis script untuk mencek isi hardisk dan mengirim email ke admin sekali tiap hari, yang dijalankan dengan cron:

[sourcecode languange="bash" wraplines="false"]
#!/bin/sh
#GPL

(/bin/df -h 
/bin/echo "" 
/usr/bin/last | /bin/head -20
/bin/echo "" 
/bin/date
/bin/echo "" 
/usr/bin/uptime) > /home/muntaza/hasil

/usr/bin/sleep 3

/usr/bin/mailx -s "laporan webserver" -r muntaza@mydomain \
-S smtp=10.0.0.1 my@example.com < /home/muntaza/hasil
[/sourcecode]

dijalankan dengan cron sekali sehari:

[sourcecode languange="bash" wraplines="false"]

46   12    *   *    *    ~/bin/mail.sh

[/sourcecode]

Walhamdulillah

Abu Husnul Khatimah Muhammad Muntaza bin Hatta

catatan: saya bercita-cita untuk tinggal di kota Banjarbaru,
semoga Allah Ta'ala memudahkan saya untuk tinggal di sana.
