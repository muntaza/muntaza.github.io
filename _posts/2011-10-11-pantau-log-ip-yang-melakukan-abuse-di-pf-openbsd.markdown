---
author: muntaza
comments: true
date: 2011-10-11 03:49:25+00:00
layout: post
link: https://muntaza.wordpress.com/2011/10/11/pantau-log-ip-yang-melakukan-abuse-di-pf-openbsd/
slug: pantau-log-ip-yang-melakukan-abuse-di-pf-openbsd
title: Pantau Log IP yang melakukan Abuse di PF OpenBSD
wordpress_id: 317
categories:
- kisah muhammad muntaza
- OpenBSD
---

Bismillah,

Dari tulisan saya sebelumnya, saya menulis tentang setting pf.conf untuk mencegah 
abuse yang dilakukan oleh pengguna layanan, seperti ini;

[sourcecode languange="bash" wraplines="false"]
table <abusive_hosts> persist
block in quick from <abusive_hosts>

pass in log (all) on $ext_if inet proto tcp from any to $ext_if port 80 \
	rdr-to $ip_web_server port 80 \
	queue http \
	flags S/SA synproxy state \
	(max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)
[/sourcecode]

dari setting diatas, tiap source IP hanya maksimal 100 koneksi ke Server kita,
dan 15 koneksi per 5 detik, bila melanggar aturan itu, akan dimasukkan ke table
abusive_hosts, dan semua koneksinya di putus.

semua IP yang berada di table abusive_hosts ini akan di blok oleh PF, jadi kita 
perlu mengclear IP yang telah berumur 1 jam di table ini.

dibawah ini satu script yang saya tulis untuk mencatat IP yang melakukan abuse, 
mengclear bila telah berumur 1 jam, dan mengirim email ke admin daftar IP tersebut:

[sourcecode languange="bash" wraplines="false"]
#!/bin/sh
#m.muntaza@gmail.com
#2011
#license: BSD

#program untuk mencatat host yang terblok oleh filter abuse
#dan mengclear bila sudah lewat 1 jam

#tiap satu jam dengan cron dijalankan, sekaligus mengirim email
#ke root data ip yang terblok

sudo pfctl -t abusive_hosts -T expire 3600
sudo pfctl -t abusive_hosts -T show -v >> /root/data_abuse
sudo pfctl -t abusive_hosts -T show -v > /root/data_abuse_mail

cat /root/data_abuse_mail \
| /usr/local/bin/mutt -s "data abuse mail" root
[/sourcecode]

script ini dinamai log_abuse.sh dan dijalankan dengan cron tiap 1 jam sekali

[sourcecode languange="bash" wraplines="false"]
# crontab -l| grep log_abuse

46      *       *       *       *       /root/log_abuse.sh

[/sourcecode]

sekian tulisan ini, semoga bermanfaat bagi user OpenBSD PF, walhamdulillah



Al faqir ilaa maghfirati rabbihi
Abu Husnul Khatimah Muhammad Muntaza bin Hatta

catatan: saya mempunyai cita-cita untuk tinggal di kota Banjarbaru, 
semoga Allah Ta'ala memudahkan saya untuk tinggal di sana
