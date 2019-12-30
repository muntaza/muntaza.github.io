---
layout: post
title:  "Instalasi Driver Espon L120 pada Arch Linux"
date:   2019-12-31 06:02:56 +0800
categories: printer
---

# Bismillah,

Pada Arch Linux, menginstall printer tidak semudah pada Linux Mint, yang hanya tinggal
pasang kabel USB saja. Kita perlu menginstall driver sesuai dengan jenis printer yang
kita gunakan.

Baiklah, kita mulai proses instalasinya.

Pada Arch Linux, masuk ke website [AUR](https://aur.archlinux.org/), ketik __L120__
pada kolom pencarian, seperti gambar berikut:

![AUR1](/assets/AUR1.png)

Setelah itu, tekan __Enter__ dan akan terlihat pilihan driver _Epson L120_ pada hasil pencarian, maka klik paket tersebut:

![AUR2](/assets/AUR2.png)

![AUR3](/assets/AUR3.png)

Nah, sekarang kita download script build tersebut dengan git:

{% highlight text %}
$ git clone https://aur.archlinux.org/epson-inkjet-printer-201310w.git
Cloning into 'epson-inkjet-printer-201310w'...
remote: Enumerating objects: 13, done.
remote: Counting objects: 100% (13/13), done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 13 (delta 1), reused 11 (delta 0)
Unpacking objects: 100% (13/13), done.
{% endhighlight %}

Kemudian masuk ke dalam direktori tersebut dan lakukan proses Compile dan Instalasi dengan perintah:

{% highlight text %}
$ makepkg -si --needed
{% endhighlight %}

Oh, iya, sebelumnya kita harus install juga cups dan system-config-printer sebagai antarmuka cupsnya.

{% highlight text %}
$ sudo pacman -Syu --needed cups system-config-printer
{% endhighlight %}

Verifikasi paket-paket yang berkaitan dengan printer.

{% highlight text %}
$ pacman -Q|grep -e cups -e printer
cups 2.3.1-1
cups-filters 1.26.0-1
epson-inkjet-printer-201310w 1.0.0-9
libcups 2.3.1-1
python-pycups 1.9.74-3
system-config-printer 1.5.12-2
{% endhighlight %}

Nah, sudah terinstal driver Epson L120 dan Software pendukungnya. Kita tinggal pasang
kabel USB ke Laptop saja, otomatis terdeteksi di laptop saya, sehingga tampil
di Print Settings seperti ini:

![AUR4](/assets/AUR4.png)

Selesai sudah proses instalasinya, dan telah saya coba melakukan print dan berhasil
dengan baik.

# Alhamdulillah
