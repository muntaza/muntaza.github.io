---
author: muntaza
comments: true
date: 2011-01-13 08:36:30+00:00
layout: post
link: https://muntaza.wordpress.com/2011/01/13/compile-kernel-openbsd-4-8-stable/
slug: compile-kernel-openbsd-4-8-stable
title: compile kernel OpenBSD 4.8 -stable
wordpress_id: 204
categories:
- linux
- OpenBSD
---

tulisan ini berkernaan dengan cara mengupdate kernel OpenBSD. Setiap saat ada patch yang harus di tambahkan untuk meningkat kan securitas sistem OpenBSD kita, jadi kita harus me apply patch tersebut dan compile kernel. patch bisa di cek pada http://www.openbsd.org/errata.html

caranya:

1. Download sorce code kernel dan system

$ cd /home/hasan

$ wget -c http://ftp.openbsd.org/pub/OpenBSD/4.8/src.tar.gz

$ wget -c http://ftp.openbsd.org/pub/OpenBSD/4.8/sys.tar.gz

2. Ekstrak ke /usr/src

$ cd /usr/src

$ tar -xzvf /home/hasan/sys.tar.gz

$ tar -xzvf /home/hasan/src.tar.gz

3. update source code dengan CVS di direktori /usr/src (edisi 4.8 saat ini)

$ su

    
    # export CVSROOT=anoncvs@anoncvs1.ca.openbsd.org:/cvs
    
    
    # cvs -d$CVSROOT up -rOPENBSD_4_8 -Pd
    
    4. Compile dan install kernel
    
    
    # cd /usr/src/sys/arch/i386/conf
    # config GENERIC.MP
    # cd ../compile/GENERIC.MP
    # make clean
    # make depend
    # make
      ..........
    # make install


selesai sudah proses compile, lalu reboot.

Setelah reboot, kita akan pakai kernel terbaru. Walhamdulillah

ditulis di Paringin, Kab.Balangan,

oleh Abu Husnul Khatimah Muhammad Muntaza bin Hatta bin Ahmad

daftar pustaka:
http://www.openbsd.org/faq/faq5.html#Bld
http://www.openbsd.org/anoncvs.html



