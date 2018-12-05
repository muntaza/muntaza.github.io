---
author: muntaza
comments: true
date: 2015-11-04 06:33:27+00:00
layout: post
link: https://muntaza.wordpress.com/2015/11/04/doas-pengganti-sudo-di-openbsd-5-8/
slug: doas-pengganti-sudo-di-openbsd-5-8
title: Doas pengganti Sudo di OpenBSD 5.8
wordpress_id: 457
categories:
- OpenBSD
tags:
- Openbsd
---

Bismillah,

Dalam tulisan kali ini, dalam rangka agar tidak kehilangan momen, hee. hee..
maka saya akan memaparkan penggunaan doas untuk mengeksekusi perintah sebagai
root di System Operasi OpenBSD.


SUDO

Perintah "sudo", yang lazim terdapat pada System Operasi Unix-like seperti Gnu/Linux dan lainnya, telah sangat familiar di gunakan oleh para administrator sistem. Hal itu dalam rangka mencegah terjadinya salah ketik sebagai root ketika melakukan kegiatan administrasi sistem.

konfigurasi sudo dilakukan dengan perintah visudo dan bila user tersebut masuk dalam group wheel, maka ia bisa menggunakan sudo. ini contoh baris configurasi sudo:


[sourcecode languange="bash" wraplines="false"]
%wheel ALL=(ALL) ALL
[/sourcecode]

ini contoh penggunaan sudo pada Slackware Gnu/Linux 14.1:

[sourcecode languange="bash" wraplines="false"]
bash-4.2$ uname -rsm
Linux 3.10.17-smp i686



bash-4.2$ ls -a /root/
ls: cannot open directory /root/: Permission denied
[/sourcecode]

pada perintah itu, terlihat bahwa user tidak bisa mengakses root home direktori.

[sourcecode languange="bash" wraplines="false"]
bash-4.2$ sudo ls -a /root/
Password:
.	       .cache	.gnupg		 .kde		  .rnd	    .xine
..	       .config	.gstreamer-0.10  .local		  .ssh	    .xsession-errors
.Xauthority    .dbus	.gvfs		 .mplayer	  .viminfo
.bash_history  .dmrc	.hplip		 .openoffice.org  .wine
bash-4.2$ 
[/sourcecode]


dengan menggunakan sudo, lalu mengisi password, maka user yang anggota group wheel bisa melihat root home direktori. 


DOAS

Okeh, setelah sedikit perkenalan sudo, maka dengan ini saya nyatakan bahwa sudo sudah dikeluarkan dari distribusi standar OpenBSD semenjak versi 5.8 ini dan sudo ini ditempatkan di package OpenBSD. bila Administrator masih ingin pakai sudo, maka bisa di install dengan perintah:

[sourcecode languange="bash" wraplines="false"]
$ /usr/sbin/pkg_add sudo  
[/sourcecode]


NAMUN, pada base (atau distribusi standar) OpenBSD, telah ada pengganti sudo yang lebih baik, yang dinakaman doas. he...he..., nama yang agak aneh..

Untuk yang mengerti OpenBSD, tahu bahwa OpenBSD adalah Operating System yang secara umum biasanya digunakan sebagai firewall. Jadi agak aneh, bila firewall menggunakan package yang di luar distribusi standar.... he...he.. (atau bahasa kasarnya menginstall sudo itu agak gimana gitu... he.. he..)

Dikarenakan sudah ada doas, maka System Administrator OpenBSD, harus menyesuaikan diri dengan perkembangan, agar tidak tertinggal.

Iya. langsung saya contohkan penggunaan doas yang 90% mirip sudo


[sourcecode languange="bash" wraplines="false"]
$ doas su                                                                                          
doas is not enabled.
[/sourcecode]

ups... ternyata ada yang salah, setelah saya teliti, dengan membaca manual page, yaitu doas(1) dan doas.conf(5), maka diketahui bahwa perlu ada file doas.conf di direktori /etc. Berdasarkan contoh di manual page doas.conf(5) maka saya buat file /etc/doas.conf dengan isi sebagai berikut:

[sourcecode languange="bash" wraplines="false"]
permit keepenv { ENV PS1 SSH_AUTH_SOCK } :wheel
permit nopass muntaza as root cmd /sbin/halt args -p
[/sourcecode]


makna konfigurasi diatas sederhana saja, yaitu:
1. izinkan anggota group wheel menggunakan doas dengan password 
2. izinkan user muntaza tanpa password mengeksekusi perintah /sbin/halt -p


ini contoh sesi saya menggunakan doas untuk melihat isi root home directory.

[sourcecode languange="bash" wraplines="false"]
$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza), 0(wheel)
$ ls /root/      
ls: /root/: Permission denied
$ doas ls /root/ 
Password:
.Xdefaults .cshrc     .cvsrc     .forward   .login     .profile   .ssh       mbox
$ date
Sun Oct 25 23:42:04 WITA 2015
$ doas ls /root/ 
Password:
Permission denied
$ date           
Sun Oct 25 23:42:11 WITA 2015
$                
$ uname -a    
OpenBSD vm_openbsd.muntaza.id 5.8 GENERIC#1170 amd64
[/sourcecode]


terlihat bahwa user muntaza, sebagai anggota group wheel dapat menggunakan doas dengan mengetikkan password. 


Khatimah
Afwan, mungkin ada pengguna sudo yang mengkritik doas, mengapa melakukan atau membuat sesuatu yang telah ada. Dalam tulisan saya diatas, ada yang tersurat dan ada yang tersirat. Bila anda seorang pengguna Unix-like yang mengerti security, tentu akan menangkap pesan tersirat yang membeberkan kelemahan sudo disisi pengguna OpenBSD. 
Wallahu a'lam.


sampai disini tulisan ini. Semoga bermanfaat khususnya untuk diri saya pribadi.
Alhamdulillah.


Muhammad Muntaza bin Hatta
