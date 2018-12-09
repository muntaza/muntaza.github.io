---
layout: post
title:  "Login SSH Hanya dengan Public Key"
date:   2018-12-09 11:26:56 +0800
categories: openbsd ssh
---

# Bismillah,

Langkah penting setelah Install OpenBSD pada VPS adalah menonaktifkan Authentication dengan password, sehingga tidak bisa di serang dengan serangan Brute Force Attack.

Berikut sedikit catatan tentang Langkah-langkah tersebut.

1.  Aktifkan doas

    Doas belum aktif secara default, untuk mengaktifkannya, copy file setting doas.conf dari direktori /etc/examples

    {% highlight bash %}
persediaan$ cd /etc/examples/
persediaan$ ls
bgpd.conf      dvmrpd.conf    ifstated.conf  ldpd.conf      ospf6d.conf    radiusd.conf   relayd.conf    snmpd.conf
chio.conf      eigrpd.conf    iked.conf      man.conf       ospfd.conf     rbootd.conf    remote         sysctl.conf
dhclient.conf  exports        inetd.conf     mixerctl.conf  pf.conf        rc.local       ripd.conf      vm.conf
dhcpd.conf     hostapd.conf   ipsec.conf     mrouted.conf   printcap       rc.securelevel sasyncd.conf   wsconsctl.conf
doas.conf      httpd.conf     ldapd.conf     ntpd.conf      rad.conf       rc.shutdown    sensorsd.conf  ypldap.conf
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


    {% highlight bash %}
    bash $
    {% endhighlight %}


2.  Aktifkan Public Key Only Authentication

3.  Install Patch dengan syspatch


