---
author: muntaza
comments: true
date: 2011-12-27 02:16:59+00:00
layout: post
link: https://muntaza.wordpress.com/2011/12/27/dhcp-server-pada-openbsd/
slug: dhcp-server-pada-openbsd
title: DHCP server pada OpenBSD
wordpress_id: 327
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

Bismillah, 

Cerita berawal dari suatu masa yang lalu, saya pernah melihat dengan dua mata saya (raitu fii aini) he... he... yaitu berkumpulnya sekelompok orang, yang mengkoneksikan banyak laptop ke sebuah server tertentu, jumlah laptopnya mencapai 40 buah lebih, dan IP per buah laptop di setting manual... he...he.. betapa capeknya si pengelola server ini, dan kacaunya lagi, mungkin saja ada IP yang sama pada dua laptop, he..he.. Alangkah baiknya kalau ini diatasi dengan DHCP, sehingga tidak perlu si pengelola server setting satu-satu, dan Insya Allah tidak ada IP sama untuk 2 komputer.

Iya, selesai cerita sudah, kini masuk ke setting. Saya menggunakan OpenBSD 4.8 saat ini, dan menjalankan DHCP server di OpenBSD tersebut. settingnya sebagai berikut:

1. Untuk menjalankan DHCP dari awal, edit /etc/rc.conf.local
[sourcecode languange="bash" wraplines="false"]
$ cat /etc/rc.conf.local | grep dhcp
dhcpd_flags="re0"       # for normal use: ""

[/sourcecode]

re0 adalah nama interface jaringan yang akan digunakan untuk dhcp server.

2. Edit file konfigurasinya di /etc/dhcpd.conf, sesuaikan dengan kebutuhan
[sourcecode languange="bash" wraplines="false"]
$ cat /etc/dhcpd.conf | grep -v "^#"

option  domain-name "example.com";
option  domain-name-servers 192.168.9.1;

subnet 192.168.9.0 netmask 255.255.255.0 {
        option routers 192.168.9.1;

        range 192.168.9.32 192.168.9.220;

        host static-client {
                hardware ethernet XX:df:a4:e4:bb:13;
                fixed-address 192.168.9.230;
        }
}

[/sourcecode]


penjelasan setting diatas
[sourcecode languange="bash" wraplines="false"]
option  domain-name "example.com";
option  domain-name-servers 192.168.9.1;

[/sourcecode]
menyatakan bahwa domain ini bernama example.com dan dns server local di 192.168.9.1

[sourcecode languange="bash" wraplines="false"]
subnet 192.168.9.0 netmask 255.255.255.0
[/sourcecode]
menyatakan bahwa alamat jaringan 192.168.9.0 dengan netmask 255.255.255.0

[sourcecode languange="bash" wraplines="false"]
        option routers 192.168.9.1;

        range 192.168.9.32 192.168.9.220;
[/sourcecode]
menyatakan bahwa default gateway ada di 192.168.9.1 dan IP yang tersedia untuk clien dari 192.168.9.32 sampai 192.168.9.220


3. setelah setting diatas, tentunya disesuaikan dengan kebutuhan, lalu restart servernya.

Sekian sedikit penjelasan yang saya bisa sumbangkan, Walhamdulillah. Semoga Allah Rabbuna Jalla wa 'Ala memudahkan saya untuk tinggal di kota Banjarbaru
