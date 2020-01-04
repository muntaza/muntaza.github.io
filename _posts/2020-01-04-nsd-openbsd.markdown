---
layout: post
title:  "NSD Sebagai DNS Server"
date:   2020-01-04 12:26:56 +0800
categories: dns
---

# Bismillah,

Saya menggunakan [NSD](https://en.wikipedia.org/wiki/NSD) sebagai 
[DNS](https://en.wikipedia.org/wiki/Domain_Name_System) server menggantikan
[BIND](https://www.isc.org/bind/). OpenBSD sejak versi [5.7](https://www.openbsd.org/faq/upgrade57.html) 
sudah mengganti BIND dengan NSD dan Unbound.

Setting yang saya gunakan, adalah seminimal mungkin, sehingga di harapkan 
memudahkan bagi yang ingin mencobanya. Adapun pembahasan lebih lanjut tentang
NSD ini, silahkan merujuk ke Daftar Pustaka.

-   Beli Domain dan Atur Nameserver  

    Disini, kita membeli sebuah domain, misalnya example.com, kemudian atur
    agar Nameserver nya merujuk ke IP Publik VPS yang kita miliki, misalnya
    192.0.2.72

-   Setting nsd.conf

    ```text
    muhammad$ doas cat /var/nsd/etc/nsd.conf
    ```
    ```text
    # $OpenBSD: nsd.conf,v 1.13 2018/08/16 17:59:12 florian Exp $
    
    server:
            hide-version: yes
            verbosity: 1
            interface: 192.0.2.72
    
    
    remote-control:
            control-enable: yes
            control-interface: /var/run/nsd.sock
    
    zone:
            name: "example.com"
            zonefile: "master/example.com.zone"
    
    zone:
            name: "2.0.192.in-addr.arpa"
            zonefile: "master/2.0.192.in-addr.arpa.zone"
    ```

-   Setting file zone

    ```text
    muhammad$ doas cat /var/nsd/zones/master/example.com.zone
    ```
    ```text
    $TTL 86400
    @       IN      SOA     muntaza.example.com.         root.localhost (
                            17      ; serial
                            28800   ; refresh
                            7200    ; retry
                            604800  ; expire
                            86400   ; ttl
                            )
    
                    IN      NS      muntaza
    @               IN      A       192.0.2.72
    muntaza         IN      A       192.0.2.72
    openaset        IN      A       192.0.2.72
    ```
    ```text
    muhammad$ doas cat /var/nsd/zones/master/2.0.192.in-addr.arpa.zone
    ```
    ```text
    $TTL 86400
    @       IN      SOA     muntaza.example.com.         root.localhost (
                            17      ; serial
                            28800   ; refresh
                            7200    ; retry
                            604800  ; expire
                            86400   ; ttl
                            )
    
    @       IN       NS      192.0.2.72.
    
    72       IN      PTR     muntaza.example.com.
    72       IN      PTR     openaset.example.com.
    muhammad$
    ```
    
-   Setting pf.conf

    [PF Firewall](https://www.muntaza.id/openbsd/2019/08/31/openbsd-pf-cloud.html) perlu
    kita sesuaikan dengan membuka port 53 agar bisa menerima query Name Server.

    ```text
    muhammad$ doas cat /etc/pf.conf
    ```
    ```text
    #       $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
    #
    # See pf.conf(5) and /etc/examples/pf.conf
    
    set skip on lo
    
    block return    # block stateless traffic
    pass out                # establish keep-state
    
    services = "{ 22, 53, 80, 443, 4443 }"
    
    pass in proto tcp to port $services
    
    pass in proto udp to port 53
    
    # By default, do not permit remote connections to X11
    block return in on ! lo0 proto tcp to port 6000:6010
    
    # Port build user does not need network
    block return out log proto {tcp udp} user _pbuild
    ```
-   Aktifkan NSD di rc.conf.local

    ```text
    muhammad$ doas cat /etc/rc.conf.local | grep nsd
    ```
    ```text
    nsd_flags=
    ```

Nah, sekian apa yang saya ringkaskan mengenai NSD ini, lebih lanjut, silahkan 
lihat pada Daftar Pustaka.

# Alhamdulillah



__Daftar Pustaka__

1. [OpenBSD Manual: nsd.conf(5)](https://man.openbsd.org/OpenBSD-6.4/nsd.conf.5)
2. [OpenBSD Manual: nsd(8)](https://man.openbsd.org/OpenBSD-6.4/nsd.8)
3. [OpenBSD Manual: rcctl(8)](https://man.openbsd.org/OpenBSD-6.4/rcctl)
4. [How To Use NSD, an Authoritative-Only DNS Server, on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-use-nsd-an-authoritative-only-dns-server-on-ubuntu-14-04)
5. [Setting up nsd DNS server](https://wiki.alpinelinux.org/wiki/Setting_up_nsd_DNS_server)
6. [NSD DNS Tutorial](https://dnswatch.com/dns-docs/NSD/)
7. [12 Dig Command Examples To Query DNS In Linux](https://www.rootusers.com/12-dig-command-examples-to-query-dns-in-linux/)
8. [Using dig to Query a Specific DNS Server (Name Server) Directly (Linux, BSD, OSX)](http://droptips.com/using-dig-to-query-a-specific-dns-server-name-server-directly-linux-bsd-osx)
9. [IPv4 Address Blocks Reserved for Documentation](https://tools.ietf.org/html/rfc5737)

