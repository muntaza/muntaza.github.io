---
layout: post
title:  "Deploy OpenBSD pada Server Fisik"
date:   2019-03-18 12:26:56 +0800
categories: openbsd
---

# Bismillah,

Ini adalah catatan saya pada saat proses instalasi OpenBSD
pada Server Fisik. Semoga apa yang saya tulis ini bisa di ambil
faedah nya di masa yang akan datang. Aamiin.

Saya usahakan untuk sejelas mungkin menuturkan langkah-langkahnya,
namun, tentu ada saja yang terlewat, harap maklum...he...he...

{% highlight text %}
{% endhighlight %}

- Instalasi PIP

{% highlight text %}
muntaza@E202SA:~$ ssh 192.168.0.1
Last login: Thu Feb 14 16:27:08 2019 from 192.168.0.2
OpenBSD 6.4 (GENERIC.MP) #6: Sat Jan 26 20:37:44 CET 2019

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

thinkpad$ doas /usr/sbin/pkg_add py-pip
doas (muntaza@thinkpad.example.com) password:
quirks-3.16 signed on 2018-10-12T15:26:25Z
py-pip-9.0.3:py-setuptools-40.0.0v0: ok
py-pip-9.0.3: ok
--- +py-pip-9.0.3 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
thinkpad$ doas ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
thinkpad$
{% endhighlight %}

-   Upgrade PIP

{% highlight text %}
thinkpad$ doas pip install --upgrade pip
The directory '/home/muntaza/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/muntaza/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting pip
  Downloading https://files.pythonhosted.org/packages/d7/41/34dd96bd33958e52cb4da2f1bf0818e396514fd4f4725a79199564cd0c20/pip-19.0.2-py2.py3-none-any.whl (1.4MB)
    100% |################################| 1.4MB 100kB/s
Installing collected packages: pip
  Found existing installation: pip 9.0.3
    Uninstalling pip-9.0.3:
      Successfully uninstalled pip-9.0.3
Successfully installed pip-19.0.2
thinkpad$



thinkpad$ pip --version
pip 19.0.2 from /usr/local/lib/python2.7/site-packages/pip (python 2.7)
{% endhighlight %}

-   Instalasi Django

{% highlight text %}
thinkpad$ doas pip install Django==1.11.20
DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
The directory '/home/muntaza/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/muntaza/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting Django==1.11.20
  Downloading https://files.pythonhosted.org/packages/8e/1f/20bbc601c442d02cc8d9b25a399a18ef573077e3350acdf5da3743ff7da1/Django-1.11.20-py2.py3-none-any.whl (6.9MB)
    100% |################################| 7.0MB 164kB/s
Collecting pytz (from Django==1.11.20)
  Downloading https://files.pythonhosted.org/packages/61/28/1d3920e4d1d50b19bc5d24398a7cd85cc7b9a75a490570d5a30c57622d34/pytz-2018.9-py2.py3-none-any.whl (510kB)
    100% |################################| 512kB 195kB/s
Installing collected packages: pytz, Django
Successfully installed Django-1.11.20 pytz-2018.9
thinkpad$


thinkpad$ django-admin --version
1.11.20
thinkpad$

{% endhighlight %}

-   Instalasi Paket-paket PHP

{% highlight text %}
thinkpad$ doas /usr/sbin/pkg_add php-gd php-pdo php-pdo_pgsql php-pgsql php-apache
quirks-3.16 signed on 2018-10-12T15:26:25Z
Ambiguous: choose package for php-gd
a       0: <None>
        1: php-gd-5.6.38
        2: php-gd-7.0.32p1
        3: php-gd-7.1.22
        4: php-gd-7.2.10
Your choice: 1
php-gd-5.6.38:jpeg-2.0.0v0: ok
php-gd-5.6.38:png-1.6.35: ok
php-gd-5.6.38:t1lib-5.1.2p0: ok
php-gd-5.6.38:oniguruma-6.9.0: ok
php-gd-5.6.38:femail-1.0p1: ok
php-gd-5.6.38:femail-chroot-1.0p3: ok
php-gd-5.6.38:php-5.6.38p0: ok
php-gd-5.6.38: ok
Can't find php-pdo
Ambiguous: choose package for php-pdo_pgsql
a       0: <None>
        1: php-pdo_pgsql-5.6.38
        2: php-pdo_pgsql-7.0.32p1
        3: php-pdo_pgsql-7.1.22
        4: php-pdo_pgsql-7.2.10
Your choice: 1
php-pdo_pgsql-5.6.38:postgresql-client-10.5p1: ok
php-pdo_pgsql-5.6.38: ok
Ambiguous: choose package for php-pgsql
a       0: <None>
        1: php-pgsql-5.6.38
        2: php-pgsql-7.0.32p1
        3: php-pgsql-7.1.22
        4: php-pgsql-7.2.10
Your choice: 1
php-pgsql-5.6.38: ok
Ambiguous: choose package for php-apache
a       0: <None>
        1: php-apache-5.6.38
        2: php-apache-7.0.32p1
        3: php-apache-7.1.22
        4: php-apache-7.2.10
Your choice: 1
php-apache-5.6.38: ok
The following new rcscripts were installed: /etc/rc.d/php56_fpm
See rcctl(8) for details.
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/femail-chroot
        /usr/local/share/doc/pkg-readmes/php-5.6
thinkpad$
{% endhighlight %}

-   Instalasi PostgreSQL

{% highlight text %}
thinkpad$ doas /usr/sbin/pkg_add postgresql-server postgresql-contrib
quirks-3.16 signed on 2018-10-12T15:26:25Z
useradd: Warning: home directory `/var/postgresql' doesn't exist, and -m was not specified
postgresql-server-10.5p4: ok
postgresql-contrib-10.5p0: ok
The following new rcscripts were installed: /etc/rc.d/postgresql
See rcctl(8) for details.
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/postgresql-server

{% endhighlight %}


-   Instalasi Apache2 Mod WSGI

{% highlight text %}
thinkpad$ doas /usr/sbin/pkg_add ap2-mod_wsgi
quirks-3.16 signed on 2018-10-12T15:26:25Z
ap2-mod_wsgi-4.6.4p0: ok
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/ap2-mod_wsgi
thinkpad$

{% endhighlight %}

-   Instalasi Psycopg2

{% highlight text %}
thinkpad$ doas pip install psycopg2
DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
The directory '/home/muntaza/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/home/muntaza/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting psycopg2
  Downloading https://files.pythonhosted.org/packages/63/54/c039eb0f46f9a9406b59a638415c2012ad7be9b4b97bfddb1f48c280df3a/psycopg2-2.7.7.tar.gz (427kB)
    100% |################################| 430kB 134kB/s
Installing collected packages: psycopg2
  Running setup.py install for psycopg2 ... done
Successfully installed psycopg2-2.7.7
thinkpad$

{% endhighlight %}


-   Update OpenBSD dengan __openup__

{% highlight text %}
thinkpad$ doas sh openup
doas (muntaza@thinkpad.example.com) password:
===> Checking for openup update
===> Installing/updating syspatches
===> Updating package(s)
quirks-3.17 signed on 2018-11-16T12:23:49Z
partial-php-5.6.39+php-5.6.38p0->php-5.6.39 forward dependencies:
| Dependencies of php-gd-5.6.38 on php-5.6.38 don't match
| Dependencies of php-apache-5.6.38 on php-5.6.38 don't match
| Dependencies of php-pdo_pgsql-5.6.38 on php-5.6.38 don't match
| Dependencies of php-pgsql-5.6.38 on php-5.6.38 don't match
Merging php-gd-5.6.38->5.6.39 (ok)
Merging php-apache-5.6.38->5.6.39 (ok)
Merging php-pdo_pgsql-5.6.38->5.6.39 (ok)
Merging php-pgsql-5.6.38->5.6.39 (ok)
partial-php-5.6.39+partial-php-gd-5.6.39+php-5.6.38p0+php-apache-5.6.38+php-gd-5.6.38+php-pdo_pgsql-5.6.38+php-pgsql-5.6.38->php-5.6.39+php-apache-5.6.39+php-gd-5.6.39+php-pdo_pgsql-5.6.39+php-pgsql-5.6.39: ok
Read shared items: ok
--- -php-5.6.38p0 -------------------
You should also run rm -f /etc/php-5.6/php-5.6.sample/*
thinkpad$
{% endhighlight %}


-   Setting file .cvsrc

{% highlight text %}
muntaza@E202SA:~$ cat ~/.cvsrc
# $OpenBSD: dot.cvsrc,v 1.1 2013/03/31 21:46:53 espie Exp $
#
cvs -d muntaza@openbsd.muntaza.id:/home/muntaza/data/cvsroot
diff -uNp
update -Pd
checkout -P
muntaza@E202SA:~$ scp /home/muntaza/.cvsrc muntaza@192.168.0.1:~
.cvsrc                                                                      100%  156   159.4KB/s   00:00
muntaza@E202SA:~$
{% endhighlight %}



-   Checkout Aplikasi Menu Entry OpenAset

{% highlight text %}
thinkpad$ cvs co kabupaten
{% endhighlight %}

-   Konfigurasi Database PostgreSQL

{% highlight text %}
thinkpad$ doas su _postgresql
thinkpad$ cd
thinkpad$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
thinkpad$ pwd
/var/postgresql
thinkpad$ ls
thinkpad$ mkdir data
thinkpad$ ls -l
total 8
drwxr-xr-x  2 _postgresql  _postgresql  512 Feb 16 14:47 data
thinkpad$ initdb -D /var/postgresql/data -U _postgresql -A md5 -W
The files belonging to this database system will be owned by user "_postgresql".
This user must also own the server process.

The database cluster will be initialized with locale "C".
The default database encoding has accordingly been set to "SQL_ASCII".
The default text search configuration will be set to "english".

Data page checksums are disabled.

Enter new superuser password:
Enter it again:

fixing permissions on existing directory /var/postgresql/data ... ok

creating subdirectories ... ok
selecting default max_connections ... 30
selecting default shared_buffers ... 128MB
selecting dynamic shared memory implementation ... posix
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctl -D /var/postgresql/data -l logfile start

thinkpad$



thinkpad$ exit
thinkpad$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza), 0(wheel)
thinkpad$ doas rcctl restart postgresql
postgresql(ok)
thinkpad$
{% endhighlight %}

-   Konfigurasi dan Aktivasi PHP pada Apache2

{% highlight text %}
thinkpad$ cd /etc/php-5.6.sample/
thinkpad$ ls
gd.ini         opcache.ini    pdo_pgsql.ini  pgsql.ini
thinkpad$ doas cp *.ini /etc/php-5.6
thinkpad$


thinkpad$ cd /var/www/conf/
thinkpad$ ls
bgplg.css      bgplg.foot     bgplg.head     modules        modules.sample
thinkpad$ doas cp modules.sample/php-5.6.conf modules
thinkpad$
{% endhighlight %}



-   Matikan layar setelah 60 detik

Karena ini adalah server fisik, maka tidak perlu layar monitor menyala selalu, 
jadi, kita setting agar bila 60 detik tidak aktif, layar monitor mati.

{% highlight text %}
thinkpad$ cd
thinkpad$ doas cp /etc/examples/wsconsctl.conf /etc/
doas (muntaza@thinkpad.example.com) password:
thinkpad$ doas vi /etc/wsconsctl.conf
thinkpad$ cat /etc/wsconsctl.conf
#       $OpenBSD: wsconsctl.conf,v 1.1 2014/07/16 13:21:33 deraadt Exp $
#
# wscons configurable parameters
#
#keyboard.repeat.del1=200       # change keyboard repeat/delay
#keyboard.repeat.deln=50
#keyboard.encoding=ru           # use different keyboard encoding
#keyboard.bell.volume=0         # mute keyboard beep
#display.vblank=on              # enable vertical sync blank for screen burner
display.screen_off=60000        # set screen burner timeout to 60 seconds
#display.msact=off              # disable screen unburn w/ mouse
thinkpad$
{% endhighlight %}


-   Setting NSD sebagai local DNS server


{% highlight text %}

thinkpad$ cat nsd.conf
server:
        hide-version: yes
        verbosity: 1
	    interface: 192.168.0.3


remote-control:
        control-enable: yes
        control-interface: /var/run/nsd.sock

zone:
        name: "example.com"
        zonefile: "master/example.com.zone"

zone:
        name: "0.168.192.in-addr.arpa"
        zonefile: "master/0.168.192.in-addr.arpa.zone"
thinkpad$ doas cp nsd.conf /var/nsd/etc/
thinkpad$




thinkpad$ doas cp *.zone /var/nsd/zones/master/
thinkpad$
thinkpad$ cat /var/nsd/zones/master/0.168.192.in-addr.arpa.zone
$TTL 86400
@       IN      SOA     aset.example.com.         root.localhost (
                        15      ; serial
                        28800   ; refresh
                        7200    ; retry
                        604800  ; expire
                        86400   ; ttl
                        )

@       IN      NS      192.168.0.3.

3       IN      PTR     aset.example.com.
thinkpad$
thinkpad$
thinkpad$ cat /var/nsd/zones/master/example.com.zone
$TTL 86400
@       IN      SOA     aset.example.com.         root.localhost (
                        15      ; serial
                        28800   ; refresh
                        7200    ; retry
                        604800  ; expire
                        86400   ; ttl
                        )

        IN      NS      aset
aset    IN      A       192.168.0.3
thinkpad$

{% endhighlight %}





-   Setting Unbound


{% highlight text %}
thinkpad$ cat /var/unbound/etc/unbound.conf
# $OpenBSD: unbound.conf,v 1.8 2018/03/29 20:40:22 florian Exp $

server:
        interface: 127.0.0.1


        access-control: 0.0.0.0/0 refuse
        access-control: 127.0.0.0/8 allow
        access-control: ::0/0 refuse
        access-control: ::1 allow

        hide-identity: yes
        hide-version: yes


        # Serve zones authoritatively from Unbound to resolver clients.
        # Not for external service.
        #
        local-zone: "example.com." static
        local-data: "aset.example.com. IN A 192.168.0.3"
        local-zone: "0.168.192.in-addr.arpa." static
        local-data-ptr: "192.168.0.3 aset.example.com"


remote-control:
        control-enable: yes
        control-use-cert: no
        control-interface: /var/run/unbound.sock

forward-zone:
        name: "."                               # use for ALL queries
        forward-addr: 8.8.8.8                   # google.com
        forward-first: yes                      # try direct if forwarder fails
thinkpad$
{% endhighlight %}


-   Aktifkan Unbound dan verifikasi service apa saja yang aktif

{% highlight text %}
thinkpad$
thinkpad$ doas rcctl set unbound status on
thinkpad$ cat /etc/rc.conf.local
httpd_flags=
nsd_flags=
ntpd_flags=-s
pkg_scripts=postgresql
unbound_flags=
thinkpad$
{% endhighlight %}


-   Setting DNS local mengarah ke Local Unbound DNS Local Server

{% highlight text %}
thinkpad$ cat /etc/resolv.conf
lookup file bind
nameserver 127.0.0.1
thinkpad$
{% endhighlight %}



-   Verifikasi DNS dengan program __dig__ ke NSD server

{% highlight text %}
thinkpad$ dig @192.168.0.3 aset.example.com

; <<>> DiG 9.4.2-P2 <<>> @192.168.0.3 aset.example.com
; (1 server found)
;; global options:  printcmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45519
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;aset.example.com.                IN      A

;; ANSWER SECTION:
aset.example.com. 86400   IN      A       192.168.0.3

;; AUTHORITY SECTION:
example.com.      86400   IN      NS      aset.example.com.

;; Query time: 0 msec
;; SERVER: 192.168.0.3#53(192.168.0.3)
;; WHEN: Thu Feb 28 15:16:17 2019
;; MSG SIZE  rcvd: 70
{% endhighlight %}

-   Verifikasi DNS dengan program __dig__ ke Unbound server


{% highlight text %}
thinkpad$
thinkpad$ dig @127.0.0.1 aset.example.com

; <<>> DiG 9.4.2-P2 <<>> @127.0.0.1 aset.example.com
; (1 server found)
;; global options:  printcmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54967
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;aset.example.com.                IN      A

;; ANSWER SECTION:
aset.example.com. 3600    IN      A       192.168.0.3

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Thu Feb 28 15:16:29 2019
;; MSG SIZE  rcvd: 56

thinkpad$


{% endhighlight %}


-   Konfigurasi Server untuk automatic Shutdown ketika battery kritis


{% highlight text %}

thinkpad# chmod +x cek_shutdown5.py
thinkpad# ls -l
total 4
-rwxr-xr-x  1 root  wheel  747 Feb 17 06:48 cek_shutdown5.py
thinkpad# pwd
/root/bin
thinkpad# ls
cek_shutdown5.py
thinkpad# cat cek_shutdown5.py
#!/usr/local/bin/python

import os
from subprocess import Popen
from subprocess import PIPE
from subprocess import call

total = os.popen('sysctl hw.sensors.acpibat0.watthour0 | cut -b 31-35')
sisa = os.popen('sysctl hw.sensors.acpibat0.watthour3 | cut -b 31-35')

persen = round(100 * (float(sisa.read(5)) / float(total.read(5))), 2)
#print 'sisa baterai ', persen, '%'

p1 = Popen(["sysctl", "hw.sensors.acpibat0"], stdout=PIPE)
p2 = Popen(["grep", "discharging"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
output = p2.communicate()[0]

if output and (persen < 15):
    print "SHUTDOWN 15%"
    call(["/sbin/halt", "-p"])

if persen < 5:
    print "SHUTDOWN 5%"
    call(["/sbin/halt", "-p"])
thinkpad#


{% endhighlight %}

-   Atur izin akses pada Server Database PostgreSQL

    User *_postgresql* dapat mengakses server tanpa password. Hal
    ini berguna untuk proses back up database secara automatis.

{% highlight text %}
thinkpad$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
thinkpad$ pwd
/var/postgresql/data
thinkpad$ cat pg_hba.conf | grep local| grep peer
local   all             all                                     peer
thinkpad$


# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5

{% endhighlight %}

-   Restore database Aplikasi OpenAset

{% highlight text %}
thinkpad$ psql -U _postgresql template1 < 2019_02_28_11_18.sql
{% endhighlight %}


-   Disable OpenBSD httpd server

{% highlight text %}
thinkpad$ doas rcctl disable httpd
doas (muntaza@thinkpad.example.com) password:
thinkpad$ cat /etc/rc.conf.local
nsd_flags=
ntpd_flags=-s
pkg_scripts=postgresql
unbound_flags=
thinkpad$
{% endhighlight %}


-   Setting Apache2 pada file _httpd2.conf_

{% highlight text %}
thinkpad$ diff  httpd2.conf httpd2.conf_asli
52c52
< #Listen 80
---
> Listen 80
91c91
< LoadModule socache_shmcb_module /usr/local/lib/apache2/mod_socache_shmcb.so
---
> #LoadModule socache_shmcb_module /usr/local/lib/apache2/mod_socache_shmcb.so
148c148
< LoadModule ssl_module /usr/local/lib/apache2/mod_ssl.so
---
> #LoadModule ssl_module /usr/local/lib/apache2/mod_ssl.so
522c522
< Include /etc/apache2/extra/httpd-ssl.conf
---
> #Include /etc/apache2/extra/httpd-ssl.conf
thinkpad$


{% endhighlight %}

-   Setting _postgresql.conf_

{% highlight text %}

thinkpad$ diff postgresql.conf postgresql.conf_back_up
113,114c113
< #shared_buffers = 128MB                       # min 128kB
< shared_buffers = 738MB                        # min 128kB
---
> shared_buffers = 128MB                        # min 128kB
120d118
< max_prepared_transactions = 30                # zero disables the feature
125d122
< work_mem = 16MB                               # min 64kB
311d307
< random_page_cost = 1.7                        # same scale as above
320d315
< effective_cache_size = 512MB


{% endhighlight %}

-   Disable fingerprint pada Apache2

{% highlight text %}
thinkpad$ diff httpd-default.conf httpd-default.conf_asli
55c55
< ServerTokens Prod
---
> ServerTokens Full
thinkpad$

{% endhighlight %}



-   Crotab user *_postgresql* untuk back_up automatic


{% highlight text %}
thinkpad$ crontab -l
#minute hour    mday    month   wday    command


# Back up database
10      0       *       *       *       sh /var/postgresql/back_up_kabupaten/back_up_kabupaten.sh
20      0       *       *       *       sh /var/postgresql/back_up_persediaan/back_up_persediaan.sh
30      0       *       *       *       sh /var/postgresql/back_up_persediaan_2019/back_up_persediaan_2019.sh
thinkpad$
{% endhighlight %}



-   Crotab root user

{% highlight text %}
thinkpad$ cat crontab
#
SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin
HOME=/var/log
#
#minute hour    mday    month   wday    command
#
# rotate log files every hour, if necessary
0       *       *       *       *       /usr/bin/newsyslog
# send log file notifications, if necessary
#1-59   *       *       *       *       /usr/bin/newsyslog -m
#
# do daily/weekly/monthly maintenance
30      1       *       *       *       /bin/sh /etc/daily
30      3       *       *       6       /bin/sh /etc/weekly
30      5       1       *       *       /bin/sh /etc/monthly
#0      *       *       *       *       sleep $((RANDOM \% 2048)) && /usr/libexec/spamd-setup

# Matikan server bila baterai kurang dari 15%
*/3     *       *       *       *       /root/bin/cek_shutdown5.py


# Matikan Apache server jam 0:0
0       0       *       *       *       rcctl stop apache2 > /dev/null 2>&1
5       0       *       *       *       rcctl stop apache2 > /dev/null 2>&1


# Restart Apache server jam 0:40
40      0       *       *       *       rcctl restart apache2 > /dev/null 2>&1

# Setting jam tiap 15 Menit
*/15    *       *       *       *       rdate 2.id.pool.ntp.org > /dev/null

# Ping tiap 5 Menit
*/5     *       *       *       *       ping -c3 x.x.x.x 1> /dev/null 2>&1
thinkpad$

{% endhighlight %}


Nah, inilah yang dapat saya tuliskan, semoga bermanfaat. Aamiin


# Alhamdulillah
