---
layout: post
title:  "PF Firewall : Contoh implementasi"
date:   2019-08-31 12:26:56 +0800
categories: openbsd
---

# Bismillah,

Saya bermaksud mengulang kembali tulisan tentang OpenBSD PF Firewall
yang dulu pernah saya tulis di [sini](https://muntaza.wordpress.com/2016/08/17/openbsd-pf-firewall-untuk-terima-koneksi-hanya-dari-ip-indonesia/) dengan beberapa catatan tambahan, dengan harapan agar bermanfaat di kemudian hari.

Dibawah ini adalah diagram network sederhana, yang menggambarkan sebuah Virtual Machine (vm) yang punya 1 (satu) interface yang terhubung ke internet dengan IP Public.

![network diagram](/assets/pf1.png)

Kemudian, saya tampilkan full isi file pf.conf, yang akan saya jelaskan isinya.

{% highlight text %}
#       $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

ext_if=vio0
services = "{ 22, 443, 4443 }"

set skip on lo
block return    # block stateless traffic

table <ip_safe> persist file "/etc/ip_safe"
pass out to <ip_safe>


table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/id.zone"

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $services  \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)



#Pass SSL Labs
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port 443


# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild


{% endhighlight %}

Baiklah, saya coba memulai menjelaskannya:

{% highlight text %}
ext_if=vio0
{% endhighlight %}

Interface yang digunakan, yaitu vio0

{% highlight text %}
services = "{ 22, 443, 4443 }"
{% endhighlight %}

Port yang di izinkan untuk di akses dari Internet, tinggal di tambahkan port lainnya, kalau di perlukan.

{% highlight text %}
set skip on lo
{% endhighlight %}

Jangan filter interface lo untuk akses network local. Biasanya lo ini diberi alamat 127.0.0.1/8

{% highlight text %}
block return
{% endhighlight %}

Secara default, block semua koneksi keluar dan masuk, termasuk icmp, sehingga server tidak terkena serangan [PoD](https://en.wikipedia.org/wiki/Ping_of_death)

{% highlight text %}
table <ip_safe> persist file "/etc/ip_safe"
{% endhighlight %}

Buat daftar IP dengan fungsi 'table', dengan nama ip_safe, yang mengambil dari daftar IP di file /etc/ip_safe

{% highlight text %}
pass out to <ip_safe>
{% endhighlight %}

Izinkan akses dari VM ke luar hanya menuju IP di daftar ip_safe yang telah kita buat diatas.

{% highlight text %}
table <abusive_hosts> persist
{% endhighlight %}

Persiapkan daftar kosong untuk IP yang melakukan tindakan DOS, IP yang terperangkap akan masuk ke daftar ini.

{% highlight text %}
block in quick from <abusive_hosts>
{% endhighlight %}

Kalau ternyata ada yang terperangkap, block total dari IP tersebut.

{% highlight text %}
table <ip_indonesia> persist file "/etc/id.zone"
{% endhighlight %}

Daftar IP dari Indonesia. Saya mengambilnya dari [sini](http://www.ipdeny.com/ipblocks/)

{% highlight text %}
pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $services  \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)
{% endhighlight %}

Izinkan akses ke port yang telah di definisikan di atas 'hanya' dari IP yang berasal dari Indonesia, gunakan fungsi Synproxy, dan kalau ada IP yang mencoba melakukan [DOS](https://en.wikipedia.org/wiki/Denial-of-service_attack), maka masukkan IP itu ke daftar abusive_hosts serta putuskan koneksinya.

Serangan yang di cegah dengan konfigurasi ini:
- [Syn Flood](https://www.imperva.com/learn/application-security/syn-flood/)
- [Reverse Telnet](https://en.wikipedia.org/wiki/Reverse_connection)


{% highlight text %}
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port 443
{% endhighlight %}

Izinkan koneksi dari SSL Lab untuk melakukan test konfigurasi TLS server kita. Bagian ini tidak mesti, hanya merupakan saran saja.

{% highlight text %}
block return in on ! lo0 proto tcp to port 6000:6010
{% endhighlight %}

Tolak koneksi remote ke port 6000 sampai 6010

{% highlight text %}
block return out log proto {tcp udp} user _pbuild
{% endhighlight %}

User _pbuild tidak perlu koneksi internet. Baris ini sebenarnya tidak diperlukan, karena firewall ini sudah di setting untuk default deny, yaitu semua di block kecuali yang di izinkan.


Kemudian, table abusive_hosts diatas perlu di clear setiap 1 (satu) jam sekali, yang mana saya menggunakan cron untuk keperluan itu.

{% highlight text %}
0       *       *       *       *       /bin/sh /home/muntaza/bin/flush.sh
{% endhighlight %}

Adapun isi file flush.sh adalah sebagai berikut:

{% highlight text %}
/sbin/pfctl -t abusive_hosts -T show >> /home/muntaza/daftar
/sbin/pfctl -t abusive_hosts -T flush 1>> /home/muntaza/daftar \
     2>> /home/muntaza/daftar
{% endhighlight %}

Maknanya, masukkan daftar yang ada saat ini di table abusive_hosts ke file /home/muntaza/daftar, lalu hapus isi daftar abusive_hosts.

# Alhamdulillah

Sekian Penjelasan tentang contoh implementasi OpenBSD Packet Filter ini, semoga bermanfaat.

Muhammad Muntaza
