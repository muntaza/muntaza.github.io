---
author: muntaza
comments: true
date: 2014-12-20 14:50:43+00:00
layout: post
link: https://muntaza.wordpress.com/2014/12/20/openbsd-pf-firewall-for-small-office-web-server/
slug: openbsd-pf-firewall-for-small-office-web-server
title: OpenBSD PF Firewall for Small Office Web Server
wordpress_id: 444
categories:
- Firewall
- OpenBSD
tags:
- Networking
- Openbsd
- PF
---

Bismillah,

This is configurations setting for protect Small Office web server
from internet, for more information about OpenBSD pf:

[sourcecode languange="sh" wraplines="false"]
$ man pf.conf
[/sourcecode]

I use tutorial from OpenBSD website http://www.openbsd.org/faq/pf/example1.html
as a template to write tutorial. And this tutorial is focused on users
of OpenBSD 5.6


The network is setup like this:
[sourcecode languange="sh" wraplines="false"]
[ COMP1 ]    [ server ]
      |            |
   ---+------+-----+------- re0 [ OpenBSD ] udav0 -------- ( Internet )
             |
         [ COMP2 ]
[/sourcecode]



The objectives are:


	

  1. Use a "default deny" filter ruleset.


  2. Allow the following incoming traffic to the firewall from the Internal:

    
	
    * SSH (TCP port 22): this will be used for maintenance of the firewall machine (only from 192.168.0.1).

    

  3. Redirect TCP port https connection attempts (which are attempts to access a web server) to computer "server". Also, permit TCP port https traffic destined for "server" through the firewall.

    
    	
    * Proxy the handshake. With the handshake proxied, PF itself will complete the handshake with the client, initiate a handshake with the server, and then pass packets between the two. In the case of a TCP SYN flood attack, the attacker never completes the three-way handshake, so the attacker's packets never reach the protected server, but legitimate clients will complete the handshake and get passed. This minimizes the impact of spoofed TCP SYN floods on the protected service, handling it in PF instead.

	
    * Limits the maximum number of connections per source to 100

    	
    * Rate limits the number of connections to 15 in a 5 second span

     	
    * Puts the IP address of any host that breaks these limits into the  table

    	
    * For any offending IP addresses, flush any states created by this rule.

    	
    * NAT on the external interface for any packets coming from "server".

    

  4. By default, reply with a TCP RST or ICMP Unreachable for blocked packets.

    
    	
    * Offers a Unicast Reverse Path Forwarding (uRPF) feature.

    	
    * Offers Protection from Reverse Telnet.

    	
    * Block Internet access from each internal computer.

    	
    * Do not permit remote connections to X11.

    	
    * Block ICMP traffic.

    

  5. Make the ruleset as simple and easy to maintain as possible.



[sourcecode languange="sh" wraplines="false"]
#	$Id: pf.conf_gateway,v 1.8 2014/12/02 21:39:58 muntaza Exp $
#	$OpenBSD: pf.conf,v 1.53 2014/01/25 10:28:36 dtucker Exp $

# macros
ext_if = "udav0"
int_if = "re0"

server = "192.168.0.3"
tcp_services = "https"

laptop_admin = "192.168.0.1"
local = "ssh"

# options
set skip on lo

# match rules
match out on $ext_if inet from $server to any nat-to $ext_if:0

# filter rules
block return	# block stateless traffic

table <abusive_hosts> persist
block in quick from <abusive_hosts>

pass in on $ext_if inet proto tcp to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

pass out on $int_if inet proto tcp to $server \
    port $tcp_services


pass in on $int_if inet proto tcp from $laptop_admin to $int_if \
    port $local

pass out on $int_if inet proto tcp from $int_if to $laptop_admin \
    port $local


block in quick from urpf-failed to any	# use with care

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

[/sourcecode]



Alhamdulillah
Semoga Allah Ta'ala, menjadikan usaha ini bermanfaat
dan memudahkan ana untuk mukim di Banjarbaru.


Abu Husnul Khatimah Muhammad Muntaza bin Hatta


Daftar Pustaka
1. http://www.openbsd.org/faq/pf/index.html
2. pf.conf(5) manual page

