---
author: muntaza
comments: true
date: 2011-02-16 02:49:16+00:00
layout: post
link: https://muntaza.wordpress.com/2011/02/16/openbsd-wireless-setting/
slug: openbsd-wireless-setting
title: OpenBSD Wireless Setting
wordpress_id: 217
categories:
- linux
- OpenBSD
---

Bismillah,

Koneksi Wireless dari laptop yang terinstall OpenBSD 4.9-beta

laptop Wed Feb 16 $ dmesg |head -2
OpenBSD 4.9-beta (GENERIC.MP) #754: Thu Jan 20 17:49:26 MST 2011
todd@i386.openbsd.org:/usr/src/sys/arch/i386/compile/GENERIC.MP

Asumsi:

a. DNS server adalah local caching only nameserver, sesuaikan dengan DNS anda, ganti di /etc/resolv.conf

b. NWID atau di Linux disebut ESSID adalah nama jaringan yang di set di Wireless Access Point, di sini adalah "NAMA JARIANGAN"

c. default gateway 192.168.0.1

d. bila menggunakan DHCP Server, maka DNS server, default gateway, dan IP akan diset Otomatis

Langkah Koneksi

1. cek wireless yang tersedia

laptop Wed Feb 16 $ dmesg | grep Wireless
wpi0 at pci4 dev 0 function 0 "Intel PRO/Wireless 3945ABG" rev 0x02: apic 2 int 17 (irq 11), MoW1, address 00:1f:3c:8a:1c:46

2. install firmware wpi

$ sudo pkg_add http://damien.bergamini.free.fr/packages/openbsd/wpi-firmware-3.2.tgz

karena site ini sekarang down, diganti dengan:
http://www.weirdnet.nl/openbsd/firmware/

jadi perintahnya menjadi:
$ sudo pkg_add http://www.weirdnet.nl/openbsd/firmware/wpi-firmware-3.2.tgz

3. buat script untuk konek di ~/bin dengan nama wireless_obsd.sh

--------------------------------------------
#!/bin/sh
#connect ke jaringan wireless
#m.muntaza@gmail.com

ifconfig wpi0 up
ifconfig wpi0 nwid "NAMA JARINGAN" wpakey "password_wpa"

#dhclient wpi0

#config manual

ifconfig wpi0 192.168.0.190
route add default 192.168.0.1
echo "nameserver 192.168.0.1" > /etc/resolv.conf
---------------------------------

4. mulai koneksi

$ sudo ~/bin/wireless_obsd.sh

5. verifikasi setting

laptop Wed Feb 16 $ ifconfig wpi0
wpi0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
lladdr 00:1f:3c:8a:1c:46
priority: 4
groups: wlan egress
media: IEEE802.11 autoselect (DS1 mode 11g)
status: active
ieee80211: nwid "NAMA JARINGAN" chan 6 bssid 00:27:19:c0:0f:fc 19dB wpakey <not displayed> wpaprotos wpa1,wpa2 wpaakms psk wpaciphers tkip,ccmp wpagroupcipher tkip
inet6 fe80::21f:3cff:fe8a:1c46%wpi0 prefixlen 64 scopeid 0x2
inet 192.168.0.190 netmask 0xffffff00 broadcast 192.168.0.255

laptop Wed Feb 16 $ route -n show -inet
Routing tables

Internet:
Destination        Gateway            Flags   Refs      Use   Mtu  Prio Iface
default            192.168.0.1        UGS        2    18516     -    12 wpi0
127/8              127.0.0.1          UGRS       0        0 33200     8 lo0
127.0.0.1          127.0.0.1          UH         1       45 33200     4 lo0
192.168.0/24       link#2             UC         1        0     -     4 wpi0
192.168.0.1        00:21:97:0a:b5:dc  UHLc       2     6908     -     4 wpi0
224/4              127.0.0.1          URS        0        0 33200     8 lo0

laptop Wed Feb 16 $ cat /etc/resolv.conf
nameserver 192.168.0.1

laptop Wed Feb 16 $ arp -an
? (192.168.0.1) at 00:21:97:0a:b5:dc on wpi0

6. Saat ini sudah terkoneksi ke "NAMA JARINGAN" wireless. cara lain adalah dengan dhcp, uncomment dhclient wpi0 dan comment config manual, atau ketik:

$ sudo dhclient wpi0

maka konfigurasi IP akan didapatkan via DHCP server.

sebagai tambahan, bila ingin otomatis tiap boot langsung konek, kita bisa menuliskan di file-file config di /etc yaitu file /etc/hostname.wpi0, /etc/mygate, dan /etc/resolv.conf. edit ketiga file ini dengan contoh di bawah ini:

$ cat /etc/hostname.wpi0                                                       
inet 192.168.0.2 255.255.255.0 NONE nwid "NAMA JARINGAN" wpakey "password_wpa"

$ cat /etc/mygate                                                              
192.168.0.1

$ cat /etc/resolv.conf                                                         
lookup file bind
nameserver 192.168.0.1



Daftar Pustaka:

http://www.openbsd.org/cgi-bin/man.cgi?query=wpi&apropos=0&sektion=0&manpath=OpenBSD+4.7&arch=i386&format=html tanggal 16 Pebruari 2011

Walhamdulillah

Ditulis di Paringin, oleh:

_Al-Faqiir ilaa maghfiroti robbihi _Abu Husnul Khatimah Muhammad Muntaza bin Hatta bin Ahmad

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Rabbuna Jalla Wa 'Ala memudahkan saya untuk tinggal di Kota Banjarbaru.
