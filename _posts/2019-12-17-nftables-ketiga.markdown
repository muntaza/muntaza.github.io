---
layout: post
title:  "Firewall dengan nftables bagian Ketiga"
date:   2019-12-17 12:26:56 +0800
categories: nftables
---

# Bismillah,

Ini adalah lanjutan dari tulisan saya yang
[kedua](https://muntaza.github.io/nftables/2019/12/16/nftables-kedua.html)
tentang [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page).

Sebuah [Firewall](https://muntaza.github.io/openbsd/2019/08/31/openbsd-pf-cloud.html)
yang baik, memiliki 3 (tiga) kriteria utama, yaitu:
- Koneksi dibatasi hanya dari negara tertentu
- Mampu mencegah [reverse telnet](https://toic.org/blog/2009/reverse-ssh-port-forwarding/index.html)
- Mampu mencegah [DDOS](https://www.cloudflare.com/learning/ddos/http-flood-ddos-attack/)

Pada tulisan bagian ketiga ini, akan saya tampilkan contoh pembatasan
koneksi hanya dari IP yang berasal dari Indonesia. Serangan terhadap
webserver bisa datang dari negara mana saja, sehingga dengan membatasi
koneksi/akses hanya dari IP Indonesia, telah mengurangi peluang
server kita di rusak oleh pihak asing.

Daftar IP yang berasal dari Indonesia saya dapatkan dari website
[https://www.ipdeny.com/](https://www.ipdeny.com/ipblocks/) yaitu file
[id.zone](https://www.ipdeny.com/ipblocks/data/countries/id.zone)

Nah, inilah file [/etc/nftables.conf](/assets/nftables.conf) nya.

Wah-wah, filenya panjang sekali ya...he...he... (senyum) yah itulah
karena file ini menampung hasil data IP dari file
[id.zone](https://www.ipdeny.com/ipblocks/data/countries/id.zone) ini.

Saya akan menjelaskan beberapa baris perintah yang saya anggap penting
untuk di jelaskan, dan kalau di perlukan, silahkan merujuk pada tulisan saya
bagian
[pertama](https://muntaza.github.io/nftables/2019/12/15/nftables-01.html)
dan [kedua](https://muntaza.github.io/nftables/2019/12/16/nftables-kedua.html).


{% highlight text %}
	set ip_indonesia {
		type ipv4_addr
		flags interval
		auto-merge
		elements = {
{% endhighlight %}

Pendefinisian IP yang berasal dari Indonesia

{% highlight text %}
	chain INPUT {
		type filter hook input priority 0; policy drop;
		ct state established,related accept
		iifname $lo_if accept
		ip saddr @ip_indonesia tcp dport { ssh, http } ct state new accept
		drop
	}
{% endhighlight %}

Chain input, rinciannya sebagai berikut:

{% highlight text %}
type filter hook input priority 0; policy drop;
{% endhighlight %}

Default Deny, blok semua koneksi masuk secara default

{% highlight text %}
ct state established,related accept
{% endhighlight %}

Terima Koneksi balasan yang berasal dari dalam

{% highlight text %}
iifname $lo_if accept
{% endhighlight %}

Izinkan localhost

{% highlight text %}
ip saddr @ip_indonesia tcp dport { ssh, http } ct state new accept
{% endhighlight %}

Izinkan akses ke port 22 dan port 80 hanya dari IP
yang berasal dari Indonesia.

{% highlight text %}
drop
{% endhighlight %}

Blok semua IP lainnya.

NFTables ini memiliki prinsip __The first rule to match is the "winner"__, yaitu
perintah pertama yang sesuai, itu yang akan langsung di jalankan, sehingga
kita tempatkan perintah _drop_ pada bagian paling bawah, yang berarti
semua yang tidak sesuai rule di atas nya akan di blok.

Kalau kita tempatkan perintah _drop_ di atas, maka semua koneksi
di blok dan NFTables tidak membaca lagi rule di bawah nya.

Dari Contoh Di atas, saat IP berasal dari Indonesia, maka akan sesuai
dengan rule:

{% highlight text %}
ip saddr @ip_indonesia tcp dport { ssh, http } ct state new accept
{% endhighlight %}

maka IP Indonesia di izinkan, sedangkan seluruh IP lain, tidak _match_ dengan rule
tersebut, sehingga  terkena rule __drop__.


{% highlight text %}
	chain OUTPUT {
		type filter hook output priority 0; policy drop;
		ct state established,related accept
		oifname $lo_if accept
		ip daddr @ip_output accept
		drop
	}
{% endhighlight %}

Untuk chain output, secara ringkas bahwa semua koneksi ke seluruh
IP di tolak, kecuali IP yang di definisikan di kolom ip_output.

Untuk daftar IP yang masuk ke <@ip_output> maka di contoh ini
saya masukkan IP DNS Google, IP localhost, IP deb.debian.org
dan IP securty.debian.org

Secara detailnya, sebagai berikut:

{% highlight text %}
type filter hook output priority 0; policy drop;
{% endhighlight %}

Default Deny, Blok semua koneksi keluar. Fitur ini untuk mencegah
serangan reverse ssh.

{% highlight text %}
ct state established,related accept
{% endhighlight %}

Ini untuk koneksi dari luar, saat ada paket balasan dari dalam,
maka paket balasan tersebut perlu izin keluar, padahal semua koneksi
secara default kita blok, sehingga perlu rule ini. Dengan rule ini,
paket balasan dari dalam untuk koneksi _awal_ dari luar bisa lewat.

Ini lah bedanya dengan fitur __keep state__ pada OpenBSD PF, yang mana
pada fitur itu, koneksi balasan langsung bisa melewati firewall tanpa
mendefinisikan secara tersendiri di rule output.

{% highlight text %}
oifname $lo_if accept
{% endhighlight %}

Izinkan akses keluar menuju IP yang ada di interface __lo__.

{% highlight text %}
ip daddr @ip_output accept
{% endhighlight %}

Izinkan koneksi keluar, dari dalam, menuju daftar IP di table ip_output.
Hal ini akan saya coba jelaskan di tulisan berikutnya tentang NFTables, InsyaAllah.

{% highlight text %}
drop
{% endhighlight %}

Semua koneksi lain di blok.

Nah, sekian dulu dari saya, semoga bisa di lanjutkan ke tingkat
yang lebih tinggi dan semoga bermanfaat, aamiin.

# Alhamdulillah


Daftar Pustaka
- [Debian Linux: nftables](https://wiki.debian.org/nftables)
- [Moving from iptables to nftables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)
- [Using nftables in Red Hat Enterprise Linux 8](https://www.redhat.com/en/blog/using-nftables-red-hat-enterprise-linux-8)
- [Redhat: Chapter 30. Getting started with nftables](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/getting-started-with-nftables_configuring-and-managing-networking)
- [Arch Linux: nftables](https://wiki.archlinux.org/index.php/Nftables)
