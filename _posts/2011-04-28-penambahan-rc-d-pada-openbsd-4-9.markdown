---
author: muntaza
comments: true
date: 2011-04-28 08:27:33+00:00
layout: post
link: https://muntaza.wordpress.com/2011/04/28/penambahan-rc-d-pada-openbsd-4-9/
slug: penambahan-rc-d-pada-openbsd-4-9
title: Penambahan rc.d pada OpenBSD 4.9
wordpress_id: 269
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
tags:
- Openbsd
---

Bismillah, 

Pada rilis OpenBSD 4.9, ada penambahan direktori rc.d, yaitu direktori tempat script program server yang diinstall dari paket atau port. sebelumnya, apabila kita menginstall suatu paket server, misalnya squid, kita harus menulis script untuk menjalankan squid ini di rc.local agar tiap booting, squid jalan. contohnya sebagai berikut:

/etc/rc/local
`

# Add your local startup actions here.
echo -n ' squid'; /usr/local/sbin/squid

`

pada contoh diatas, kita menjalankan squid setiap reboot (booting ulang). Setiap ada penambahan paket server, misalnya postgresql, kita perlu menulis script untuk mengaktifkannya di /etc/rc.local

Pada rilis 4.9 ini, ada konsep baru tentang paket server ini, dengan direktori rc.d di /etc. sebuah paket akan datang dengan script yang akan mengisi /etc/rc.d. misalnya kita menginstall squid, akan ada script /etc/rc.d/squid, untuk menjalankan squid (tentu seletah membuat dir cache) kita ketik:

`
/etc/rc.d/squid start
`

untuk menstop

`
/etc/rc.d/squid stop
`

untuk reload

`
/etc/rc.d/squid reload
`

begitu juga misalnya kita menginstall postgresql, maka akan ada script /etc/rc.d/postgresql dan seterusnya.

Begitu paket terinstall, tidak akan start tiap booting ulang sebelum ditambah ke variable rc_scripts di /etc/rc.conf

contoh:


/etc/rc.conf
`
rc_scripts="dbus_daemon cupsd"
`

maka saat booting ulang, akan dieksekusi perintah
/etc/rc.d/cupsd start
/etc/rc.d/dbus_daemon start

untuk menjalankan paket server cupsd dan dbus_daemon

sehingga paket squid dan postgresql yang misalnya kita install tadi tidak termasuk yang di jalankan saat reboot. Untuk menjalankan, kita hanya perlu mengedit rc.conf pada variable rc_scripts

/etc/rc.conf
`
rc_scripts="dbus_daemon cupsd postgresql squid"
`

ini adalah sebuah kelebihan openbsd, dalam arti tidak akan ada paket yang start automatis tanpa sepengetahuan admin.

Paket server dijalankan dengan berurutan pada saat booting, dan pada saat shutdown, di stop dengan urutan dari belakang. Jadi pada susunan diatas, kita menjalankan postgresql lalu squid, sedang saat shutdown, squid lebih dulu di stop baru postgresql.

Akhir kata Bagi admin yang tidak ingin menggunakan rc.d, tetap tersedia rc.local untuk ditulis sendiri oleh admin yang bersangkutan sehingga seharusnya admin selalu mengerti apa yang ia perbuat.

Walhamdulillah

Muhammad Muntaza bin Hatta

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Subhanahu Wa Ta’ala memudahkan saya untuk tinggal di Kota Banjarbaru.

sumber:
diakses-tanggal-2011-04-28   
http://www.openbsd.org/cgi-bin/man.cgi?query=rc.conf&apropos=0&sektion=0&manpath=OpenBSD+Current&arch=i386&format=html

diakses-tanggal-2011-04-28   
http://www.openbsd.org/cgi-bin/man.cgi?query=rc.d&apropos=0&sektion=8&manpath=OpenBSD+Current&arch=i386&format=html
