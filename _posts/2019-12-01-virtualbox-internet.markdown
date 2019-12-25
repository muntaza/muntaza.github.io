---
layout: post
title:  "Konfigurasi Virtualbox agar Virtual OS bisa mengakses internet"
date:   2019-12-01 12:26:56 +0800
categories: virtualbox
---

# Bismillah,

[Virtualbox](https://www.virtualbox.org/) saya gunakan untuk menginstall Operating System saat
saya mengembangkan aplikasi. Hal ini agar Laptop yang saya gunakan
dapat tetap dapat melakukan hal lain di luar programming, misalnya
mengetik surat dengan Libreoffice.

Saya mendeploy aplikasi pada Operating System OpenBSD, sedang kan
Laptop saya menggunakan Linux Mint. Agar saya dapat mencoba OpenBSD
tanpa perlu mensetting dual boot yang rumit, maka saya menggunakan
Virtualbox.

Hal penting yang harus ada di mesin virtual tersebut, adalah koneksi
internet. Sehingga, seolah-olah Laptop saya berfungsi sebagai
gateway ke internet bagi mesin virtual tadi.

- Buat interface [tuntap](https://en.wikipedia.org/wiki/TUN/TAP).

Saya menggunakan script ip_tap11.sh yang saya letakkan di ~/bin, berikut
isi script tersebut:

{% highlight text %}
#!/bin/bash

dev=tap11
ip=10.0.11.1/24
bc=10.0.11.255


ip tuntap del $dev mode tap
sudo ip tuntap add $dev mode tap user root
sudo ip link set $dev up
sudo ip address add $ip broadcast $bc dev $dev
ip address show $dev
{% endhighlight %}

Jalan kan script ini:

{% highlight text %}
$ sudo sh ~/bin/ip_tap11.sh
[sudo] password for muntaza:
6: tap11: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 52:1b:2b:09:cd:5f brd ff:ff:ff:ff:ff:ff
    inet 10.0.11.1/24 brd 10.0.11.255 scope global tap11
       valid_lft forever preferred_lft forever
{% endhighlight %}

Terlihat bahwa interface tap11 yang akan digunakan untuk bridge ke Virtualbox
sudah ready.

- Setting di Mesin Virtual

Klik "Settings" -> "Network" -> "Bridged Adapter", pilih interface tap11
seperti gambar dibawah ini:

![Gambar1](/assets/virtualbox1.png)

![Gambar2](/assets/virtualbox2.png)

- Setting Gateway

Kita bisa menggunakan IPTables agar packet bisa berpindah dari interface
wireless LAN wlp1s0 ke interface tap11. Berikut isi script ~/bin/iptables_nat.sh

{% highlight text %}
#! /bin/bash
echo "jalankan firewall"

IPTABLES=/sbin/iptables
INT_IF=tap11
EXT_IF=wlp1s0

$IPTABLES -F
$IPTABLES -X

#Aturan default
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P INPUT DROP

#Izin localhost
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -i $INT_IF -j ACCEPT

#Izin Packet dengan tanda ESTABLISHED
$IPTABLES -I INPUT 1 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


#Izin Packet Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward


#Table NAT
/sbin/iptables -t nat -A POSTROUTING -o $EXT_IF -j MASQUERADE
/sbin/iptables -A FORWARD -i $EXT_IF -o $INT_IF -m conntrack \
   --ctstate RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i $INT_IF -o $EXT_IF -j ACCEPT

echo
echo "iptables firewall is up `date`"
{% endhighlight %}

Penjelasan tentang script iptables_nat.sh ini, insyaAllah, akan
saya tulis pada kesempatan yang akan datang.

- Test Koneksi dari Virtual Mesin Operating System OpenBSD

Saya malakukan ping ke 8.8.8.8 dari Virtual Mesin dan Alhamdulillah
berhasil.

![Gambar3](/assets/virtualbox3.png)

Demikian penjelasan terkait koneksi dari Virtualbox ke Internet ini,
semoga bermanfaat.

# Alhamdulillah
