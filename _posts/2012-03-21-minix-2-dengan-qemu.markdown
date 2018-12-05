---
author: muntaza
comments: true
date: 2012-03-21 03:38:47+00:00
layout: post
link: https://muntaza.wordpress.com/2012/03/21/minix-2-dengan-qemu/
slug: minix-2-dengan-qemu
title: Minix 2 dengan Qemu
wordpress_id: 347
categories:
- kisah muhammad muntaza
- linux
- minix
- programming
---

Bismillah

Tulisan ini berkenaan dengan keinginan saya untuk belajar Operating System, dan belajar C prograamming, yang mana compiler C yaitu cc terdapat pada minix. Walaupun C compiler minix tersebut sangat sederhana, tapi sudah cukup untuk belajar dasar Bahasa C.

Baik, diawali dengan Instalasi Qemu pada Slackware 13.37 yang saya gunakan. Saya menginstall Qemu dengan scrip yang terdapat di http://slackbuilds.org karena sangat memudahkan dalam proses install dan uninstall dimasa yang akan datang.

Halaman download qemu di slackbuilds ada di http://slackbuilds.org/repository/13.37/system/qemu/

langkah-langkah instalasi qemu secara ringkas dari download source, compile sampai instalasi
[sourcecode languange="bash" wraplines="false"]
bash-4.1$ mkdir virtual
bash-4.1$ cd virtual/
bash-4.1$ wget -c http://slackbuilds.org/slackbuilds/13.37/system/qemu.tar.gz
.................

bash-4.1$
bash-4.1$ tar -xzvf qemu.tar.gz 
qemu/
qemu/qemu.SlackBuild
qemu/README
qemu/qemu.info
qemu/slack-desc

bash-4.1$ cd qemu
bash-4.1$ wget -c http://wiki.qemu.org/download/qemu-1.0.1.tar.gz
...................


bash-4.1$ ls
README  qemu-1.0.1.tar.gz  qemu.SlackBuild  qemu.info  slack-desc
bash-4.1$ sudo sh qemu.SlackBuild
.......................
.......................

bash-4.1$
bash-4.1$ sudo /sbin/installpkg /tmp/qemu-1.0.1-i486-1_SBo.tgz
[/sourcecode]

keterangan:
wget adalah alat untuk mendowload
sudo sh qemu.SlackBuild (compile source qemu)
sudo /sbin/installpkg /tmp/qemu-1.0.1-i486-1_SBo.tgz (install paket qemu)

Alhamdulillah qemu telah terinstall, saatnya mendowload minix2. Halaman yang berkaitan dengan minix2 ini ada di http://minix1.woodhull.com/  dan untuk qemu, telah tersedia image nya dari halaman http://minix1.woodhull.com/pub/demos-2.0/  lalu halaman http://oslab.hpclab.ceid.upatras.gr/software.php
dari situlah saya mendownload minix2 dengan langkah-langkah sebagai berikut:

[sourcecode languange="bash" wraplines="false"]
bash-4.1$ cd
bash-4.1$ cd virtual/
bash-4.1$ ls
qemu  qemu.tar.gz
bash-4.1$ wget -c http://oslab.hpclab.ceid.upatras.gr/files/2006/Minix_over_QEMU.tar
....................

bash-4.1$ ls
Minix_over_QEMU.tar  qemu  qemu.tar.gz
bash-4.1$ du -h Minix_over_QEMU.tar 
4.9M    Minix_over_QEMU.tar
bash-4.1$ tar -xf Minix_over_QEMU.tar 
bash-4.1$ ls
Minix_over_QEMU.run  Minix_over_QEMU.tar  qemu  qemu.tar.gz
bash-4.1$ sh Minix_over_QEMU.run 
.....................
.....................(yes) yes

bash-4.1$ qemu-system-i386 -version
QEMU emulator version 1.0,1, Copyright (c) 2003-2008 Fabrice Bellard
bash-4.1$ ls
Minix_over_QEMU  Minix_over_QEMU.run  Minix_over_QEMU.tar  qemu  qemu.tar.gz
bash-4.1$ qemu-system-i386 -monitor stdio Minix_over_QEMU/virtual_disk/hda.img
[/sourcecode]

keterangan:
wget mendownload Minix_over_QEMU.tar
tar mengextrak Minix_over_QEMU.tar
sh Minix_over_QEMU.run (mengeksekusi Minix_over_QEMU.run, mengetik 'yes' tanda setuju lisensi)
qemu-system-i386 -monitor stdio Minix_over_QEMU/virtual_disk/hda.img (menjalankan qemu)


berikut ini gambar screenshoot dari minix diatas qemu.
[![](http://muntaza.files.wordpress.com/2012/03/minix.png?w=300)](http://muntaza.files.wordpress.com/2012/03/minix.png)

selesai. Walhamdulillah. Semoga Allah Rabbuna Jalla Wa 'Ala Memudahkan saya untuk tinggal di Banjarbaru

ditulis oleh: Al faqir ilaa maghfirati rabbihi Abu Husnul Khatimah Muhammad Muntaza bin Hatta
