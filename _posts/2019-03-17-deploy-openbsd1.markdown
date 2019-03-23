---
layout: post
title:  "Deploy OpenPersediaan pada OpenBSD di Cloud"
date:   2019-03-17 12:26:56 +0800
categories: openbsd
---

# Bismillah,

Pada Masa yang lalu, di tahun 2008, lebih dari 10 tahun yang lalu, saya pernah menulis toturial di wordpress terkait instalasi OpenBSD versi 4.2. Artikel tersebut bisa di lihat di [sini](https://muntaza.wordpress.com/2008/03/16/menginstall-openbsd-42/). Pada saat tulisan tersebut di buat, Instalasi OpenBSD masih harus membuat iso sendiri, he... he...

Saat ini, di tahun 2019, Alhamdulillah, sudah sangat mudah sekali menginstall OpenBSD. OpenBSD yang saya jelaskan pada tutorial kali ini adalah versi 6.4. Sebagaimana tulisan 10 tahun yang lalu, saya berharap tulisan saya kali ini bermanfaat dan bisa di ambil faedahnya untuk saya sendiri atau orang lain di masa mendatang.

Setelah instalasi OpenBSD pada VPS, perlu langkah-langkah penting yang telah saya jelaskan pada tulisan
[ini](https://www.muntaza.net/openbsd/ssh/2018/12/09/public-key-only-ssh-openbsd.html).
Hal terpenting, adalah mengaktifkan Public Key Only Authentication.


{% highlight bash %}
Last login: Sun Feb  3 16:55:34 2019 from 114.4.217.242
OpenBSD 6.4 (GENERIC.MP) #6: Sat Jan 26 20:37:44 CET 2019

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

{% endhighlight %}


Setelah berhasil login, kita mulai proses instalasi paket-paket yang di butuhkan untuk deploying OpenPersediaan ini, paket pertama yang di install pada contoh ini adalah rsync, karena paket ini berfungsi untuk mendownload hasil backup postgresql.


{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add rsync
doas (muntaza@persediaan.example.com) password:
quirks-3.16 signed on 2018-10-12T15:26:25Z
quirks-3.16: ok
Ambiguous: choose package for rsync
a       0: <None>
        1: rsync-3.1.3
        2: rsync-3.1.3-iconv
Your choice: 1
rsync-3.1.3: ok
The following new rcscripts were installed: /etc/rc.d/rsyncd
See rcctl(8) for details.
persediaan$
{% endhighlight %}


Install syspatch terbaru, dan cek syspatch yang terinstall

{% highlight bash %}
persediaan$ syspatch -l
001_xserver
002_syspatch
003_portsmash
004_lockf
005_perl
006_uipc
007_smtpd
008_qcow2
009_recvwait
010_pcbopts
011_mincore
012_nfs
013_unveil
persediaan$
{% endhighlight %}

Di sini saya menginstall vim, saya pilih yang mendukung python2, yaitu varian vim no.9, sehingga python2 nya sekalian terinstall. Saya pun melakukan soft link dengan perintah ln ke python2.

{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add vim
quirks-3.16 signed on 2018-10-12T15:26:25Z
Ambiguous: choose package for vim
a       0: <None>
        1: vim-8.1.0438-gtk2
        2: vim-8.1.0438-gtk2-lua
        3: vim-8.1.0438-gtk2-perl-python-ruby
        4: vim-8.1.0438-gtk2-perl-python3-ruby
        5: vim-8.1.0438-no_x11
        6: vim-8.1.0438-no_x11-lua
        7: vim-8.1.0438-no_x11-perl-python-ruby
        8: vim-8.1.0438-no_x11-perl-python3-ruby
        9: vim-8.1.0438-no_x11-python
        10: vim-8.1.0438-no_x11-python3
        11: vim-8.1.0438-no_x11-ruby
Your choice: 9
vim-8.1.0438-no_x11-python:libiconv-1.14p3: ok
vim-8.1.0438-no_x11-python:gettext-0.19.8.1p1: ok
vim-8.1.0438-no_x11-python:sqlite3-3.24.0p0: ok
vim-8.1.0438-no_x11-python:libffi-3.2.1p4: ok
vim-8.1.0438-no_x11-python:bzip2-1.0.6p9: ok
vim-8.1.0438-no_x11-python:python-2.7.15p0: ok
vim-8.1.0438-no_x11-python: ok
--- +python-2.7.15p0 -------------------
If you want to use this package as your default system python, as root
create symbolic links like so (overwriting any previous default):
 ln -sf /usr/local/bin/python2.7 /usr/local/bin/python
 ln -sf /usr/local/bin/python2.7-2to3 /usr/local/bin/2to3
 ln -sf /usr/local/bin/python2.7-config /usr/local/bin/python-config
 ln -sf /usr/local/bin/pydoc2.7  /usr/local/bin/pydoc
persediaan$


persediaan$ doas ln -sf /usr/local/bin/python2.7 /usr/local/bin/python
persediaan$ doas ln -sf /usr/local/bin/python2.7-2to3 /usr/local/bin/2to3
persediaan$ doas ln -sf /usr/local/bin/python2.7-config /usr/local/bin/python-config
persediaan$ doas ln -sf /usr/local/bin/pydoc2.7  /usr/local/bin/pydoc
{% endhighlight %}


Untuk Menginstall Django, saya menggunakan py-pip. paket py-pip ini telah tertinggal versi nya di repo OpenBSD 6.4 ini, he... he..., oleh karena itu pip ini akan kita update setelah ini, in syaa Allah.

{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add py-pip
quirks-3.16 signed on 2018-10-12T15:26:25Z
py-pip-9.0.3:py-setuptools-40.0.0v0: ok
py-pip-9.0.3: ok
--- +py-pip-9.0.3 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
persediaan$ doas ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
persediaan$
{% endhighlight %}


Tahap upgrade pip, cukup mudah bukan?

{% highlight bash %}
persediaan$ doas pip install --upgrade pip
Collecting pip
  Downloading https://files.pythonhosted.org/packages/46/dc/7fd5df840efb3e56c8b4f768793a237ec4ee59891959d6a215d63f727023/pip-19.0.1-py2.py3-none-any.whl (1.4MB)
    100% |################################| 1.4MB 348kB/s
Installing collected packages: pip
  Found existing installation: pip 9.0.3
    Uninstalling pip-9.0.3:
      Successfully uninstalled pip-9.0.3
Successfully installed pip-19.0.1
persediaan$
{% endhighlight %}

Validasi versi pip sekarang, meningkat jauh dari versi 9.0.3 ke versi 19.0.1. Perhatikan bahwa karena python2 akan berakhir di 2020, maka setiap kali menjalankan pip ini akan di beri warning terkait python2 ini, dan disarankan untuk mulai beralih ke python3.

{% highlight bash %}
persediaan$ pip --version
pip 19.0.1 from /usr/local/lib/python2.7/site-packages/pip (python 2.7)
persediaan$
{% endhighlight %}


Proses instalasi Django, versi yang kita gunakan di tulis saat instalasi. Kalau ada update dari Django, tinggal ketik command yang sama dengan menuliskan versi yang terbaru, pip akan mendelete versi lama dan menginstall versi baru.

{% highlight bash %}
persediaan$ doas pip install Django==1.11.18
Collecting Django==1.11.18
  Downloading https://files.pythonhosted.org/packages/e0/eb/6dc122c6d0a82263bd26bebae3cdbafeb99a7281aa1dae57ca1f645a9872/Django-1.11.18-py2.py3-none-any.whl (6.9MB)
    100% |################################| 7.0MB 770kB/s
Collecting pytz (from Django==1.11.18)
  Downloading https://files.pythonhosted.org/packages/61/28/1d3920e4d1d50b19bc5d24398a7cd85cc7b9a75a490570d5a30c57622d34/pytz-2018.9-py2.py3-none-any.whl (510kB)
    100% |################################| 512kB 2.1MB/s
Installing collected packages: pytz, Django
Successfully installed Django-1.11.18 pytz-2018.9
{% endhighlight %}

Verifikasi versi Django yang terinstall

{% highlight bash %}
persediaan$ django-admin --version
1.11.18
persediaan$
{% endhighlight %}

Proses instalasi apache2, inilah web server yang kita gunakan untuk deploy django dan php reportico 4.6 sebagai report engine aplikasi OpenPersediaan.

{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add apache-httpd
quirks-3.16 signed on 2018-10-12T15:26:25Z
apache-httpd-2.4.35:pcre-8.41: ok
apache-httpd-2.4.35:nghttp2-1.33.0: ok
apache-httpd-2.4.35:curl-7.61.1: ok
apache-httpd-2.4.35:xz-5.2.4: ok
apache-httpd-2.4.35:libxml-2.9.8p0: ok
apache-httpd-2.4.35:brotli-1.0.5: ok
apache-httpd-2.4.35:db-4.6.21p5v0: ok
apache-httpd-2.4.35:apr-1.6.3p0: ok
apache-httpd-2.4.35:apr-util-1.6.1p0: ok
apache-httpd-2.4.35:jansson-2.11: ok
apache-httpd-2.4.35:apache-httpd-common-2.4.35: ok
apache-httpd-2.4.35: ok
Running tags: ok
The following new rcscripts were installed: /etc/rc.d/apache2
See rcctl(8) for details.
{% endhighlight %}


Sempat salah ketik password sodara-sodara, he...he..., tetap saya tampilkan error Authentication failed, bila salah mengetikkan password ketika menjalankan perintah doas.

Di sini saya menginstall php beserta add-on nya, yaitu php-gd, php-pgsql dan php-pdo_pgsql. Adapun paket php-apache2, paket ini baru ada di OpenBSD 6.4, hanya berisi script untuk aktivasi php di apache2.

{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add php-gd php-pdo_pgsql php-pgsql php-apache
doas (muntaza@persediaan.example.com) password:
doas: Authorization failed
persediaan$ doas /usr/sbin/pkg_add php-gd php-pdo_pgsql php-pgsql php-apache
doas (muntaza@persediaan.example.com) password:
quirks-3.16 signed on 2018-10-12T15:26:25Z
Ambiguous: choose package for php-gd
a       0: <None>
        1: php-gd-5.6.38
        2: php-gd-7.0.32p1
        3: php-gd-7.1.22
        4: php-gd-7.2.10
Your choice: 1
php-gd-5.6.38:t1lib-5.1.2p0: ok
php-gd-5.6.38:femail-1.0p1: ok
php-gd-5.6.38:femail-chroot-1.0p3: ok
php-gd-5.6.38:oniguruma-6.9.0: ok
php-gd-5.6.38:php-5.6.38p0: ok
php-gd-5.6.38:jpeg-2.0.0v0: ok
php-gd-5.6.38:png-1.6.35: ok
php-gd-5.6.38: ok
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
persediaan$
{% endhighlight %}


Instalasi Postgresql, versi yang ada di OpenBSD 6.4 adalah 10.5


{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add postgresql-server postgresql-contrib
quirks-3.16 signed on 2018-10-12T15:26:25Z
useradd: Warning: home directory `/var/postgresql' doesn't exist, and -m was not specified
postgresql-server-10.5p4: ok
postgresql-contrib-10.5p0: ok
The following new rcscripts were installed: /etc/rc.d/postgresql
See rcctl(8) for details.
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/postgresql-server
persediaan$
{% endhighlight %}


Mod_wsgi berguna sebagai penghubung antara python dan apache2. Di sini saya menampilkan isi file /etc/installurl, file ini berisi alamat repo OpenBSD untuk proses instalasi paket dan lainnya, yang mana sebelumnya menggunakan PKG_PATH di file .profile untuk mengarahkan repo instalasi paket.

{% highlight bash %}
persediaan$ cat /etc/installurl
https://cloudflare.cdn.openbsd.org/pub/OpenBSD
persediaan$ doas /usr/sbin/pkg_add ap2-mod_wsgi
ap2-mod_wsgi-4.6.4p0: ok
New and changed readme(s):
        /usr/local/share/doc/pkg-readmes/ap2-mod_wsgi
persediaan$
{% endhighlight %}



Instalasi Psycopg2, aplikasi penghubung Python ke Postgresql. Menggunakan pip sebagai installer.

{% highlight bash %}
persediaan$ doas pip install psycopg2
Collecting psycopg2
  Downloading https://files.pythonhosted.org/packages/63/54/c039eb0f46f9a9406b59a638415c2012ad7be9b4b97bfddb1f48c280df3a/psycopg2-2.7.7.tar.gz (427kB)
    100% |################################| 430kB 2.3MB/s
Installing collected packages: psycopg2
  Running setup.py install for psycopg2 ... done
Successfully installed psycopg2-2.7.7
persediaan$
{% endhighlight %}


menampilkan paket paket yang terinstall melalui pip.

{% highlight bash %}
persediaan$ pip list
Package    Version
---------- -------
Django     1.11.18
pip        19.0.1
psycopg2   2.7.7
pytz       2018.9
setuptools 40.0.0
persediaan$
{% endhighlight %}


Instalasi wget, wget ini berguna untuk mendownload file dari luar. Saya menggunakan wget untuk mendownload openup. Openup ini berguna untuk mendapatkan paket yang telah di patch yang tidak tersedia binary nya di repo OpenBSD.


{% highlight bash %}
persediaan$ doas /usr/sbin/pkg_add wget
quirks-3.16 signed on 2018-10-12T15:26:25Z
wget-1.19.5:libunistring-0.9.7: ok
wget-1.19.5:libidn2-2.0.0p0: ok
wget-1.19.5:libpsl-0.17.0: ok
wget-1.19.5: ok
persediaan$
persediaan$
persediaan$ wget -c https://stable.mtier.org/openup
--2019-02-03 17:52:37--  https://stable.mtier.org/openup
Resolving stable.mtier.org (stable.mtier.org)... 80.249.160.224, 2001:4c48:2:8001::5
Connecting to stable.mtier.org (stable.mtier.org)|80.249.160.224|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 11450 (11K) [application/octet-stream]
Saving to: 'openup'

openup    100%[=====================>]  11.18K  --.-KB/s    in 0s

2019-02-03 17:52:38 (50.6 MB/s) - 'openup' saved [11450/11450]

persediaan$
{% endhighlight %}

Menjalankan openup, terlihat bahwa openup mengupgrade php-5.6.38 ke php-5.6.39

{% highlight bash %}
persediaan$ doas sh openup
===> Checking for openup update
===> Downloading and installing public key
===> Installing/updating syspatches
===> Updating package(s)
quirks-3.17 signed on 2018-11-16T12:23:49Z
quirks-3.16->3.17: ok
curl-7.61.1->7.61.1p0: ok
php-5.6.38p0->5.6.39 forward dependencies:
| Dependencies of php-gd-5.6.38 on php-5.6.38 don't match
| Dependencies of php-pgsql-5.6.38 on php-5.6.38 don't match
| Dependencies of php-apache-5.6.38 on php-5.6.38 don't match
| Dependencies of php-pdo_pgsql-5.6.38 on php-5.6.38 don't match
Merging php-gd-5.6.38->5.6.39 (ok)
Merging php-pgsql-5.6.38->5.6.39 (ok)
Merging php-apache-5.6.38->5.6.39 (ok)
Merging php-pdo_pgsql-5.6.38->5.6.39 (ok)
php-5.6.38p0+php-apache-5.6.38+php-gd-5.6.38+php-pdo_pgsql-5.6.38+php-pgsql-5.6.38->php-5.6.39+php-apache-5.6.39+php-gd-5.6.39+php-pdo_pgsql-5.6.39+php-pgsql-5.6.39: ok
Read shared items: ok
--- -php-5.6.38p0 -------------------
You should also run rm -f /etc/php-5.6/php-5.6.sample/*
persediaan$
{% endhighlight %}

Proses konfigurasi Postgresql server. OpenBSD telah menyediakan user _postgresql untuk mengadministrasi Postgresql server. Saya pindah dulu ke user _postgresql sebelum melakukan initdb.



{% highlight bash %}
persediaan$ doas su _postgresql
persediaan$ cd
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ ls
persediaan$ pwd
/var/postgresql
persediaan$ mkdir data
persediaan$ ls -l
total 4
drwxr-xr-x  2 _postgresql  _postgresql  512 Feb  3 18:10 data
persediaan$ initdb -D /var/postgresql/data -U _postgresql -A md5 -W
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

persediaan$
{% endhighlight %}

Setelah initdb selesai, saya kembali ke user muntaza.

{% highlight bash %}
persediaan$ exit
persediaan$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza), 0(wheel)
persediaan$
{% endhighlight %}


Proses mengaktifkan php dan modul-modulnya.

{% highlight bash %}
persediaan$ cd /etc/php-5.6.sample/
persediaan$ ls
gd.ini        opcache.ini   pdo_pgsql.ini pgsql.ini
persediaan$ doas cp *.ini /etc/php-5.6
persediaan$ cd /var/www/conf/
persediaan$ ls
bgplg.css       bgplg.foot      bgplg.head      modules         modules.sample
persediaan$ doas cp modules.sample/php-5.6.conf modules
persediaan$ ls modules
php-5.6.conf
persediaan$
{% endhighlight %}


Ini setting untuk mendapatkan sertifikat ssl gratis dari let's enscript. Kita disable dulu ssl pada file httpd.conf. Fili ini adalah file konfigurasi web server httpd bawaan dari OpenBSD, bukan web server Apache2.


{% highlight bash %}
persediaan$ cat httpd.conf
# $OpenBSD: httpd.conf,v 1.20 2018/06/13 15:08:24 reyk Exp $

server "persediaan.example.com" {
        listen on * port 80
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }
#       location * {
#               block return 302 "https://$HTTP_HOST$REQUEST_URI"
#       }
}

#server "persediaan.example.com" {
#       listen on * tls port 443
#       tls {
#               certificate "/etc/ssl/persediaan.example.com.fullchain.pem"
#               key "/etc/ssl/private/persediaan.example.com.key"
#       }
#       location "/pub/*" {
#               directory auto index
#       }
#       location "/.well-known/acme-challenge/*" {
#               root "/acme"
#               request strip 2
#       }
#}
{% endhighlight %}

Setting acme-client.conf, mendefinisikan posisi file-file sertifikat ssl.


{% highlight bash %}
persediaan$ cat acme-client.conf
#
# $OpenBSD: acme-client.conf,v 1.7 2018/04/13 08:24:38 ajacoutot Exp $
#
authority letsencrypt {
        api url "https://acme-v01.api.letsencrypt.org/directory"
        account key "/etc/acme/letsencrypt-privkey.pem"
}

authority letsencrypt-staging {
        api url "https://acme-staging.api.letsencrypt.org/directory"
        account key "/etc/acme/letsencrypt-staging-privkey.pem"
}

domain persediaan.example.com {
        domain key "/etc/ssl/private/persediaan.example.com.key"
        domain certificate "/etc/ssl/persediaan.example.com.crt"
        domain full chain certificate "/etc/ssl/persediaan.example.com.fullchain.pem"
        sign with letsencrypt
}
persediaan$ doas rcctl -f restart httpd
httpd(ok)
httpd(ok)
persediaan$
{% endhighlight %}


OpenBSD Httpd server kita restart, sehingga bisa di akses dari luar untuk verifikasi sertifikat ssl, kita lalu menjalankan program acme-client seperti contoh di bawah ini.

{% highlight bash %}
persediaan$ doas acme-client -vAD persediaan.example.com
acme-client: /etc/acme/letsencrypt-privkey.pem: generated RSA account key
acme-client: /etc/ssl/private/persediaan.example.com.key: generated RSA domain key
acme-client: https://acme-v01.api.letsencrypt.org/directory: directories
acme-client: acme-v01.api.letsencrypt.org: DNS: 203.217.134.29
acme-client: https://acme-v01.api.letsencrypt.org/acme/new-reg: new-reg
acme-client: https://acme-v01.api.letsencrypt.org/acme/new-authz: req-auth: persediaan.example.com
acme-client: /var/www/acme/BWW8Gm5ZECoaUWlrt7Slkti0U-qKlL0TUG85Vgvhf04: created
acme-client: https://acme-v01.api.letsencrypt.org/acme/challenge/HETrIsgLknrL1h5omy61fYH6ivP3ak0pdtu84kkmGnc/12195442253: challenge
acme-client: https://acme-v01.api.letsencrypt.org/acme/challenge/HETrIsgLknrL1h5omy61fYH6ivP3ak0pdtu84kkmGnc/12195442253: status
acme-client: https://acme-v01.api.letsencrypt.org/acme/new-cert: certificate
acme-client: http://cert.int-x3.letsencrypt.org/: full chain
acme-client: cert.int-x3.letsencrypt.org: DNS: 103.5.215.55
acme-client: /etc/ssl/persediaan.example.com.crt: created
acme-client: /etc/ssl/persediaan.example.com.fullchain.pem: created
{% endhighlight %}


Setelah file sertifikat ssl kita dapatkan, di sini saya mencoba mengaktifkan ssl pada OpenBSD Httpd web server, untuk memastikan bahwa file sertifikat dari Let's Enscript ini berfungsi. File ini hanya sementara saja, saya nanti akan memperlihatkan cara membuat file .csr untuk pesan sertifikat berbayar dari Comodo.


{% highlight bash %}
persediaan$ cat /etc/httpd.conf
# $OpenBSD: httpd.conf,v 1.20 2018/06/13 15:08:24 reyk Exp $

server "persediaan.example.com" {
        listen on * port 80
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }
        location * {
                block return 302 "https://$HTTP_HOST$REQUEST_URI"
        }
}

server "persediaan.example.com" {
        listen on * tls port 443
        tls {
                certificate "/etc/ssl/persediaan.example.com.fullchain.pem"
                key "/etc/ssl/private/persediaan.example.com.key"
        }
        location "/pub/*" {
                directory auto index
        }
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }
}
persediaan$
{% endhighlight %}

Restart OpenBSD Httpd, lalu test koneksi ke webserver. Bila telah berhasil koneksi ke post 443 (https) berarti sertifikat ssl sudah terinstall dengan  benar.

{% highlight bash %}
persediaan$ doas rcctl -f restart httpd
httpd(ok)
httpd(ok)
{% endhighlight %}


Saya mengaktifkan Postgresql dan Apache2 dengan program rcctl. Sebenarnya saya bisa langsung mengedit file rc.conf.local saja. Namun, disini saya contohkan dengan rcctl, karena dengan rcctl ini saya biasa merestart, menstop aplikasi server di OpenBSD. Perhatikan isi file rc.conf.local, sangat sederhana, itulah sebabnya saya memilih OpenBSD, karena menurut saya, inilah System Operasi paling mudah yang ada.

Perhatikan bahwa saya mendisable OpenBSD Httpd web server setelah mengaktifkan Apache2.

{% highlight bash %}
persediaan$ doas rcctl set postgresql status on
persediaan$ doas rcctl set apache2 status on
persediaan$ doas rcctl set httpd status off
persediaan$ cat /etc/rc.conf.local
pkg_scripts=postgresql apache2
{% endhighlight %}


Saatnya konfigurasi Apache2, file yang di edit adalah httpd2.conf di direktori /etc/apache2. Disini saya mendisable post 80, mengaktifkan modul socache_shmcb_module, dan mengaktifkan ssl.


{% highlight bash %}
persediaan$ pwd
/etc/apache2
persediaan$ diff httpd2.conf httpd2.conf_asli
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
persediaan$
{% endhighlight %}

Sebagai tambahan lain pada file httpd2.conf ini, saya menonaktifkan ServerSignature, sehingga kalau Web server ini di scan, ia tidak menampilkan versi Apache2 yang di gunakan, versi Python, PHP yang di gunakan. Kenapa begitu? Karena kadang ada bug di salah satu versi Apache2, yang bisa di serang dengan teknik Denial of Service, contoh [CVE-2019-0190](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-0190), suatu bug yang ada di versi 2.4.37 dan telah di perbaiki di versi 2.4.38. Sehingga adalah lebih baik untuk tidak menampilkan versi Apache2 yang kita gunakan.

{% highlight bash %}
persediaan$ tail -2 /etc/apache2/httpd2.conf
ServerSignature Off
ServerTokens Prod
persediaan$
{% endhighlight %}


Ini setting ssl, pada file httpd-ssl.conf, disini saya menggunakan SSLCipherSuite yang hanya mengaktifkan TLS v1.2, sehingga client harus update browser nya, baik Firefox atau Chrome ke versi terbaru yang mendukung TLS v1.2. Adapun SSL v2, SSL v3, TLS v1.1 sangat tidak di sarankan di gunakan. Lihat di [sini](https://www.globalsign.com/en/blog/disable-tls-10-and-all-ssl-versions/) terkait hal tersebut.

Kemudian saya setting agar meload module wsgi_module, dan setting di bawahnya adalah konfigurasi untuk deploying django.

{% highlight bash %}
persediaan$ diff httpd-ssl.conf httpd-ssl.conf_asli
52,53c52,53
< # SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
< # SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
---
> SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
> SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
65,66c65,66
< SSLCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
< SSLProxyCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
---
> # SSLCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
> # SSLProxyCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
89c89
< ServerName persediaan.example.com:443
< ServerAdmin muhammad@muntaza.id
---
> ServerName www.example.com:443
> ServerAdmin you@example.com
134,168d133
<
< #Konfigurasi Mod_WSGI agar bisa koneksi python dan httpd2 untuk persediaan5
<
< LoadModule wsgi_module         /usr/local/lib/apache2/mod_wsgi.so
<
<
<
< WSGIDaemonProcess persediaan_example python-path=/home/django/persediaan_example:/usr/local/lib/python2.7/site-packages
< WSGIProcessGroup persediaan_example
<
< WSGIScriptAlias /persediaan_example /home/django/persediaan_example/persediaan_example/wsgi.py process-group=persediaan_example
<
< Alias /robots.txt /home/django/persediaan_example/static/robots.txt
< Alias /favicon.ico /home/django/persediaan_example/static/favicon.ico
<
<
< #static pada https
< Alias /static_persediaan_example /home/django/persediaan_example/static/
<
< <Directory /home/django/persediaan_example/static>
< Require all granted
< </Directory>
<
< <Directory /home/django/persediaan_example/persediaan_example>
< <Files wsgi.py>
< Require all granted
< </Files>
< </Directory>
<
<
<
<
<
<
<
179c144
< SSLCertificateFile "/etc/ssl/persediaan.example.com.crt"
---
> SSLCertificateFile "/etc/apache2/server.crt"
189c154
< SSLCertificateKeyFile "/etc/ssl/private/persediaan.example.com.key"
---
> SSLCertificateKeyFile "/etc/apache2/server.key"
210c175
< SSLCACertificateFile "/etc/ssl/persediaan.example.com.fullchain.pem"
---
> #SSLCACertificateFile "/etc/apache2/ssl.crt/ca-bundle.crt"
235c200
{% endhighlight %}

Membuat folder django di folder /home, setting kepemilikan folder django ke user muntaza dan group www

{% highlight bash %}
persediaan$ doas mkdir django
persediaan$ doas chown -R muntaza:www django
persediaan$ ls -ld django
drwxr-xr-x  2 muntaza  www  512 Feb 24 11:44 django
persediaan$
{% endhighlight %}


Check out file program dari repository CVS.

{% highlight bash %}
persediaan$ cvs co persediaan_example
{% endhighlight %}


Mendisable md5 login untuk user local _postgresql, bila user _postgresql ini login ke system, bisa masuk ke server tanpa password. File yang di edit adalah pg_hba.conf, saya rubah local auth dari md5 menjadi peer. Koneksi dari user local ini ke file unix domain socket. Kenapa tanpa password untuk super admin database? karena saya mau mensetting backup database tiap tengah malam dengan cron menggunakan perintah pg_dump.

{% highlight bash %}
persediaan$ doas su _postgresql
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ cd
persediaan$ ls
data    logfile
persediaan$ cd data/
persediaan$ cp pg_hba.conf pg_hba.conf_asli
persediaan$ vi pg_hba.conf
persediaan$ diff pg_hba.conf pg_hba.conf_asli
80c80
< local   all             all                                     peer
---
> local   all             all                                     md5
persediaan$
{% endhighlight %}



{% highlight bash %}
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ exit
persediaan$ doas rcctl restart postgresql
postgresql(ok)
postgresql(ok)
persediaan$ psql
psql: FATAL:  role "muntaza" does not exist
persediaan$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza), 0(wheel)
persediaan$ doas su _postgresql
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ psql -t template1
psql (10.5)
Type "help" for help.

template1=#
{% endhighlight %}



{% highlight bash %}
persediaan$ psql -U _postgresql persediaan_example < persediaan_example_2019-02-24.sql
persediaan$ createdb -U _postgresql persediaan_example -O persediaan_example
persediaan$ psql -U _postgresql template1 < globals.sql
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ exit
persediaan$
{% endhighlight %}





{% highlight bash %}
persediaan$ doas chown -R www:www laporan_persediaan_example
persediaan$ cat /home/muntaza/bin/chmod_min.sh
chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
chmod -R ugo-w  /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
persediaan$ cat /home/muntaza/bin/chmod_plus.sh
chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
chmod -R g+w  /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
persediaan$ doas sh /home/muntaza/bin/chmod_plus.sh
persediaan$ doas sh /home/muntaza/bin/chmod_min.sh
persediaan$
{% endhighlight %}



security fitur pada Django

isi pada file settings.py


{% highlight bash %}
persediaan$ doas rcctl restart apache2
doas (muntaza@persediaan.example.com) password:
apache2(ok)
apache2(ok)
persediaan$ python manage.py check --deploy
System check identified no issues (0 silenced).
{% endhighlight %}


{% highlight bash %}
persediaan$ cvs diff -r 1.6 -r 1.9 persediaan_example/settings.py
Index: persediaan_example/settings.py
===================================================================
RCS file: /home/muntaza/data/cvsroot/persediaan_example/persediaan_example/settings.py,v
retrieving revision 1.6
retrieving revision 1.9
diff -u -p -r1.6 -r1.9
--- persediaan_example/settings.py   24 Feb 2019 04:15:00 -0000      1.6
+++ persediaan_example/settings.py   24 Feb 2019 22:50:48 -0000      1.9
@@ -140,3 +140,16 @@ THOUSAND_SEPARATOR = '.'
 # https://docs.djangoproject.com/en/1.11/howto/static-files/

 STATIC_URL = '/static_persediaan_example/'
+
+
+
+SECURE_HSTS_SECONDS=31536000
+SECURE_HSTS_INCLUDE_SUBDOMAINS=True
+SECURE_HSTS_PRELOAD=True
+SECURE_CONTENT_TYPE_NOSNIFF=True
+SECURE_BROWSER_XSS_FILTER=True
+SECURE_SSL_REDIRECT=True
+SESSION_COOKIE_SECURE=True
+CSRF_COOKIE_SECURE=True
+CSRF_COOKIE_HTTPONLY=True
+X_FRAME_OPTIONS='DENY'
persediaan$
{% endhighlight %}




{% highlight bash %}
persediaan$ psql -U _postgresql persediaan_example_2019
psql (10.5)
Type "help" for help.

persediaan_example_2019=# select * from persediaan
persediaan         persediaan_id_seq
persediaan_example_2019=# select * from persediaan;
 id | tanggal_kadaluarsa | jumlah | harga | id_barang | id_transaksi
----+--------------------+--------+-------+-----------+--------------
(0 rows)

persediaan_example_2019=# select * from keluar ;
 id_transaksi | id_jenis_keluar | id_pegawai
--------------+-----------------+------------
(0 rows)

persediaan_example_2019=# select * from masuk ;
 id_transaksi | id_asal_usul | id_pihak_ketiga
--------------+--------------+-----------------
(0 rows)

persediaan_example_2019=# select * from transaksi;
 id | tanggal | keterangan | id_jenis_transaksi | id_sub_skpd
----+---------+------------+--------------------+-------------
(0 rows)

persediaan_example_2019=# \q
persediaan$
{% endhighlight %}


pindah kepemilikan table dan view di dalam database baru ke user baru


{% highlight bash %}
REASSIGN OWNED BY persediaan_example TO persediaan_example_2019
{% endhighlight %}




{% highlight bash %}
persediaan$ doas openssl genrsa -out /etc/ssl/private/examplekota.key 2048
Generating RSA private key, 2048 bit long modulus
.........................................+++
.............................................................................+++
e is 65537 (0x10001)
persediaan$
persediaan$
persediaan$
persediaan$ doas openssl req -new -key /etc/ssl/private/examplekota.key \
>              -out /etc/ssl/private/examplekota.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []:ID
State or Province Name (full name) []:Kalimantan Selatan
Locality Name (eg, city) []:Example
Organization Name (eg, company) []:Pemda Kota Example
Organizational Unit Name (eg, section) []:Pemda Kota Example
Common Name (eg, fully qualified host name) []:persediaan.example.com
Email Address []:m.muntaza@gmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
persediaan$
{% endhighlight %}


cek isi:

{% highlight bash %}
persediaan$  openssl req -in examplekota.csr  -noout -text
{% endhighlight %}



enable hsts


{% highlight bash %}
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
{% endhighlight %}


{% highlight bash %}
persediaan$ wget -c http://www.ipdeny.com/ipblocks/data/countries/Copyrights.txt
--2019-03-09 23:08:33--  http://www.ipdeny.com/ipblocks/data/countries/Copyrights.txt
Resolving www.ipdeny.com (www.ipdeny.com)... 192.241.240.22
Connecting to www.ipdeny.com (www.ipdeny.com)|192.241.240.22|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3585 (3.5K) [text/plain]
Saving to: 'Copyrights.txt'

Copyrights.txt             100%[=======================================>]   3.50K  --.-KB/s    in 0s

2019-03-09 23:08:33 (39.8 MB/s) - 'Copyrights.txt' saved [3585/3585]

persediaan$ wget -c http://www.ipdeny.com/ipblocks/data/countries/id.zone
--2019-03-09 23:09:37--  http://www.ipdeny.com/ipblocks/data/countries/id.zone
Resolving www.ipdeny.com (www.ipdeny.com)... 192.241.240.22
Connecting to www.ipdeny.com (www.ipdeny.com)|192.241.240.22|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 39005 (38K)
Saving to: 'id.zone'

id.zone                    100%[=======================================>]  38.09K  71.0KB/s    in 0.5s

2019-03-09 23:09:39 (71.0 KB/s) - 'id.zone' saved [39005/39005]

persediaan$
{% endhighlight %}


{% highlight bash %}
persediaan$ cat pf.conf
#       $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

ext_if=vio0
services = "{ 22, 443 }"

set skip on lo
block return    # block stateless traffic

table <ip_safe> persist file "/etc/ip_safe"
pass out to <ip_safe>


table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/id.zone"

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $services  \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)



#Pass SSL Labs
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port 443


# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild
{% endhighlight %}




{% highlight bash %}
persediaan$ cat ip_safe
#DNS
8.8.8.8

#2.id.pool.ntp.org
202.65.114.202
114.141.48.158
103.31.225.225
203.89.31.13


#Default Gateway
xx.xx.xx.xxx


#openbsd.muntaza.id
xx.xx.xx.xxx
{% endhighlight %}


{% highlight bash %}
persediaan$ doas rcctl set ntpd flags -s
persediaan$ cat /etc/rc.conf.local
ntpd_flags=-s
pkg_scripts=postgresql apache2
{% endhighlight %}


{% highlight bash %}
persediaan$ cat /etc/ntpd.conf
# $OpenBSD: ntpd.conf,v 1.14 2015/07/15 20:28:37 ajacoutot Exp $
#
# See ntpd.conf(5) and /etc/examples/ntpd.conf

servers 2.id.pool.ntp.org
sensor *
persediaan$
{% endhighlight %}




{% highlight bash %}
persediaan$ diff httpd2.conf httpd2.conf_asli
5c5
< # In particular, see
---
> # In particular, see
11c11
< # consult the online docs. You have been warned.
---
> # consult the online docs. You have been warned.
18c18
< # server as "/usr/local/apache2/logs/access_log", whereas "/logs/access_log"
---
> # server as "/usr/local/apache2/logs/access_log", whereas "/logs/access_log"
48c48
< # Change this to Listen on specific IP addresses as shown below to
---
> # Change this to Listen on specific IP addresses as shown below to
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
185c185
< # httpd as root initially and it will switch.
---
> # httpd as root initially and it will switch.
226c226
< # explicitly permit access to web content directories in other
---
> # explicitly permit access to web content directories in other
284,285c284,285
< # The following lines prevent .htaccess and .htpasswd files from being
< # viewed by Web clients.
---
> # The following lines prevent .htaccess and .htpasswd files from being
> # viewed by Web clients.
338,339c338,339
<     # Redirect: Allows you to tell clients about documents that used to
<     # exist in your server's namespace, but do not anymore. The client
---
>     # Redirect: Allows you to tell clients about documents that used to
>     # exist in your server's namespace, but do not anymore. The client
356c356
<     # ScriptAlias: This controls which directories contain server scripts.
---
>     # ScriptAlias: This controls which directories contain server scripts.
468c468
< # EnableMMAP and EnableSendfile: On systems that support it,
---
> # EnableMMAP and EnableSendfile: On systems that support it,
471c471
< # be turned off when serving from networked-mounted
---
> # be turned off when serving from networked-mounted
481,483c481,483
< # The configuration files in the /etc/apache2/extra/ directory can be
< # included to add extra features or to modify the default configuration of
< # the server, or you may simply copy their contents here and change as
---
> # The configuration files in the /etc/apache2/extra/ directory can be
> # included to add extra features or to modify the default configuration of
> # the server, or you may simply copy their contents here and change as
522c522
< Include /etc/apache2/extra/httpd-ssl.conf
---
> #Include /etc/apache2/extra/httpd-ssl.conf
535,539d534
<
<
<
< ServerSignature Off
< ServerTokens Prod
persediaan$
{% endhighlight %}




{% highlight bash %}
persediaan$ diff httpd-ssl.conf_asli httpd-ssl.conf
4c4
< # serve pages over an https connection. For detailed information about these
---
> # serve pages over an https connection. For detailed information about these
6c6
< #
---
> #
9c9
< # consult the online docs. You have been warned.
---
> # consult the online docs. You have been warned.
33c33
< # When we also provide SSL we have to listen to the
---
> # When we also provide SSL we have to listen to the
52,53c52,53
< SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
< SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
---
> # SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
> # SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
59c59
< #  non-browser tooling) from successfully connecting.
---
> #  non-browser tooling) from successfully connecting.
65,66c65,66
< # SSLCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
< # SSLProxyCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
---
> SSLCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
> SSLProxyCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
72c72
< SSLHonorCipherOrder on
---
> SSLHonorCipherOrder on
89c89
< #   Configure the SSL Session Cache: First the mechanism
---
> #   Configure the SSL Session Cache: First the mechanism
125,126c125,126
< ServerName www.example.com:443
< ServerAdmin you@example.com
---
> ServerName persediaan.example.com:443
> ServerAdmin muhammad@muntaza.id
133a134,198
>
>
> Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
>
>
>
> #Konfigurasi Mod_WSGI agar bisa koneksi python dan httpd2 untuk persediaan5
>
> LoadModule wsgi_module         /usr/local/lib/apache2/mod_wsgi.so
>
>
>
> WSGIDaemonProcess persediaan_example python-path=/home/django/persediaan_example:/usr/local/lib/python2.7/site-packages
> WSGIProcessGroup persediaan_example
>
> WSGIScriptAlias /persediaan_example /home/django/persediaan_example/persediaan_example/wsgi.py process-group=persediaan_example
>
> Alias /robots.txt /home/django/persediaan_example/static/robots.txt
> Alias /favicon.ico /home/django/persediaan_example/static/favicon.ico
>
>
> #static pada https
> Alias /static_persediaan_example /home/django/persediaan_example/static/
>
> <Directory /home/django/persediaan_example/static>
> Require all granted
> </Directory>
>
> <Directory /home/django/persediaan_example/persediaan_example>
> <Files wsgi.py>
> Require all granted
> </Files>
> </Directory>
>
>
>
>
>
> # 2019
>
> WSGIDaemonProcess persediaan_example_2019 python-path=/home/django/persediaan_example_2019:/usr/local/lib/python2.7/site-packages
> WSGIProcessGroup persediaan_example_2019
>
> WSGIScriptAlias /persediaan_example_2019 /home/django/persediaan_example_2019/persediaan_example_2019/wsgi.py process-group=persediaan_example_2019
>
> Alias /robots.txt /home/django/persediaan_example_2019/static/robots.txt
> Alias /favicon.ico /home/django/persediaan_example_2019/static/favicon.ico
>
>
> #static pada https
> Alias /static_persediaan_example_2019 /home/django/persediaan_example_2019/static/
>
> <Directory /home/django/persediaan_example_2019/static>
> Require all granted
> </Directory>
>
> <Directory /home/django/persediaan_example_2019/persediaan_example_2019>
> <Files wsgi.py>
> Require all granted
> </Files>
> </Directory>
>
>
>
>
144c209
< SSLCertificateFile "/etc/apache2/server.crt"
---
> SSLCertificateFile "/etc/ssl/persediaan_example.com.crt"
154c219,220
< SSLCertificateKeyFile "/etc/apache2/server.key"
---
> #SSLCertificateKeyFile "/etc/ssl/private/persediaan.example.com.key"
> SSLCertificateKeyFile "/etc/ssl/private/examplekota.key"
175c241,242
< #SSLCACertificateFile "/etc/apache2/ssl.crt/ca-bundle.crt"
---
> #SSLCACertificateFile "/etc/ssl/persediaan.example.com.fullchain.pem"
> SSLCACertificateFile "/etc/ssl/persediaan_example.com.ca-bundle"
200c267
< #   file (containing login information for SRP user accounts).
---
> #   file (containing login information for SRP user accounts).
247c314
< #     directives are used in per-directory context.
---
> #     directives are used in per-directory context.
273c340
< #     works correctly.
---
> #     works correctly.
290c357
< </VirtualHost>
---
> </VirtualHost>
persediaan$
{% endhighlight %}




{% highlight bash %}
persediaan$ pwd
/var/postgresql
persediaan$ id
uid=503(_postgresql) gid=503(_postgresql) groups=503(_postgresql)
persediaan$ crontab -l
10      0       *       *       *       /var/postgresql/back_up_persediaan_example/back_up_persediaan_example.sh
20      0       *       *       *       /var/postgresql/back_up_persediaan_example_2019/back_up_persediaan_example_2019.sh
persediaan$ cat back_up_persediaan_example/back_up_persediaan_example.sh
#!/bin/ksh

# Back_up sql database persediaan_example

file=persediaan_example_`date +%F_%H_%M`.sql

pg_dump -U _postgresql persediaan_example > ~/back_up_persediaan_example/$file
bzip2 ~/back_up_persediaan_example/$file
persediaan$
persediaan$ cat back_up_persediaan_example_2019/back_up_persediaan_example_2019.sh
#!/bin/ksh

# Back_up sql database persediaan_example_2019

file=persediaan_example_2019_`date +%F_%H_%M`.sql

pg_dump -U _postgresql persediaan_example_2019 > ~/back_up_persediaan_example_2019/$file
bzip2 ~/back_up_persediaan_example_2019/$file
persediaan$
{% endhighlight %}






{% highlight bash %}
persediaan$ crontab -l
0       */2     *       *       *       sh /home/muntaza/bin/chmod_example_min.sh
persediaan$ cat /home/muntaza/bin/chmod_example_plus.sh
chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
chmod -R ug+w  /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/


chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example_2019/projects_persediaan_example_2019/
chmod -R ug+w  /var/www/htdocs/laporan_persediaan_example_2019/projects_persediaan_example_2019/
persediaan$ cat /home/muntaza/bin/chmod_example_min.sh
chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/
chmod -R ugo-w  /var/www/htdocs/laporan_persediaan_example/projects_persediaan_example/


chown -R muntaza:www /var/www/htdocs/laporan_persediaan_example_2019/projects_persediaan_example_2019/
chmod -R ugo-w  /var/www/htdocs/laporan_persediaan_example_2019/projects_persediaan_example_2019/
persediaan$
{% endhighlight %}










{% highlight bash %}
persediaan$ cat crontab2
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

# clear abusive_hosts table every 5 minute
*/5     *       *       *       *       /bin/sh /home/muntaza/bin/flush.sh

#stop apache2
0       0       *       *       *       rcctl stop apache2 > /dev/null 2> /dev/null
1       0       *       *       *       rcctl stop apache2 > /dev/null 2> /dev/null


#start apache2
40      0       *       *       *       rcctl restart apache2 > /dev/null 2> /dev/null
40      1       *       *       *       rcctl restart apache2 > /dev/null 2> /dev/null

#set clock on vm server every 15 minute
*/15    *       *       *       *       /usr/sbin/rdate 2.id.pool.ntp.org > /dev/null 2> /dev/null

#ping gateway every 5 minute
*/5     *       *       *       *       /sbin/ping -c3 xx.xx.xx.xxx > /dev/null
{% endhighlight %}




{% highlight bash %}
persediaan$ crontab -l
#10      0       *       *       *       /var/postgresql/back_up_persediaan_example/back_up_persediaan_example.sh
20      0       *       *       *       /var/postgresql/back_up_persediaan_example_2019/back_up_persediaan_example_2019.sh
persediaan$



persediaan$ cat /var/postgresql/back_up_persediaan_example_2019/back_up_persediaan_example_2019.sh
#!/bin/ksh

# Back_up sql database persediaan_example_2019

file=persediaan_example_2019_`date +%F_%H_%M`.sql

pg_dump -U _postgresql persediaan_example_2019 > ~/back_up_persediaan_example_2019/$file
bzip2 ~/back_up_persediaan_example_2019/$file
persediaan$
{% endhighlight %}



# Alhamdulillah
