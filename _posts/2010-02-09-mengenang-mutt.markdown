---
author: muntaza
comments: true
date: 2010-02-09 04:08:07+00:00
layout: post
link: https://muntaza.wordpress.com/2010/02/09/mengenang-mutt/
slug: mengenang-mutt
title: Mengenang Mutt
wordpress_id: 131
categories:
- OpenBSD
---

[sourcecode language="text"]
--------------
Tulisan dibawah ini adalah kenangan masa muda saya yang suka menggunankan Mutt sebagai email clien he..he..

dan disaat sudah agak tua ehm... kayaknya cukup thunderbird ajah. Kecuali ada kesempatan dan waktu untuk belajar lagi.. he..he... Tulisan dibawah ini tidak saya rubah, tetap seperti tanggal terakhir di edit, 07-08-2005. Hanya
saja bahwa saya kini tinggal di Paringin City, Prov. KAL-SEL, Indonesia dengan email m.muntaza@gmail.com

catatan:
pada Mutt (mutt-1.4.2.3 di Slackware 13.0);
Pada baris "set crypt_autosign=yes" diganti dengan "set pgp_autosign=no"
tambahan "set record="/home/muntaza/.mutt/send-email""

--------------
Mutt+GnuPG+Msmtp dengan TLS pada OpenBSD

Copyright (C) 2005 muhammad muntaza bin hatta
license: BSD
vers.  : 1.0.2
date   : 23 juli 2005

update : 07 agustus 2005
Pemeriksaan kembali penulisan untuk mencari salah ketik.

e-mail : m_muntaza &lt;at&gt; telkom (dot) net
address: Banjarmasin city, prov. KAL-SEL, Indonesia
===============================================================================

Dokumen ini secara sederhana membahas konfigurasi Mutt dengan GnuPG dan Msmtp. Konfigurasi ini penulis jalankan pada OpenBSD dan berfungsi dengan baik. Pada Operating System Gnu/Linux tentunya dapat juga dijalankan.

Kalau server email anda tidak mendukung tls, anda dapat menonaktifkannya pada setting di ~/.msmtprc. Sebagai tambahan, penggunaan encryption memperlambat proses kirim dan download email sampai 4x daripada tanpa encryption. Tapi saya adalah pecinta encryption .....

mohon maaf kalau dokomennya kurang teratur, pada edisi yang akan datang akan penulis usahakan lebih baik lagi.

Langsung aja yah 

Hal pertama yang harus di pastikan adalah GnuPG telah terinstall dan anda telah memiliki sepasang kunci, publik key dan private key. Sebagai tambahan, penulis menggunakan Openbsd 3.6

0. KONFIGURASI MUTT

Mutt yang ada pada penulis adalah versi 1.5.6i. pada configurasi mutt, secara default tls untuk POP3 sudah diaktifkan. Jadi kita hanya mengedit file konfigurasi mutt pada bagian yang diperlukan saja.

A. Buat direktori .mutt pada homedir anda
$ mkdir ~/.mutt

Direktori ini akan menanpung file configurasi.

B. copy kan file configurasi gnupg yang ada didirektori /usr/local/example/mutt/gpg.rc ke direktori .mutt pada homedir anda
$ cp /usr/local/example/mutt/gpg.rc ~/.mutt/
$ cd ~/.mutt

edit file tersebut dengan "sed" agar sesuai dengan letak gpg pada OpenBSD
$ sed -e "/\/usr\/bin/s/\/usr\/bin/\/usr\/local\/bin/g" gpg.rc &gt; ls-1
$ cp ls-1 gpg.rc

pada GNU/Linux tidak perlu melakukan perintah diatas, karena gpg sudah berada pada /usr/bin/gpg.

C. Buat file ~/.muttrc
$ grep -v "^#" /etc/mutt/Muttrc &gt;&gt; ~/.muttrc

edit file tersebut dengan menambahkan configurasi dibawah ini dan rubah sesuai dengan account email dan domain anda.


file: ~/.muttrc
--------------------------------------------------------------------------------
ignore "from " received content- mime-version status x-status message-id
ignore sender references return-path lines

macro index \eb '/~b ' 'search in message bodies'

macro index \cb |urlview\n 'call urlview to extract URLs out of a message'
macro pager \cb |urlview\n 'call urlview to extract URLs out of a message'

macro generic &lt;f1&gt; "!less /usr/doc/mutt/manual.txt\n" "Show Mutt documentation"
macro index   &lt;f1&gt; "!less /usr/doc/mutt/manual.txt\n" "Show Mutt documentation"
macro pager   &lt;f1&gt; "!less /usr/doc/mutt/manual.txt\n" "Show Mutt documentation"

source ~/.mutt/gpg.rc

set arrow_cursor=yes
set fast_reply=yes
set from="saya@domain.com"
set pager_index_lines=12
set pop_delete=ask-yes
set pop_host=pop://pop3.domain.com:110
set pop_last=yes
set pop_user="saya"
set realname="nama saya sebenarnya"

set sendmail="/usr/local/bin/msmtp"
#http://www.google.co.id/search?q=msmtp

set sort=threads
set crypt_autosign=yes
-------------------------------------------------------------------------------



1. KONFIGURASI MSMTP

A. Cari msmtp pada www.google.co.id, download, dan extract. Versi yang ada pada penulis adalah 1.4.1. Konfigurasi dengan menyertakan dukungan openssl.

tidak lupa, baca file INSTALL dan doc/*

$ tar -xjvf msmtp-1.4.1.tar.bz
$ cd msmtp-1.4.1
$ ./configure --with-ssl=openssl
$ make
$ sudo make install

B. Buat file .msmtprc pada homedir anda, set permisi 0600.
$ touch ~/.msmtprc
$ chmod 0600 ~/.msmtprc

Edit file tersebut dengan configurasi dibawah ini, sesuaikan dengan account anda.


file: ~/.msmtprc
------------------------------------
port 25
protocol smtp

host smtp.domain.com
from saya@domain.com
tls on
tls_starttls on
tls_certcheck on
domain domain.com
------------------------------------


Penutup

Sekarang coba anda kirim email ke account anda sendiri dengan signature. Setelah terkirim, coba download mail tersebut (tekan "SHIFT+g").

Semoga dokumen ini ada manfaatnya, terutama bagi diri penulis pribadi. kritik dan saran dialamatkan ke e-mail penulis.
[/sourcecode]
