---
layout: post
title:  "Langkah Penting Setelah Instalasi OpenBSD"
date:   2018-12-09 12:26:56 +0800
categories: openbsd ssh
---

# Bismillah,

Setelah Instalasi OpenBSD, ada beberapa hal penting yang harus di lakukan, diantaranya adalah menonaktifkan login SSH dengan password, melainkan hanya menggunakan public key. Berikut ini diantara langkah-langkah tersebut.

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

Agar bila password benar, untuk rentang waktu tertentu, tidak perlu mengetik password lagi, tambahkan keyword "persist"
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


Contoh penggunaan syspatch

{% highlight bash %}

muhammad$ doas syspatch -c
doas (muntaza@muhammad.muntaza.id) password:
003_portsmash
004_lockf
005_perl
006_uipc
007_smtpd
008_qcow2
muhammad$
muhammad$
muhammad$
muhammad$ doas syspatch
Get/Verify syspatch64-003_portsma... 100% |*************| 15264 KB    00:07
Installing patch 003_portsmash
Get/Verify syspatch64-004_lockf.tgz 100% |**************|   658 KB    00:00
Installing patch 004_lockf
Get/Verify syspatch64-005_perl.tgz 100% |***************|  5319 KB    00:02
Installing patch 005_perl
Get/Verify syspatch64-006_uipc.tgz 100% |***************|   176 KB    00:00
Installing patch 006_uipc
Get/Verify syspatch64-007_smtpd.tgz 100% |**************|  6484       00:00
Installing patch 007_smtpd
Get/Verify syspatch64-008_qcow2.tgz 100% |**************| 95855       00:00
Installing patch 008_qcow2
Relinking to create unique kernel... done.
muhammad$
muhammad$

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


E. Jaga waktu dan Koneksi di VPS

Server OpenBSD yang jalan di Virtual Machine, perlu di jaga koneksinya dengan melakukan ping ke default gateway tiap 5 (lima) menit, dan perlu mencocokkan jam nya dengan rdate tiap 15 (lima belas) menit. Perhatikan crontab di bawah ini.


{% highlight bash %}
#
SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin
HOME=/var/log
#
#minute	hour	mday	month	wday	command
#
# rotate log files every hour, if necessary
0	*	*	*	*	/usr/bin/newsyslog
# send log file notifications, if necessary
#1-59	*	*	*	*	/usr/bin/newsyslog -m
#
# do daily/weekly/monthly maintenance
30	1	*	*	*	/bin/sh /etc/daily
30	3	*	*	6	/bin/sh /etc/weekly
30	5	1	*	*	/bin/sh /etc/monthly
#0	*	*	*	*	sleep $((RANDOM \% 2048)) && /usr/libexec/spamd-setup


#time and connections
*/15    *       *       *       *       /usr/sbin/rdate id.pool.ntp.org > /dev/null 2> /dev/null
*/5     *       *       *       *       /sbin/ping -c3 45.64.99.129 > /dev/null

{% endhighlight %}


Bisa jadi terdapat suatu pertanyaan, bukankan OpenNTPD sudah aktif by default? bahkan saya setting dengan flags=-s agar langsung mencocokkan jam dengan server tiap booting, seperti tertera di file /etc/rc.conf.local berikut:

{% highlight bash %}
$ cat /etc/rc.conf.local
ntpd_flags=-s
{% endhighlight %}

Jawabannya adalah, terdapatnya beberapa bug pada OpenBSD yang jalan di VM yang di jelaskan di [sini](https://openbsd.amsterdam/known.html)

F. Penutup

Hal yang cukup penting, editlah file /etc/hosts, dan masukkan ip dan nama domain lengkap server ini, yang mana hal ini bermanfaat untuk masa yang akan datang, insyaAllah.



Selesai sudah langkah penting untuk mengamankan server OpenBSD. Semoga bermanfaat


Abu Muhammad Muhammad Muntaza bin Hatta
