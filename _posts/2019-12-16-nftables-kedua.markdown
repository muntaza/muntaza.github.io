---
layout: post
title:  "Firewall dengan nftables bagian Kedua"
date:   2019-12-16 12:26:56 +0800
categories: nftables
---

# Bismillah,

Ini adalah lanjutan dari tulisan saya yang
[pertama](https://www.muntaza.id/nftables/2019/12/15/nftables-01.html)
tentang [nftables](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page).
Pada bagian kedua ini, akan
saya contohkan penggunaan nftables sebagai
[firewall](https://en.wikipedia.org/wiki/Firewall_(computing)) sekaligus
[gateway](https://en.wikipedia.org/wiki/Router_(computing))
ke internet bagi localnet. Localnet di sini, masih menggunakan
virtual mesin di
[Virtualbox](https://www.muntaza.id/virtualbox/2019/12/01/virtualbox-internet.html).
Berikut ini script
/etc/nftables.conf

{% highlight text %}
#!/usr/sbin/nft -f

flush ruleset

define lo_if  = "lo"
define int_if = "tap11"
define ext_if = "wlp1s0"

table ip nat {
	chain PREROUTING {
		type nat hook prerouting priority 0; policy accept;
	}

	chain POSTROUTING {
		type nat hook postrouting priority 0; policy accept;
		oifname $ext_if masquerade
	}
}
table ip filter {
	chain INPUT {
		type filter hook input priority 0; policy drop;
		ct state established,related accept
		iifname $lo_if accept
		iifname $int_if accept
		drop
	}

	chain FORWARD {
		type filter hook forward priority 0; policy drop;
		iifname $ext_if oifname $int_if ct state established,related accept
		iifname $int_if oifname $ext_if accept
		drop
	}

	chain OUTPUT {
		type filter hook output priority 0; policy accept;
	}
}
{% endhighlight %}

Baiklah, di sini akan saya jelaskan beberapa hal baru sebagai lanjutan
tulisan saya yang [pertama](https://www.muntaza.id/nftables/2019/12/15/nftables-01.html).

{% highlight text %}
define int_if = "tap11"
define ext_if = "wlp1s0"
{% endhighlight %}

keyword *define* ini untuk mendefinisikan variable, disini kita definisikan
internal interface dan external interface.

{% highlight text %}
table ip nat {
	chain PREROUTING {
		type nat hook prerouting priority 0; policy accept;
	}

	chain POSTROUTING {
		type nat hook postrouting priority 0; policy accept;
		oifname $ext_if masquerade
	}
}
{% endhighlight %}

Ini adalah fungsi [NAT](https://en.wikipedia.org/wiki/Network_address_translation)
di nftables.

{% highlight text %}
	chain FORWARD {
		type filter hook forward priority 0; policy drop;
		iifname $ext_if oifname $int_if ct state established,related accept
		iifname $int_if oifname $ext_if accept
		drop
	}
{% endhighlight %}

Ini fungsi packet forwarding di nftables, sama seperti yang pernah
saya sampaikan tentang IPTables di
[sini](https://www.muntaza.id/virtualbox/2019/12/01/virtualbox-internet.html),
yaitu mengizinkan paket berpindah antar interface, yaitu dari
interface local ke interface internet dan sebaliknya.

Namun, kernel harus kita setting
di /etc/sysctl.conf agar mengizinkan
[perpindahan paket](https://unix.stackexchange.com/questions/14056/what-is-kernel-ip-forwarding)
 antar interface.
Edit file /etc/sysctl.conf pada bagian net.ipv4.ip_forward, ganti nilai
0 menjadi 1 sehingga tampil seperti contoh di bawah ini:

{% highlight text %}
$ cat /etc/sysctl.conf | grep ipv4.ip_forward
net.ipv4.ip_forward=1
{% endhighlight %}


Sampai di sini dulu dan akan saya lanjutkan, insyaAllah, tentang
cara mencegah reverse telnet dengan nftables di waktu yang akan datang.

# Alhamdulillah


Daftar Pustaka
- [Debian Linux: nftables](https://wiki.debian.org/nftables)
- [Moving from iptables to nftables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)
- [Using nftables in Red Hat Enterprise Linux 8](https://www.redhat.com/en/blog/using-nftables-red-hat-enterprise-linux-8)
- [Redhat: Chapter 30. Getting started with nftables](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/getting-started-with-nftables_configuring-and-managing-networking)
- [Arch Linux: nftables](https://wiki.archlinux.org/index.php/Nftables)
