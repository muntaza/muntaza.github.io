---
layout: post
title:  "Menghubungkan 2 Network dengan Linux"
date:   2012-03-25 12:26:56 +0800
categories: linux
---

# Bismillah,

Ditulis rinkas, semoga memberikan gambaran tentang Linux Networking. Aamiin


Disini terdapat beberapa komputer dengan rincian sbb:
1.  PC pertama, sebagai router, diberi nama durian, punya 3 nic dengan ip:
    -   eth0 192.168.5.1
    -   eth1 192.168.6.1
    -   eth2 10.10.10.1 gateway default 10.10.10.3  
    PC ini berpesan sebagai router yang menyatukan jaringan
    192.168.5.0/24 dan 192.168.6.0/24 dan menjadi gateway
    ke jaringan lainnya.

2.  Sebuah PC pada network 192.168.5.0/24, dengan alamat:
    -   eth0 192.168.5.2    
    diberi nama durian, 
    contoh disini hanya satu buah, bila terdapat PC lain, maka menggunakan
    alamat 192.168.5.3, 192.168.5.4, sampai maksimal 192.168.5.254

3.  Sebuah PC pada network 192.168.6.0/24, dengan alamat:
    -   eth0 192.168.6.2
        diberi nama langsat,    
    dan sebuah PC lainnya dengan alamat:   
    -   eth0 192.168.6.3  
    disini contoh hanya 2 buah PC, bila terdapat PC lain, maka menggunakan
    alamat 192.168.6.4, dan seterusnya sampai 192.168.6.254

gambar:

{% highlight text %}
-----[192.168.5.2]---[192.168.5.1 <> 192.168.6.1]---[192.168.6.2]
{% endhighlight %}

# A.  router  

Baik, disini saya mulai dengan konfigurasi PC pertama, yang berfungsi
sebagai router.

setting dimulai dari interface pertama eth0 dan verifikasi setting.

{% highlight text %}
root@pisang:~# ifconfig eth0 192.168.5.1 netmask 255.255.255.0 up
{% endhighlight %}

verifikasi settting

{% highlight text %}
  root@pisang:~# ifconfig eth0
  eth0      Link encap:Ethernet  HWaddr 52:54:00:12:14:52
            inet addr:192.168.5.1  Bcast:192.168.5.255  Mask:255.255.255.0
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
{% endhighlight %}

disini terlihat bahwa eth0 sudah punya IP 192.168.5.1 dan status nya "UP"

-   Setting eth1

{% highlight text %}
root@pisang:~# ifconfig eth1 192.168.6.1 netmask 255.255.255.0 up
{% endhighlight %}

verifikasi setting:

{% highlight text %}
root@pisang:~# ifconfig eth1
    eth1      Link encap:Ethernet  HWaddr 52:54:00:12:14:53
              inet addr:192.168.6.1  Bcast:192.168.6.255  Mask:255.255.255.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
{% endhighlight %}

-   Setting eth2

{% highlight text %}
root@pisang:~# ifconfig eth2 10.10.10.1 netmask 255.255.255.0 up
{% endhighlight %}

verifikasi setting

{% highlight text %}
root@pisang:~# ifconfig eth2
    eth2      Link encap:Ethernet  HWaddr 52:54:00:12:14:54
              inet addr:10.10.10.1  Bcast:10.10.10.255  Mask:255.255.255.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
{% endhighlight %}

-   Setting routing default pada gateway ini:

{% highlight text %}
root@pisang:~# route add default gw 10.10.10.3
{% endhighlight %}

verifikasi setting routing:

{% highlight text %}
root@pisang:~# route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref  Use Iface 
    192.168.6.0     0.0.0.0         255.255.255.0   U     0      0      0 eth1 
    192.168.5.0     0.0.0.0         255.255.255.0   U     0      0      0 eth0
    10.10.10.0      0.0.0.0         255.255.255.0   U     0      0      0 eth2 
    0.0.0.0         10.10.10.3      0.0.0.0         UG    0      0      0 eth2 
{% endhighlight %}

terlihat flag UG, yang menandakan gateway, telah aktif.

{% highlight text %}
setting IP forwarding pada gateway:
    root@pisang:~# sysctl -w net.ipv4.conf.all.forwarding=1
    net.ipv4.conf.all.forwarding = 1
    root@pisang:~# sysctl -w net.ipv4.ip_forward=1
    net.ipv4.ip_forward = 1
{% endhighlight %}

selesai sudah setting gateway atau router, sekarang setting clien

# B. PC pada network 192.168.5.0/24

-   Setting eth0 pada durian,

{% highlight text %}
root@durian:~# ifconfig eth0 192.168.5.2 netmask 255.255.255.0 up
{% endhighlight %}

verifikasi setting:
{% highlight text %}
root@durian:~# ifconfig eth0
    eth0      Link encap:Ethernet  HWaddr 52:54:00:12:15:22
              inet addr:192.168.5.2  Bcast:192.168.5.255  Mask:255.255.255.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
{% endhighlight %}

-   Setting routing ke gateway dari clien ini.

{% highlight text %}
root@durian:~# route add default gw 192.168.5.1
{% endhighlight %}

verifikasi setting:

{% highlight text %}
root@durian:~# route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref  Use Iface
    192.168.5.0     0.0.0.0         255.255.255.0   U     0      0      0 eth0 
    0.0.0.0         192.168.5.1     0.0.0.0         UG    0      0      0 eth0 
{% endhighlight %}

OK, selesai pada clien ini, bila ada PC lainnya, cara settingnya sama,
kecuali
IP Address nya harus beda, yaitu 192.168.5.4, 192.168.5.13 dst sampai
192.168.5.254

tes ping ke gateway:
{% highlight text %}
root@durian:~# ping -c1 192.168.5.1
    PING 192.168.5.1 (192.168.5.1) 56(84) bytes of data.
    64 bytes from 192.168.5.1: icmp_req=1 ttl=64 time=40.3 ms

    --- 192.168.5.1 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 40.304/40.304/40.304/0.000 ms

root@durian:~# ping -c1 192.168.6.1
    PING 192.168.6.1 (192.168.6.1) 56(84) bytes of data.
    64 bytes from 192.168.6.1: icmp_req=1 ttl=64 time=40.7 ms

    --- 192.168.6.1 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 40.732/40.732/40.732/0.000 ms

root@durian:~# ping -c1 10.10.10.1
    PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
    64 bytes from 10.10.10.1: icmp_req=1 ttl=64 time=40.5 ms

    --- 10.10.10.1 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 40.579/40.579/40.579/0.000 ms
{% endhighlight %}

Ping telah berhasil ke gateway.

# C. PC pada network 192.168.6.0/24

-   Setting eth0 pada langsat

{% highlight text %}
root@langsat:~# ifconfig eth0 192.168.6.2 netmask 255.255.255.0 up
{% endhighlight %}

verifikasi setting:

{% highlight text %}
root@langsat:~# ifconfig eth0
    eth0      Link encap:Ethernet  HWaddr 52:54:00:12:16:12
              inet addr:192.168.6.2  Bcast:192.168.6.255  Mask:255.255.255.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
{% endhighlight %}

-   Setting routing default ke gateway:

{% highlight text %}
root@langsat:~# route  add default gw 192.168.6.1
{% endhighlight %}

verifikasi routing:

{% highlight text %}
root@langsat:~# route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref  Use Iface 
    192.168.6.0     0.0.0.0         255.255.255.0   U     0      0      0 eth0 
    0.0.0.0         192.168.6.1     0.0.0.0         UG    0      0      0 eth0 
{% endhighlight %}

OK. Sekarang tes ping ke jaringan 192.168.5.0/24. disini terdapat
IP 192.168.5.2 diseberang router, kita akan coba ping.

{% highlight text %}
root@langsat:~# ping -c1 192.168.5.2
    PING 192.168.5.2 (192.168.5.2) 56(84) bytes of data.
    64 bytes from 192.168.5.2: icmp_req=1 ttl=63 time=80.6 ms

    --- 192.168.5.2 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 80.622/80.622/80.622/0.000 ms
{% endhighlight %}

OK. ping sudah berhasil.

semoga bermanfaat.

# Alhamdulillah
