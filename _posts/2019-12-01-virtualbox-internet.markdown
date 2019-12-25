---
layout: post
title:  "Konfigurasi Virtualbox agar Virtual OS bisa mengakses internet"
date:   2019-12-01 12:26:56 +0800
categories: virtualbox
---

# Bismillah,

[Virtualbox]() saya gunakan untuk menginstall Operating System saat
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

1. Buat interface bridge.

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

2. Setting di Mesin Virtual

Klik "Settings" -> "Network" -> "Bridged Adapter", pilih interface tap11
seperti gambar dibawah ini:

![Gambar1](/assets/virtualbox1.png)

![Gambar2](/assets/virtualbox2.png)



{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

{% highlight text %}
{% endhighlight %}

# Alhamdulillah
