---
author: muntaza
comments: true
date: 2009-08-19 06:04:47+00:00
layout: post
link: https://muntaza.wordpress.com/2009/08/19/software-tambahan-di-slackware-2/
slug: software-tambahan-di-slackware-2
title: Software Tambahan di Slackware
wordpress_id: 91
categories:
- linux
---

Pada Slackware 12.2 saya, saya install software tambahan, diantaranya 3 software dibawah ini. Proses instalasi dengan cara mengcompile source.

-

_**KMyMoney**_

-

download kmymoney di http://kmymoney2.sourceforge.net/index2.html

-

muntaza@pisang:~/Download$ tar -xjf dia-0.97.tar.bz2

muntaza@pisang:~/Download$ cd dia-0.97

muntaza@pisang:~/Download/dia-0.97$ ./configure

muntaza@pisang:~/Download/dia-0.97$ sudo make install

-

  


  


_**DIA**_

-

download dia di http://live.gnome.org/Dia/Download

-

muntaza@pisang:~/Download$ tar -xjf kmymoney2-0.8.9.tar.bz2

muntaza@pisang:~/Download$ cd kmymoney2-0.8.9

muntaza@pisang:~/Download/kmymoney2-0.8.9$ ./configure

muntaza@pisang:~/Download/kmymoney2-0.8.9$ sudo make install

-

  


_**postgresql 8.4.0**_

  


download di http://www.postgresql.org/ftp/source/v8.4.0/

-

muntaza@pisang:~/Download$ cat postgresql-8.4.0.tar.bz2.md5

MD5 (postgresql-8.4.0.tar.bz2) = 1f172d5f60326e972837f58fa5acd130

muntaza@pisang:~/Download$ md5sum postgresql-8.4.0.tar.bz2

1f172d5f60326e972837f58fa5acd130 postgresql-8.4.0.tar.bz2

-

muntaza@pisang:~/Download$ tar -xjf postgresql-8.4.0.tar.bz2

-

muntaza@pisang:~/Download$ cd postgresql-8.4.0

muntaza@pisang:~/Download/postgresql-8.4.0$ ./configure 1> /dev/null

muntaza@pisang:~/Download/postgresql-8.4.0$ gmake 1> /dev/null &

-

muntaza@pisang:~/Download/postgresql-8.4.0$ sudo su

Password:

root@pisang:/home/muntaza/Download/postgresql-8.4.0# gmake install 1> /dev/null

root@pisang:/home/muntaza/Download/postgresql-8.4.0# exit

root@pisang:/home/muntaza/Download/postgresql-8.4.0$ cd ..

-

  


Wallahu Ta'ala A'lam

  

