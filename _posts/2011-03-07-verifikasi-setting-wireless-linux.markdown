---
author: muntaza
comments: true
date: 2011-03-07 02:59:00+00:00
layout: post
link: https://muntaza.wordpress.com/2011/03/07/verifikasi-setting-wireless-linux/
slug: verifikasi-setting-wireless-linux
title: Verifikasi Setting Wireless Linux
wordpress_id: 248
categories:
- kisah muhammad muntaza
- linux
---

Bismillah,


Sebelum koneksi, scan jaringan wireless yang tersedia:

langkahnya; aktifkan wlan0

[sourcecode languange="bash"]
bash-4.1$ ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:1F:3C:8A:FF:FF
BROADCAST MULTICAST  MTU:1500  Metric:1
RX packets:0 errors:0 dropped:0 overruns:0 frame:0
TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

bash-4.1$ sudo /sbin/ifconfig wlan0 up
bash-4.1$ ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:1F:3C:8A:FF:FF
UP BROADCAST MULTICAST  MTU:1500  Metric:1
RX packets:0 errors:0 dropped:0 overruns:0 frame:0
TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
[/sourcecode]

dari tampilan diatas wlan0 sudah UP, lalu scan dengan perintah iwlist

[sourcecode languange="bash"]
bash-4.1$ sudo iwlist wlan0 scan
wlan0     Scan completed :
Cell 01 - Address: 00:27:19:C0:FF:FF
Channel:6
Frequency:2.437 GHz (Channel 6)
Quality=20/70  Signal level=-90 dBm
Encryption key:on
ESSID:"NAMA JARINGAN"
Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
Mode:Master
Extra:tsf=000000014d372181
Extra: Last beacon: 10768ms ago
IE: Unknown: 00174C505345204B616275706174656E2042616C616E67616E
IE: Unknown: 010482848B96
IE: Unknown: 030106
IE: Unknown: 050400010000
IE: IEEE 802.11i/WPA2 Version 1
Group Cipher : TKIP
Pairwise Ciphers (2) : TKIP CCMP
Authentication Suites (1) : PSK
Preauthentication Supported
[/sourcecode]

Disini terlihat bahwa ada satu jaringan "cell 01" dengan ESSID "NAMA JARINGAN",
ESSID inilah yang akan digunakan untuk koneksi.

setelah itu, cek status wireless dengan iwconfig

[sourcecode languange="bash"]
bash-4.1$ iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:off/any
Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm
Retry  long limit:7   RTS thr:off   Fragment thr:off
Power Management:off
[/sourcecode]

dan cek routing jaringan dan arp

[sourcecode languange="bash"]
bash-4.1$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
127.0.0.0       0.0.0.0         255.0.0.0       U     0      0        0 lo

bash-4.1$ arp -an

[/sourcecode]

di sini terlihat belum ada HW addres lain di arp dan routing masih standar lakukan koneksi dengan script pada tulisan sebelumnya sebelumnya, sesuai dengan tipe wireless yang tersedia, bila itu non-encript dan WEP, menggunakan wireless.sh, bila WPA dengan wpa.sh

disini dicontohkan dengan wpa.sh

[sourcecode languange="bash"]
bash-4.1$ sudo ~/bin/wpa.sh
[/sourcecode]

kemudian cek status wireless dengan iwconfig

[sourcecode languange="bash"]
bash-4.1$ iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:"NAMA JARINGAN"
Mode:Managed  Frequency:2.437 GHz  Access Point: 00:27:19:C0:FF:FF
Bit Rate=11 Mb/s   Tx-Power=15 dBm
Retry  long limit:7   RTS thr:off   Fragment thr:off
Power Management:off
Link Quality=34/70  Signal level=-76 dBm
Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
Tx excessive retries:0  Invalid misc:0   Missed beacon:0
[/sourcecode]

disini terlihat bahwa sudah terkoneksi ke Jaringan dengan ESSID "NAMA JARINGAN" lalu cek setting jaringan dengan ifconfig, route, arp, dan isi file /etc/resolv.conf

[sourcecode languange="bash"]
bash-4.1$ ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:1F:3C:8A:FF:FF
inet addr:192.168.0.190  Bcast:192.168.0.255  Mask:255.255.255.0
inet6 addr: fe80::21f:3cff:fe8a:ffff/64 Scope:Link
UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
RX packets:13 errors:0 dropped:0 overruns:0 frame:0
TX packets:27 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:1519 (1.4 Kb)  TX bytes:3745 (3.6 Kb)

bash-4.1$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.0.0     0.0.0.0         255.255.255.0   U     0      0        0 wlan0
127.0.0.0       0.0.0.0         255.0.0.0       U     0      0        0 lo
0.0.0.0         192.168.0.1     0.0.0.0         UG    0      0        0 wlan0

bash-4.1$ cat /etc/resolv.conf
nameserver 192.168.0.1

bash-4.1$ arp -an

bash-4.1$ host www.google.com
www.google.com is an alias for www.l.google.com.
www.l.google.com has address 74.125.235.52
www.l.google.com has address 74.125.235.50
www.l.google.com has address 74.125.235.48
www.l.google.com has address 74.125.235.49
www.l.google.com has address 74.125.235.51

bash-4.1$ arp -an
? (192.168.0.1) at 00:21:97:0a:FF:FF [ether] on wlan0

[/sourcecode]

dari setting diatas terlihat:
a. wlan0 sudah punya ip yaitu 192.168.0.190
b. routing sudah ok, jaringan 192.168.0.0/25 ada pada wlan0, default getway ke 192.168.0.1
c. /etc/resolv.conf berisi alamat name server
d. arp -an kosong sebelum ada koneksi, ketika coba keneksi ke gateway dengan cara mencek alamat www.google.com, lalu cek lagi arp -an, maka arp telah berisi MAC Address dari gateway.

Walhamdulillah


catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Tabaraka Wa Ta'ala memudahkan saya untuk tinggal di Kota Banjarbaru.



Daftar Pustaka:

Rusmanto, Ari Koeswoyo, Hendri Saptono, Kurniadi, Toto Harjendro. 2008. _Linux Network Setup Guide_. Jakarta: P.T. Dian Rakyat
