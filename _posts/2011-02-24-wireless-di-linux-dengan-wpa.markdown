---
author: muntaza
comments: true
date: 2011-02-24 02:03:30+00:00
layout: post
link: https://muntaza.wordpress.com/2011/02/24/wireless-di-linux-dengan-wpa/
slug: wireless-di-linux-dengan-wpa
title: Wireless di Linux dengan WPA
wordpress_id: 239
categories:
- kisah muhammad muntaza
- linux
---

Bismillah,

saya menulis script untuk connect ke Wireless dengan WPA di Linux. saya tempatkan di ~/bin

wpa.sh

-------------------

#!/bin/sh
#connect wireless dengan wpa di linux
#m.muntaza@gmail.com
#(c) 2011 Muhammad Muntaza

ifconfig wlan0 up
wpa_passphrase "NAMA JARINGAN" passwordku > /etc/wpa_supplicant.conf
wpa_supplicant -c /etc/wpa_supplicant.conf -i wlan0 &>/dev/null &

ifconfig wlan0 192.168.0.190
route add default gw 192.168.0.1
echo "nameserver 192.168.0.1" > /etc/resolv.conf

-------------------

stop_wpa.sh

------------------

#!/bin/sh
#disconnect wireless dengan wpa di linux
#m.muntaza@gmail.com
#(c) 2011 Muhammad Muntaza

ifconfig wlan0 down
pkill wpa_supplicant

------------------

untuk men scan wireless Access Point yang tersedia:

$ sudo /sbin/ifconfig wlan0 up

$ sudo iwlist scan

untuk connect:

$ sudo ~/bin/wpa.sh

untuk disconnect:

$ sudo ~/bin/stop_wpa.sh

Walhamdulillah

sumber:

http://www.enterprisenetworkingplanet.com/netsecur/article.php/3594946/Linux-on-Your-WLAN-Configure-WPA.htm

http://www.google.co.id/search?q=wpa+linux

Rusmanto, Ari Koeswoyo, Hendri Saptono, Kurniadi, Toto Harjendro. 2008. _Linux Network Setup Guide_. Jakarta: P.T. Dian Rakyat

--

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah  Rabbuna Jalla Wa ‘Ala  memudahkan saya untuk tinggal di Kota Banjarbaru.
