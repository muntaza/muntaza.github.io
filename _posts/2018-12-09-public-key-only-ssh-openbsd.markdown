---
layout: post
title:  "Login SSH Hanya dengan Public Key"
date:   2018-12-09 11:26:56 +0800
categories: openbsd ssh
---

# Bismillah,

Langkah penting setelah Install OpenBSD pada VPS adalah menonaktifkan Authentication dengan password, sehingga tidak bisa di serang dengan serangan Brute Force Attack.

Berikut sedikit catatan tentang Langkah-langkah tersebut.

A.  Aktifkan doas

Doas belum aktif secara default, untuk mengaktifkannya, copy file setting doas.conf dari direktori /etc/examples

{% highlight bash %}
persediaan$ cd /etc/examples/
persediaan$ su
Password:
persediaan# cp doas.conf /etc/
persediaan# cat /etc/doas.conf
# $OpenBSD: doas.conf,v 1.1 2016/09/03 11:58:32 pirofti Exp $
# Configuration sample file for doas(1).
# See doas.conf(5) for syntax and examples.

# Non-exhaustive list of variables needed to build release(8) and ports(7)
#permit nopass setenv { \
#    FTPMODE PKG_CACHE PKG_PATH SM_PATH SSH_AUTH_SOCK \
#    DESTDIR DISTDIR FETCH_CMD FLAVOR GROUP MAKE MAKECONF \
#    MULTI_PACKAGES NOMAN OKAY_FILES OWNER PKG_DBDIR \
#    PKG_DESTDIR PKG_TMPDIR PORTSDIR RELEASEDIR SHARED_ONLY \
#    SUBPACKAGE WRKOBJDIR SUDO_PORT_V1 } :wsrc

# Allow wheel by default
permit keepenv :wheel
persediaan#
{% endhighlight %}

Agar bila password benar, untuk rentang waktu tertentu, tambahkan keyword "persist"
{% highlight bash %}

persediaan$ doas cat /etc/doas.conf | grep -v \#

permit persist keepenv :wheel

persediaan$
{% endhighlight %}


B.  Aktifkan Public Key Only Authentication

Non Aktifkan PasswordAuthentication dan ChallengeResponseAuthentication, sebagai tambahan, ClientAliveCountMax dan ClientAliveInterval agar tidak logout atau terputus koneksi saat tidak aktif pada terminal.

{% highlight bash %}
persediaan$ diff sshd_config sshd_config_backup
55c55
< PasswordAuthentication no
---
> #PasswordAuthentication yes
59c59
< ChallengeResponseAuthentication no
---
> #ChallengeResponseAuthentication yes
73,74c73,74
< ClientAliveInterval 120
< ClientAliveCountMax 720
---
> #ClientAliveInterval 0
> #ClientAliveCountMax 3
persediaan$

{% endhighlight %}

Copy file publik key pada file authorized_keys
{% highlight bash %}
persediaan$ ls ~/.ssh/authorized_keys
/home/muntaza/.ssh/authorized_keys
{% endhighlight %}


Sebelum restart sshd, pastikan file sshd_config nya tidak ada masalah dengan menjalankan perintah:

{% highlight bash %}
persediaan$ doas sshd -t
doas (muntaza@persediaan) password:
persediaan$ echo $?
0
{% endhighlight %}

Setelah di pastikan bahwa file sshd_config OK, maka restart sshd

{% highlight bash %}
persediaan$ doas rcctl restart sshd
doas (muntaza@persediaan) password:
sshd(ok)
sshd(ok)
persediaan$
{% endhighlight %}

Contoh Test koneksi, Bila menggunakan user yang tidak punya public key, akan muncul error tidak bisa login

{% highlight bash %}
muntaza@E202SA ~ $ ssh muntaza@muhammad.muntaza.id
Last login: Sun Dec  9 11:11:53 2018 from 114.125.164.23
OpenBSD 6.4 (GENERIC) #349: Thu Oct 11 13:25:13 MDT 2018

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

muhammad$
muhammad$
muhammad$ exit
Connection to muhammad.muntaza.id closed.
muntaza@E202SA ~ $
muntaza@E202SA ~ $ ssh fauzan@muhammad.muntaza.id
Permission denied (publickey).
muntaza@E202SA ~ $

{% endhighlight %}


C.  Install Patch dengan syspatch

Penting untuk menjaga agar system selalu up to date, install patch terbaru dengan perintah


{% highlight bash %}
persediaan$ doas syspatch
{% endhighlight %}


D.  Firewall dengan PF

Firewall pada OpenBSD cukup untuk memfilter port-port yang di inginkan, berikut contoh penerapannya.

{% highlight bash %}
persediaan$ doas /sbin/pfctl -d
pf disabled
persediaan$ doas /sbin/pfctl -ef /etc/pf.conf
pf enabled
persediaan$ doas /sbin/pfctl -sr
block return all
pass in proto tcp from any to any port = 22 flags S/SA
pass in proto tcp from any to any port = 80 flags S/SA
pass in proto tcp from any to any port = 443 flags S/SA
pass out all flags S/SA
block return in on ! lo0 proto tcp from any to any port 6000:6010
block return out log proto tcp all user = 55
block return out log proto udp all user = 55
persediaan$
persediaan$
persediaan$ doas  cat /etc/pf.conf
#       $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

set skip on lo

block return    # block stateless traffic
pass out                # establish keep-state

services = "{ 22, 80, 443 }"

pass in proto tcp to port $services

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild
persediaan$

{% endhighlight %}


Selesai sudah langkah penting untuk mengamankan server OpenBSD. Semoga bermanfaat
