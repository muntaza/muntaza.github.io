---
author: muntaza
comments: true
date: 2011-12-27 01:27:23+00:00
layout: post
link: https://muntaza.wordpress.com/2011/12/27/perbaiki-jam-di-server-linux/
slug: perbaiki-jam-di-server-linux
title: Perbaiki jam di server Linux
wordpress_id: 323
tags:
- Linux
---

Bismillah,
ini adalah pengalaman jam error pada server linux, server ini telah hidup selama 32 hari lebih, dan menjalankan ntpd dari ntp.org 

saya cek dengan program 
[sourcecode languange="bash" wraplines="false"]
date
[/sourcecode]
ternyata jamnya tertinggal 2 jam, waduh... kacau nih... he... he...
saya cek login dengan perintah 
[sourcecode languange="bash" wraplines="false"]
last | head
[/sourcecode]
untuk mencek kalau-kalau ada login yang aneh, ternyata tidak ada, jadi mungkin memang servernya lagi err... OK, langsung ke solusi yang saya terapkan, stop ntpd server dengan perintah 
[sourcecode languange="bash" wraplines="false"]
sudo /etc/rc.d/rc.ntpd stop
[/sourcecode]
lalu saya start manual untuk mensingkronkan dengan server OpenNTD saya dengan perintah 
[sourcecode languange="bash" wraplines="false"]
sudo /usr/sbin/ntpd -g -q
[/sourcecode]
setelah selesai, saya start lagi server ntpd nya 
[sourcecode languange="bash" wraplines="false"]
sudo /etc/rc.d/ntpd start
[/sourcecode]

selesai,
walhamdulillah, semoga Allah Rabbuna Jalla Wa 'Ala memudahkan saya tinggal di Kota Banjarbaru
