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

-   [SYN Flood](https://en.wikipedia.org/wiki/SYN_flood)

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
    address yang berasal dari Indonesia, 
    [Authentication](https://www.muntaza.id/openbsd/ssh/2018/12/09/public-key-only-ssh-openbsd.html) 
    yang digunakan
    hanya __public key__, tidak bisa dengan Password.
1.  Setelah Admin login ssh ke Firewall, Admin bisa ssh ke Server Database
    secara langsung. Akses ssh oleh Admin dengan Password Authentication, bukan __public
    key Authentication__, karena di asumsikan tidak ada local user yang melakukan
    __ssh bruteforce__ ke Server Database (analisa ini perlu di tinjau
    kembali).
1.  SSL certificate yang digunakan bukan dari 
    [Let's Encrypt](https://letsencrypt.org/), 
    sehingga Server
    Database tidak perlu membuka/mengizinkan IP address dari luar Indonesia
    dalam rangka verifikasi Let's Encrypt.
1.  Port yang di buka di Server Database hanya port 22 dan port 443.
1.  Fungsi [NAT](https://en.wikipedia.org/wiki/Network_address_translation) 
    di aktifkan di Firewall, sehingga IP Public hanya ada di
    Firewall sedangkan Server Database menggunakan IP Private.
1.  Server Database menyediakan Name Server local dengan NSD.
1.  System Firewall mempunyai fitur:
    -   Anti DDOS
    -   Anti [Reverse Telnet](https://www.hackingtutorials.org/networking/hacking-netcat-part-2-bind-reverse-shells/)
    -   Anti SYN Flood
    -   Anti [URPF-Failed](https://www.juniper.net/documentation/en_US/junos/topics/concept/unicast-rpf-understanding.html)
    -   Anti X11 Remote connections
    -   Blacklist IP Address
    -   Whithlist IP Address 
1.  Server Database bisa mengakses Github dan DNS Google.
1.  Server Database bisa di scan oleh Qualys SSL Labs. 



# Gambar Analis Design Firewall

![network diagram](/assets/pf2.png)
    

# Firewall OpenBSD PF

Baik lah, saya akan tampil kan secara perlahan dari file /etc/pf.conf dan
akan saya coba jelaskan maknanya. Pada bagian akhir, akan saya tampilkan file
tersebut secara keseluruhan.

```text
#	$Id: pf.conf_gateway,v 1.9 2015/01/05 05:37:27 muntaza Exp $
#	$OpenBSD: pf.conf,v 1.53 2014/01/25 10:28:36 dtucker Exp $
```
Tanda __#__ bermakna komentar, tidak di proses oleh pf


```text
# macros
ext_if = "axe0"
int_if = "axe1"

server = "10.0.0.3"
tcp_services = "https"

laptop_admin = "192.168.0.1"
local = "ssh"
```
Pendefinisian variable


```text
# options
set skip on lo
```

Localhost tidak di filter oleh pf.



```text
# match rules
match out on $ext_if inet from $server to any nat-to $ext_if:0
```

Fungsi NAT

# filter rules
block return	# block stateless traffic

# block ip attacker
table <ip_attacker> persist file "/etc/ip_attacker"
block in quick from <ip_attacker>

table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/ip_indonesia"

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port ssh \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

# izinkan website Qualys melakukan scan kualitas SSL
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state


pass out on $int_if inet proto tcp to $server \
    port $tcp_services


# izinkan dari firewall ke server
pass out on $int_if inet proto tcp to $server \
    port 22


# izinkan akses ke luar dari server menuju IP External
table <ip_safe> persist file "/etc/ip_safe"
pass in on $int_if inet
pass out on $ext_if inet to <ip_safe>



block in quick from urpf-failed to any	# use with care

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010













```text
#	$Id: pf.conf_gateway,v 1.9 2015/01/05 05:37:27 muntaza Exp $
#	$OpenBSD: pf.conf,v 1.53 2014/01/25 10:28:36 dtucker Exp $

# macros
ext_if = "axe0"
int_if = "axe1"

server = "10.0.0.3"
tcp_services = "https"

laptop_admin = "192.168.0.1"
local = "ssh"

# options
set skip on lo

# match rules
match out on $ext_if inet from $server to any nat-to $ext_if:0

# filter rules
block return	# block stateless traffic

# block ip attacker
table <ip_attacker> persist file "/etc/ip_attacker"
block in quick from <ip_attacker>

table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/ip_indonesia"
 
pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port ssh \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

# izinkan website Qualys melakukan scan kualitas SSL
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state


pass out on $int_if inet proto tcp to $server \
    port $tcp_services


# izinkan dari firewall ke server
pass out on $int_if inet proto tcp to $server \
    port 22


# izinkan akses ke luar dari server menuju IP External
table <ip_safe> persist file "/etc/ip_safe"
pass in on $int_if inet 
pass out on $ext_if inet to <ip_safe>



block in quick from urpf-failed to any	# use with care

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010
```




# Penutup


# Alhamdulillah


Daftar Pustaka

- [OpenBSD PF FAQ](https://www.openbsd.org/faq/pf/)
