---
author: muntaza
comments: true
date: 2011-05-25 09:24:33+00:00
layout: post
link: https://muntaza.wordpress.com/2011/05/25/openbsd-sebagai-desktop-dengan-gnome/
slug: openbsd-sebagai-desktop-dengan-gnome
title: OpenBSD sebagai Desktop dengan Gnome
wordpress_id: 296
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

Bismillah,

ini adalah pengalaman saya menginstall Gnome pada OpenBSD 4.9 dan, Insya Allah, akan bisa juga dilakukan pada OpenBSD rilis berikitnya.

pertama, tentukan $PKG_PATH untuk links mirror terdekat, dan $PKG_CACHE untuk tempat menyimpan file instalasi. Edit .profile pada home direktori dan buat direktori khusus untuk menampung file yang akan di download
contoh:

[sourcecode languange="bash" wraplines="false"]

$ mkdir ~/paket

$ cat .profile  
# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
# sh/ksh initialization

PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/local/lib/libreoffice/ure/bin:/usr/local/jre-1.7.0/bin:.
PKG_PATH=http://ftp.itb.ac.id/pub/OpenBSD/4.9/packages/i386/
JAVA_HOME=/usr/local/jre-1.7.0
JAVACMD=/usr/local/jre-1.7.0/bin/java
PKG_CACHE=/home/muntaza/paket/
export PKG_CACHE JAVA_HOME JAVACMD PATH HOME TERM PKG_PATH
[/sourcecode]

lalu log out, lalu log in lagi dan cek isi variable $PKG_PATH dan $PKG_CACHE

[sourcecode languange="bash" wraplines="false"]
$ echo $PKG_PATH
http://ftp.itb.ac.id/pub/OpenBSD/4.9/packages/i386/
$ echo $PKG_CACHE
/home/muntaza/paket/
[/sourcecode]

PKG_PATH saya set ke mirror terdekat saya, yaitu http://ftp.itb.ac.id dan PKG_CACHE di /home/muntaza/paket/

lalu buat list file yang akan di install, saya membuatnya dalam sebuat file, sehingga akan menginstall Gnome dengan sekali perintah. file tersebut berisi sebagai berikut:

[sourcecode languange="bash" wraplines="false"]
$ cat install_gnome.sh                                                                                                       
#!/bin/sh
#install gnome pada OpenBSD 4.9

pkg_add -i -vv gnome-session
pkg_add -i -vv gdm
pkg_add -i -vv metacity
pkg_add -i -vv gnome-panel
pkg_add -i -vv nautilus
pkg_add -i -vv gnome-terminal
pkg_add -i -vv gnome-control-center
pkg_add -i -vv gnome-menus
pkg_add -i -vv gnome-settings-daemon
pkg_add -i -vv gnome-themes
pkg_add -i -vv gnome-themes-extras
pkg_add -i -vv gnome-utils
pkg_add -i -vv gnome-applets2
pkg_add -i -vv gnome-system-monitor
pkg_add -i -vv gnome-nettool
[/sourcecode]

untuk menginstall Gnome, cukup ketik:
[sourcecode languange="bash" wraplines="false"]
$ chmod u+x install_gnome.sh                                                                                                 
$ sudo install_gnome.sh      
[/sourcecode]

lalu, setelah selesai instalasi, edit ~/.xinitrc, masukkan "exec gnome-session", log out atau reboot, lalu login lagi, dan, Insya Allah, Gnome sudah terinstall.

untuk menjalankan gdm, edit /etc/rc.conf.local, masukkan gdm pada rc_scripts seperti contoh ini:
[sourcecode languange="bash" wraplines="false"]
$ cat /etc/rc.conf.local
rc_scripts="dbus_daemon avahi_daemon avahi_dnsconfd gdm saslauthd"

[/sourcecode]


Walhamdulillah.

Muhammad Muntaza bin Hatta
Paringin, Kab. Balangan, Prov. Kalimantan Selatan, Indonesia



Sumber: http://www.gabsoftware.com/tips/tutorial-install-gnome-desktop-and-gnome-display-manager-on-openbsd-4-8/
