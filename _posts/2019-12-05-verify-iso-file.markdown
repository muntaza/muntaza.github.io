---
layout: post
title:  "Verifikasi file instalasi Arch Linux dan CentOS 8.0"
date:   2019-12-05 12:26:56 +0800
categories: ssh
---

# Bismillah,

Kembali saya menuliskan catatan saya terkait verifikasi file iso yang
kita download dari Internet. Sebelum proses instalasi, kita perlu
memastikan bahwa file yang telah berhasil kita download itu adalah
file yang sama persis dengan yang di sediaan distro Linux kita. Dalam
contoh ini, saya melakukan verifikasi terhadap file iso Arch Linux dan
CentOS 8.0

## Verifikasi ISO Arch Linux

OK, kita downlaod file ISO Arch Linux dengan perintah wget. Disini saya
mendownload dari salah satu mirror di Indonesia.

{% highlight text %}
$ wget -c http://suro.ubaya.ac.id/archlinux/iso/2019.12.01/archlinux-2019.12.01-x86_64.iso
--2019-12-23 20:19:32--  http://suro.ubaya.ac.id/archlinux/iso/2019.12.01/archlinux-2019.12.01-x86_64.iso
Resolving suro.ubaya.ac.id (suro.ubaya.ac.id)... 203.114.224.252
Connecting to suro.ubaya.ac.id (suro.ubaya.ac.id)|203.114.224.252|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 670040064 (639M) [application/octet-stream]
Saving to: ‘archlinux-2019.12.01-x86_64.iso’

archlinux-2019.12.01-x86 100%[===============================>] 639,00M  1,90MB/s    in 6m 56s

2019-12-23 20:26:30 (1,53 MB/s) - ‘archlinux-2019.12.01-x86_64.iso’ saved [670040064/670040064]
{% endhighlight %}

Kemudian, download file md5sum nya.

{% highlight text %}
$ wget -c http://suro.ubaya.ac.id/archlinux/iso/2019.12.01/md5sums.txt
--2019-12-31 09:58:58--  http://suro.ubaya.ac.id/archlinux/iso/2019.12.01/md5sums.txt
Resolving suro.ubaya.ac.id (suro.ubaya.ac.id)... 203.114.224.252
Connecting to suro.ubaya.ac.id (suro.ubaya.ac.id)|203.114.224.252|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 145 [text/plain]
Saving to: ‘md5sums.txt’

md5sums.txt                100%[=======================================>]     145  --.-KB/s    in 0s

2019-12-31 09:59:00 (3,45 MB/s) - ‘md5sums.txt’ saved [145/145]
{% endhighlight %}

Verifikasi md5 file isonya.

{% highlight text %}
$ md5sum -c md5sums.txt --ignore-missing
archlinux-2019.12.01-x86_64.iso: OK
{% endhighlight %}

Nah, terlihat kalau sudah __OK__ file iso nya. Kita download file iso.sig

{% highlight text %}
$ wget -c http://suro.ubaya.ac.id/archlinux/iso/2019.12.01/archlinux-2019.12.01-x86_64.iso.sig
{% endhighlight %}

Selanjutnya, verifikasi dengan __GPG__. Kita download public key nya sekalian memverifikasi iso nya.

{% highlight text %}
$ gpg --keyserver-options auto-key-retrieve --verify archlinux-2019.12.01-x86_64.iso.sig
gpg: assuming signed data in 'archlinux-2019.12.01-x86_64.iso'
gpg: Signature made Sun 01 Dec 2019 05:08:27 PM WITA
gpg:                using RSA key 4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC
gpg: requesting key 7F2D434B9741E8AC from hkp server keys.gnupg.net
gpg: key 7F2D434B9741E8AC: 2 duplicate signatures removed
gpg: key 7F2D434B9741E8AC: 50 signatures not checked due to missing keys
gpg: key 7F2D434B9741E8AC: public key "Pierre Schmitz <pierre@archlinux.de>" imported
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   1  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: depth: 1  valid:   1  signed:   0  trust: 1-, 0q, 0n, 0m, 0f, 0u
gpg: next trustdb check due at 2024-11-12
gpg: Total number processed: 1
gpg:               imported: 1
gpg: Good signature from "Pierre Schmitz <pierre@archlinux.de>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 4AA4 767B BC9C 4B1D 18AE  28B7 7F2D 434B 9741 E8AC
{% endhighlight %}

Terlihat bahwa key belum trusted, disini saya sign dulu key nya.

{% highlight text %}
$ gpg --sign-key 7F2D434B9741E8AC

pub  rsa2048/7F2D434B9741E8AC
     created: 2011-04-10  expires: never       usage: SC
     trust: unknown       validity: unknown
sub  rsa2048/E9B9D36A54211796
     created: 2011-04-10  expires: never       usage: E
[ unknown] (1). Pierre Schmitz <pierre@archlinux.de>


pub  rsa2048/7F2D434B9741E8AC
     created: 2011-04-10  expires: never       usage: SC
     trust: unknown       validity: unknown
 Primary key fingerprint: 4AA4 767B BC9C 4B1D 18AE  28B7 7F2D 434B 9741 E8AC

     Pierre Schmitz <pierre@archlinux.de>

Are you sure that you want to sign this key with your
key "Muhammad Muntaza <muhammad@muntaza.id>" (C618BBE52188BDF7)

Really sign? (y/N) y
{% endhighlight %}

Verifikasi setelah public key di sign.

{% highlight text %}
$ gpg --verify archlinux-2019.12.01-x86_64.iso.sig
gpg: assuming signed data in 'archlinux-2019.12.01-x86_64.iso'
gpg: Signature made Sun 01 Dec 2019 05:08:27 PM WITA
gpg:                using RSA key 4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   2  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: depth: 1  valid:   2  signed:   0  trust: 2-, 0q, 0n, 0m, 0f, 0u
gpg: next trustdb check due at 2024-11-12
gpg: Good signature from "Pierre Schmitz <pierre@archlinux.de>" [full]
{% endhighlight %}

Nah, terlihat kalau file _ISO_ Arch Linux ini sudah Benar. Alhamdulillah


## Verifikasi ISO CentOS Linux

CentOS versi 8.0 saya download file ISO nya.

{% highlight text %}
$ wget -c http://kartolo.sby.datautama.net.id/Centos/8.0.1905/isos/x86_64/CentOS-8-x86_64-1905-boot.iso
--2019-12-23 20:44:14--  http://kartolo.sby.datautama.net.id/Centos/8.0.1905/isos/x86_64/CentOS-8-x86_64-1905-boot.iso
Resolving kartolo.sby.datautama.net.id (kartolo.sby.datautama.net.id)... 123.255.202.74, 2403:ba00:602::1e
Connecting to kartolo.sby.datautama.net.id (kartolo.sby.datautama.net.id)|123.255.202.74|:80... connected.
HTTP request sent, awaiting response... 206 Partial Content
Length: 559939584 (534M), 499114598 (476M) remaining [application/octet-stream]
Saving to: ‘CentOS-8-x86_64-1905-boot.iso’

CentOS-8-x86_64-1905-boot.iso     100%[++++++======================================================>] 534,00M   475KB/s    in 8m 52s

2019-12-23 20:53:07 (916 KB/s) - ‘CentOS-8-x86_64-1905-boot.iso’ saved [559939584/559939584]
{% endhighlight %}

Download file Checksum nya.

{% highlight text %}
$ wget -c http://kartolo.sby.datautama.net.id/Centos/8.0.1905/isos/x86_64/CHECKSUM.asc
--2019-12-23 20:39:45--  http://kartolo.sby.datautama.net.id/Centos/8.0.1905/isos/x86_64/CHECKSUM.asc
Resolving kartolo.sby.datautama.net.id (kartolo.sby.datautama.net.id)... 123.255.202.74, 2403:ba00:602::1e
Connecting to kartolo.sby.datautama.net.id (kartolo.sby.datautama.net.id)|123.255.202.74|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1171 (1,1K) [text/plain]
Saving to: ‘CHECKSUM.asc’

CHECKSUM.asc                      100%[============================================================>]   1,14K  --.-KB/s    in 0
s

2019-12-23 20:39:45 (31,5 MB/s) - ‘CHECKSUM.asc’ saved [1171/1171]
{% endhighlight %}

Verifikasi file CHECKSUM.asc dengan _GPG_

{% highlight text %}
$ gpg --keyserver-options auto-key-retrieve --verify CHECKSUM.asc
gpg: Signature made Mon 23 Sep 2019 07:24:37 PM WITA
gpg:                using RSA key 05B555B38483C65D
gpg: requesting key 05B555B38483C65D from hkp server keys.gnupg.net
gpg: key 05B555B38483C65D: 1 signature not checked due to a missing key
gpg: key 05B555B38483C65D: public key "CentOS (CentOS Official Signing Key) <security@centos.org>" imported
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   2  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: depth: 1  valid:   2  signed:   0  trust: 2-, 0q, 0n, 0m, 0f, 0u
gpg: next trustdb check due at 2024-11-12
gpg: Total number processed: 1
gpg:               imported: 1
gpg: Good signature from "CentOS (CentOS Official Signing Key) <security@centos.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 99DB 70FA E1D7 CE22 7FB6  4882 05B5 55B3 8483 C65D
{% endhighlight %}

Tandatangani juga public key nya.


{% highlight text %}
$ gpg --sign-key 05B555B38483C65D

pub  rsa4096/05B555B38483C65D
     created: 2019-05-03  expires: never       usage: SC
     trust: unknown       validity: unknown
[ unknown] (1). CentOS (CentOS Official Signing Key) <security@centos.org>


pub  rsa4096/05B555B38483C65D
     created: 2019-05-03  expires: never       usage: SC
     trust: unknown       validity: unknown
 Primary key fingerprint: 99DB 70FA E1D7 CE22 7FB6  4882 05B5 55B3 8483 C65D

     CentOS (CentOS Official Signing Key) <security@centos.org>

Are you sure that you want to sign this key with your
key "Muhammad Muntaza <muhammad@muntaza.id>" (C618BBE52188BDF7)

Really sign? (y/N) y
{% endhighlight %}

Verifikasi ulang setelah di tandatangani.

{% highlight text %}
$ gpg  --verify CHECKSUM.asc
gpg: Signature made Mon 23 Sep 2019 07:24:37 PM WITA
gpg:                using RSA key 05B555B38483C65D
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   3  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: depth: 1  valid:   3  signed:   0  trust: 3-, 0q, 0n, 0m, 0f, 0u
gpg: next trustdb check due at 2024-11-12
gpg: Good signature from "CentOS (CentOS Official Signing Key) <security@centos.org>" [full]
{% endhighlight %}

OK, file CHECKSUM.asc nya sudah benar. Kita lihat isi file ini.

{% highlight text %}
$ cat CHECKSUM.asc
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

# CentOS-8-x86_64-1905-boot.iso: 559939584 bytes
SHA256 (CentOS-8-x86_64-1905-boot.iso) = a7993a0d4b7fef2433e0d4f53530b63c715d3aadbe91f152ee5c3621139a2cbc
# CentOS-8-x86_64-1905-dvd1.iso: 7135559680 bytes
SHA256 (CentOS-8-x86_64-1905-dvd1.iso) = ea17ef71e0df3f6bf1d4bf1fc25bec1a76d1f211c115d39618fe688be34503e8
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBXYirdQW1VbOEg8ZdAQigchAAj+LbZtV7BQTnfB3i+fzECuomjsTZE8Ki
zUs9fLA67aayBL1KiavIzURMgjqj/+dXWr73Kv49pELngrznPlEPOclCaPkAKSe0
V2Nj56AUhT/tHGcBoNvD0UrC0nCObMLx6PI2FDEozEELyQR32Syjtb0y5CDnxRvX
6JeGWPWQsf+jXdZS/GUUh39XR5va5YAwues0qLfqNf7nfUk07tmU0pcCG+vRN13H
45av+1/49zbxn4Y/Km2AaAbmqX8LlQpppVYE2K5V73YsG3o6eSU1DwjDijQHYPOK
ZUixjbhh5xkOzvhv5HUETvPncbnOez+xLwDPFAMFz/jX/4BgLWpA1/PM/3xcFFij
qXBlZh+QLWm1Z8UCBftDc+RqoktI460cqL/SsnOyHmQ+95QLt20yR46hi3oZ6/Cv
cUdXaql3iCNWZUvi27Dr8bExqaVaJn0zeDCItPWUA7NwxXP2TlGs2VXC4E37HQhZ
SyuCQZMrwGmDJl7gMOE7kZ/BifKvrycAlvTPvhq0jrUwLvokX8QhoTmAwRdzwGSk
9nS+BkoK7xW5lSATuVYEcCkb2fL+qDKuSBJMuKhQNhPs6rN5OEZL3gU54so7Jyz9
OmR+r+1+/hELjOIsPcR4IiyauJQXXgtJ28G7swMsrl07PYHOU+awvB/N9GyUzNAM
RP3G/3Z1T3c=
=HgZm
-----END PGP SIGNATURE-----
{% endhighlight %}

Terakhir, verifikasi file _ISO_ dengan sha256sum.

{% highlight text %}
$ sha256sum -c CHECKSUM.asc --ignore-missing
CentOS-8-x86_64-1905-boot.iso: OK
sha256sum: WARNING: 20 lines are improperly formatted
{% endhighlight %}

file _ISO_ CentOS Linux sudah __benar__.

Semoga tulisan ini bermanfaat, terkhusus
bagi yang mengalami error saat instalasi, bisa di coba validasi dan verifikasi
file iso yang di download, karena bisa jadi file _ISO_ nya tidak sama
dengan yang di publish oleh Distro nya. Setelah verifikasi, kita
bisa meyakini file _ISO_ yang kita Download benar-benar __OK__.


# Alhamdulillah
