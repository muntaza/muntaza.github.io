---
author: muntaza
comments: true
date: 2010-01-18 02:39:35+00:00
layout: post
link: https://muntaza.wordpress.com/2010/01/18/catatan-instalasi-dan-konfigurasi-slackware-13-0/
slug: catatan-instalasi-dan-konfigurasi-slackware-13-0
title: catatan instalasi dan konfigurasi slackware 13.0
wordpress_id: 115
categories:
- kisah muhammad muntaza
- linux
---

**groups**


bash-3.1$ id

uid=500(muntaza) gid=500(muntaza)

groups=10(wheel),11(floppy),17(audio),18(video),

19(cdrom),83(plugdev),84(power),86(netdev),500(muntaza)
bash-3.1$





**system partisi**


bash-3.1$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/root             1020M  206M  762M  22% /
/dev/sda6            1020M  144M  824M  15% /tmp
/dev/sda7             2.0G  163M  1.8G   9% /var
/dev/sda8             107M   30M   72M  30% /boot
/dev/sda10            4.0G  536M  3.3G  14% /opt
/dev/sda11            9.9G  4.2G  5.3G  45% /usr
/dev/sda12            2.0G   68M  1.9G   4% /usr/src
/dev/sda13             54G  2.1G   49G   5% /home
tmpfs                      498M     0  498M   0% /dev/shm

**fstab**

bash-3.1$ cat /etc/fstab
/dev/sda9        swap             swap        defaults         0   0
/dev/sda5        /                ext4        defaults         1   1
/dev/sda6        /tmp             ext4        defaults         1   2
/dev/sda7        /var             ext4        defaults         1   2
/dev/sda8        /boot            ext3        defaults         1   2
/dev/sda10       /opt             ext4        defaults         1   2
/dev/sda11       /usr             ext4        defaults         1   2
/dev/sda12       /usr/src         ext4        defaults         1   2
/dev/sda13       /home            ext4        defaults         1   2
/dev/sda2         /mnt/win_c       ntfs-3g     umask=022        1   0
#/dev/cdrom      /mnt/cdrom       auto        noauto,owner,ro  0   0
/dev/fd0           /mnt/floppy      auto        noauto,owner     0   0
devpts              /dev/pts         devpts      gid=5,mode=620   0   0
proc                  /proc            proc        defaults         0   0
tmpfs               /dev/shm         tmpfs       defaults         0   0

**install openoffice 3.1**

sh-3.1$ ls
OOo_3.1.0_LinuxIntel_install_wJRE_en-US.tar.gz
sh-3.1$ tar -xzf OOo_3.1.0_LinuxIntel_install_wJRE_en-US.tar.gz
sh-3.1$

sh-3.1$ cd OOO310_m11_native_packed-2_en-US.9399/
sh-3.1$ ls
JavaSetup.jar  installdata  readmes  update
RPMS           licenses     setup
sh-3.1$ cd RPMS/
sh-3.1$

sh-3.1$ ls *.rpm > install_awal.sh
sh-3.1$ sed -e "s/^/rpm \-ivh \-\-nodeps /" install_awal.sh > install.sh

sh-3.1$ tail -3 install.sh
rpm -ivh --nodeps openoffice.org3-impress-3.1.0-9399.i586.rpm
rpm -ivh --nodeps openoffice.org3-math-3.1.0-9399.i586.rpm
rpm -ivh --nodeps openoffice.org3-writer-3.1.0-9399.i586.rpm

sh-3.1$ sudo sh install.sh

**Service Aktif**

bash-3.1$ cd /etc/rc.d/
bash-3.1$ ls -l | egrep -v "drwx" | egrep -v "lrwx" | grep x
-rwxr-xr-x 1 root root  1282 2007-03-27 01:12 rc.4
-rwxr-xr-x 1 root root  7453 2008-12-02 20:32 rc.6
-rwxr-xr-x 1 root root  2425 2008-12-02 20:31 rc.K
-rwxr-xr-x 1 root root 10906 2009-04-25 22:01 rc.M
-rwxr-xr-x 1 root root 14253 2009-04-22 02:48 rc.S
-rwxr-xr-x 1 root root   466 2008-11-20 18:13 rc.acpid
-rwxr-xr-x 1 root root  2672 2009-03-01 23:34 rc.alsa
-rwxr-xr-x 1 root root  3116 2008-04-13 21:48 rc.bind
-rwxr-xr-x 1 root root  4318 2009-08-22 02:51 rc.cups
-rwxr-xr-x 1 root root   493 2009-11-10 12:32 rc.firewall
-rwxr-xr-x 1 root root   119 2009-08-25 01:33 rc.font.new
-rwxr-xr-x 1 root root  1893 2008-10-22 04:41 rc.fuse
-rwxr-xr-x 1 root root  1148 2009-11-08 20:10 rc.gpm
-rwxr-xr-x 1 root root   906 2009-08-01 05:32 rc.hald
-rwxr-xr-x 1 root root   703 2009-08-10 19:16 rc.httpd
-rwxr-xr-x 1 root root  9579 2009-08-25 04:37 rc.inet1
-rwxr-xr-x 1 root root  4847 2007-09-17 22:07 rc.inet2
-rwxr-xr-x 1 root root   497 2003-09-12 03:27 rc.inetd
-rwxr-xr-x 1 root root   272 2006-08-12 02:07 rc.local
-rwxr-xr-x 1 root root  1740 2009-06-09 05:00 rc.messagebus
-rwxr-xr-x 1 root root 35406 2009-08-17 06:27 rc.modules-2.6.29.6
-rwxr-xr-x 1 root root 35406 2009-08-17 05:49 rc.modules-2.6.29.6-smp
-rwxr-xr-x 1 root root  2585 2009-08-04 04:11 rc.mysqld
-rwxr-xr-x 1 root root   981 2007-04-09 23:10 rc.syslog
-rwxr-xr-x 1 root root  1740 1999-09-11 20:48 rc.sysvinit
-rwxr-xr-x 1 root root  4231 2009-04-22 02:01 rc.udev
-rwxr-xr-x 1 root root 12494 2009-04-27 18:33 rc.wireless
-rwxr-xr-x 1 root root  2323 2005-07-31 23:56 rc.yp
bash-3.1$

**setting jaringan**

bash-3.1$ pwd
/etc/rc.d
bash-3.1$ sudo cat rc.inet1.conf | head -18 | tail -2
IPADDR[0]="192.168.0.80"
NETMASK[0]="255.255.255.0"
bash-3.1$ sudo cat rc.inet1.conf | head -41 | tail -1
GATEWAY="192.168.0.1"
bash-3.1$

bash-3.1$ cat /etc/hosts | tail -6
127.0.0.1        localhost
192.168.0.80        pisang.rumah.ku pisang
192.168.0.1        gateway
202.xxx.x.xx        dns

# End of hosts.

**DNS**

bash-3.1$ head -13 /etc/named.conf
options {
directory "/var/named";
/*
* If there is a firewall between you and nameservers you want
* to talk to, you might need to uncomment the query-source
* directive below.  Previous versions of BIND always asked
* questions using port 53, but BIND 8.1 uses an unprivileged
* port by default.
*/
// query-source address * port 53;
forward only;
forwarders { 202.xxx.x.xx; };
};
bash-3.1$
bash-3.1$
bash-3.1$ cat /etc/resolv.conf
search rumah.ku
nameserver 192.168.0.80
