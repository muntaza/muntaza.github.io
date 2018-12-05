---
author: muntaza
comments: true
date: 2007-12-20 02:12:32+00:00
layout: post
link: https://muntaza.wordpress.com/2007/12/20/firewall-with-iptables/
slug: firewall-with-iptables
title: Firewall with iptables
wordpress_id: 5
categories:
- linux
---

Dibawah ini adalah file konfigurasi firewall menggunakan iptables,
file ini saya ambil dari The Linux Documentations Project, lalu saya
edit untuk disesuaikan dengan penggunaan saya.

file ini saya simpan di /home/muntaza/firewall/rc.firewal  dan saya jalankan ketika konek ke internet

Bagi pemula linux seperti saya, konfigurasi yang ada sudah cukup aman IMHO
untuk firewall koneksi internet.

saya kebetulan bukan ahlinya dalam pengelolaan iptables, jadi
CMIIW

salam,
muhammad muntaza
tinggal di kota Paringin, Kab. Balangan, Prov. Kalimantan Selatan

--------Please do not paste blindly from this document-----------

#! /bin/bash
echo "jalankan firewall"

IPTABLES=/sbin/iptables
WAN_IFACE="ppp0"

#BLACKLIST="192.168.0.1"
ANYWHERE="0/0"

#load modul
modprobe ip_conntrack
modprobe ip_nat_ftp
modprobe ip_conntrack_ftp

$IPTABLES -F
$IPTABLES -X

#Set default policies
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P INPUT DROP

#Accept localhost
#$IPTABLES -A INPUT -i lo -j ACCEPT

#Reserved IPs:
$IPTABLES -A INPUT -i $WAN_IFACE -s 10.0.0.0/8 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 172.16.0.0/12 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 192.168.0.0/16 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 127.0.0.0/8 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 169.254.0.0/16 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 224.0.0.0/4 -j DROP
$IPTABLES -A INPUT -i $WAN_IFACE -s 240.0.0.0/5 -j DROP

#Bogus routing
$IPTABLES -A INPUT -s 255.255.255.255 -d $ANYWHERE -j DROP

#Unclean
#$IPTABLES -A INPUT -i $WAN_IFACE -m unclean -m limit \
# -j LOG --log-prefix "Unclean: "
#$IPTABLES -A INPUT -i $WAN_IFACE -m unclean -j DROP

#for i in $BLACKLIST; do
# $IPTABLES -A INPUT -s $i -m limit --limit 5/minute \
# -j LOG --log-prefix "Blacklisted: "
# $IPTABLES -A INPUT -s $i -j DROP
#done

#ICMP (ping)
$IPTABLES -A INPUT -p icmp --icmp-type echo-reply \
-s $ANYWHERE -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type destination-unreachable \
-s $ANYWHERE -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type time-exceeded \
-s $ANYWHERE -j ACCEPT

#New Chain
$IPTABLES -N DEFAULT
$IPTABLES -A DEFAULT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A DEFAULT -m state --state NEW -i ! $WAN_IFACE -j ACCEPT

$IPTABLES -A DEFAULT -m limit -j LOG --log-prefix "Bad packet from ppp0: "
$IPTABLES -A DEFAULT -j DROP

$IPTABLES -A FORWARD -j DEFAULT
$IPTABLES -A INPUT -j DEFAULT

echo
echo "iptables firewall is up `date`"


--------Please do not paste blindly from this document--------------
