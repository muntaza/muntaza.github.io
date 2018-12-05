---
author: muntaza
comments: true
date: 2011-02-23 07:29:51+00:00
layout: post
link: https://muntaza.wordpress.com/2011/02/23/status-online-suatu-webserver/
slug: status-online-suatu-webserver
title: Status online suatu webserver
wordpress_id: 225
categories:
- linux
- OpenBSD
---

Bismillah,

saya ingin memcek status webserver yang saya kelola, online atau lagi down alias mati, bila saya sedang di rumah. Koneksi dari rumah adalah dengan GPRS, jadi perlu membuat suatu halaman kecil dengan script yang jalan tiap satu jam. halaman itu berisi tanggal dan waktu hidup server (date dan uptime). dibawah ini script yang saya gunakan:

----------------------------

#!/bin/sh
#copyright (c) 2011
#lisensi: BSD
#m.muntaza@gmail.com

( \
echo "<html>" ; \
echo "<body>" ; \

date ; \
echo "<br>" ; \
uptime; \

echo "</body>" ; \
echo "</html>" ; \
) > /var/www/htdocs/cek/cek.html

------------------------------

crontab untuk menjalankan script ini:

#script untuk membuat file cek.html
0 * * * * ~/bin/cek.sh

dari rumah saya cukup dengan hp GPRS ke:

http://alamatwebserver/cek/cek.html

Walhamdulillah

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Rabbuna Jalla Wa ‘Ala  memudahkan saya untuk tinggal di Kota Banjarbaru.
