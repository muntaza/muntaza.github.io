---
author: muntaza
comments: true
date: 2011-02-23 08:10:53+00:00
layout: post
link: https://muntaza.wordpress.com/2011/02/23/back-up-postgresql-server/
slug: back-up-postgresql-server
title: Back up Postgresql server
wordpress_id: 233
categories:
- kisah muhammad muntaza
- linux
- Networking
- OpenBSD
- programming
tags:
- Linux
- Muhammad Muntaza
- Openbsd
---

Bismillah,

saya ingin membackup full database postgresql server tiap jam 0:0 setiap hari. Karena itu saya buat script untuk di jalankan oleh cron sebagai berikut

[sourcecode languange="bash"]
#!/bin/bash
#by muhammad muntaza
#m.muntaza@gmail.com
#c @ 2011
#GPL v3
#back_up data pada seluruh db di postgresql

TANGGAL=$(date +tanggal_%Y_%m_%d_jam_%H_%M)

/usr/local/pgsql/bin/pg_dumpall -f \

/home/muntaza/back_up/sql/data_$TANGGAL.sql \

-U user

[/sourcecode]

di crontab sebagai berikut:
[sourcecode languange="bash"]
0 0 * * * ~/bin/back_up_sql.sh
[/sourcecode]

Walhamdulillah.

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Rabbuna Jalla Wa ‘Ala  memudahkan saya untuk tinggal di Kota Banjarbaru.
