---
layout: post
title:  "Firewall dengan OpenBSD PF bagian Kedua"
date:   2020-02-03 12:26:56 +0800
categories: pf
---

# Bismillah,

Sebagaimana yang saya tulis pada tutorial nftables bagian 
[keempat](https://www.muntaza.id/nftables/2020/01/30/nftables-keempat.html),
bahwa, walaupun sudah level 3, namun settings nftables tersebut
masih belum mampu melindungi server dari serangan:
-   [DDOS](https://en.wikipedia.org/wiki/Denial-of-service_attack#Distributed_DoS_attack)

    DDOS ini bahkan bisa saja hanya menggunakan tools semisal 
    [apache benchmark](https://blog.getpolymorph.com/7-tips-for-heavy-load-testing-with-apache-bench-b1127916b7b6),
    sehingga sangat perlu sebuah firewall memiliki fitur anti DDOS.

-   [SYN Attack](https://en.wikipedia.org/wiki/SYN_flood)

    SYN Attack ini termasuk kategori DDOS juga, sehingga sebuah firewall
    haruslah mampu menahan serangan jenis ini.

Di sini, saya akan melanjutkan tulisan saya sebelumnya tentang 
[pf firewall](https://www.muntaza.id/openbsd/2019/08/31/openbsd-pf-cloud.html),
walaupun pada tulisan kali ini, akan saya ulang kembali beberapa hal yang telah 
saya sebutkan pada tulisan tersebut.

# Firewall Design

Saya awali dengan firewall design, ini pondasi awal system firewall ini. Setiap
system tentu memiliki kehutuhan yang berbeda, sehingga menghasilkan design yang
berbeda pula. Analis kebutuhan system firewall pada server yang saya contohkan
adalah sebagai berikut:



1.  Server Database berada di belakang Firewall.
1.  Local Client di belakang Firewall, tidak bisa mengakses internet 
1.  Akses Local Client ke Server Database secara langsung, tanpa firewall.
1.  Akses ssh oleh Admin dari Localnet ke Server Database secara langsung, tanpa
    firewall dengan Password Authentication.
1.  Akses ssh oleh Admin ke Firewall dari Internet, khusus hanya dari IP
    address yang berasal dari Indonesia, Authentication yang digunakan
    hanya __public key__, tidak bisa dengan Password.
1.  Setelah Admin login ssh ke Firewall, Admin bisa ssh ke Server Database
    secara langsung. Akses ssh oleh Admin dengan Password Authentication, bukan __public
    key Authentication__, karena di asumsikan tidak ada local user yang melakukan
    __ssh bruteforce__ ke Server Database (analisa ini perlu di tinjau
    kembali).
1.  SSL certificate yang digunakan bukan dari Let's Encrypt, sehingga Server
    Database tidak perlu membuka/mengizinkan IP address dari luar Indonesia
    dalam rangka verifikasi Let's Encrypt.
1.  Port yang di buka di Server Database hanya port 22 dan port 443.
1.  Fungsi NAT di aktifkan di Firewall, sehingga IP Public hanya ada di
    Firewall sedangkan Server Database menggunakan IP Private.
1.  Server Database menyediakan Name Server local dengan NSD.
1.  System Firewall mempunyai fitur:
    -   Anti DDOS
    -   Anti Reverse Telnet
    -   Anti SYN Flood
    -   Blacklist IP Address
    -   Whithlist IP Address 
1.  Server Database bisa mengakses Github dan DNS Google.
1.  Server Database bisa di scan oleh Qualys SSL Labs. 



Gambar Analis Design Firewall:

![network diagram](/assets/pf2.png)
    

# Penutup


# Alhamdulillah


Daftar Pustaka

- [OpenBSD PF FAQ](https://www.openbsd.org/faq/pf/)
