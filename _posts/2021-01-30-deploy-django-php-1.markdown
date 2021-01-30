---
layout: post
title:  "Deploy Django dan PHP pada OpenBSD 6.8"
date:   2021-01-30 08:20:56 +0800
categories: openbsd
---

# Bismillah,

Ini adalah catatan saya saat melakukan instalasi aplikasi-aplikasi
untuk deploy OpenAset dan OpenPersediaan di OpenBSD. Versi OpenBSD
yang saya gunakan kali ini adalah versi 6.8. OK, langsung saya
jelaskan langkah-langkahnya:

Instalasi pip3, hal ini karena Python yang akan di gunakan adalah Python3:

```
pisang$ doas /usr/sbin/pkg_add py3-pip
quirks-3.440 signed on 2020-12-23T21:18:09Z
py3-pip-20.1.1p0:py3-setuptools-41.6.0p0v0: ok
py3-pip-20.1.1p0: ok
--- +py3-pip-20.1.1p0 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip3.8 /usr/local/bin/pip
pisang$ doas ln -sf /usr/local/bin/pip3.8 /usr/local/bin/pip

pisang$ doas pip install --upgrade pip
Collecting pip
  Downloading pip-20.3.3-py2.py3-none-any.whl (1.5 MB)
     |████████████████████████████████| 1.5 MB 693 kB/s
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 20.1.1
    Uninstalling pip-20.1.1:
      Successfully uninstalled pip-20.1.1
Successfully installed pip-20.3.3
pisang$

pisang$ pip --version
pip 20.3.3 from /usr/local/lib/python3.8/site-packages/pip (python 3.8)
```


Instalasi Apache2, PHP dan modul pendukungnya:
```
pisang$ doas /usr/sbin/pkg_add apache-httpd php-gd php-pdo_pgsql php-pgsql
quirks-3.440 signed on 2020-12-23T21:18:09Z
apache-httpd-2.4.46p0:libxml-2.9.10p2: ok
apache-httpd-2.4.46p0:nghttp2-1.41.0p1: ok
apache-httpd-2.4.46p0:brotli-1.0.7: ok
apache-httpd-2.4.46p0:db-4.6.21p7v0: ok
apache-httpd-2.4.46p0:apr-1.6.5p0: ok
apache-httpd-2.4.46p0:apr-util-1.6.1p2: ok
apache-httpd-2.4.46p0:jansson-2.12: ok
apache-httpd-2.4.46p0:pcre-8.41p2: ok
apache-httpd-2.4.46p0:curl-7.72.0p0: ok
apache-httpd-2.4.46p0: ok
Ambiguous: choose package for php-gd
a	0: <None>
	1: php-gd-7.2.34
	2: php-gd-7.3.25
	3: php-gd-7.4.13
Your choice: 3
php-gd-7.4.13:femail-1.0p1: ok
php-gd-7.4.13:femail-chroot-1.0p3: ok
php-gd-7.4.13:argon2-20190702: ok
php-gd-7.4.13:libsodium-1.0.18p1: ok
php-gd-7.4.13:oniguruma-6.9.6: ok
php-gd-7.4.13:pcre2-10.35: ok
php-gd-7.4.13:php-7.4.13: ok
php-gd-7.4.13:giflib-5.1.6: ok
php-gd-7.4.13:lz4-1.9.2p0: ok
php-gd-7.4.13:zstd-1.4.5p0: ok
php-gd-7.4.13:jpeg-2.0.5v0: ok
php-gd-7.4.13:tiff-4.1.0: ok
php-gd-7.4.13:png-1.6.37: ok
php-gd-7.4.13:libwebp-1.1.0: ok
php-gd-7.4.13: ok
Ambiguous: choose package for php-pdo_pgsql
a	0: <None>
	1: php-pdo_pgsql-7.2.34
	2: php-pdo_pgsql-7.3.25
	3: php-pdo_pgsql-7.4.13
Your choice: 3
php-pdo_pgsql-7.4.13:postgresql-client-12.5: ok
php-pdo_pgsql-7.4.13: ok
Ambiguous: choose package for php-pgsql
a	0: <None>
	1: php-pgsql-7.2.34
	2: php-pgsql-7.3.25
	3: php-pgsql-7.4.13
Your choice: 3
php-pgsql-7.4.13: ok
Running tags: ok
The following new rcscripts were installed: /etc/rc.d/apache2 /etc/rc.d/php74_fpm
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/femail-chroot
	/usr/local/share/doc/pkg-readmes/php-7.4
```


Instalasi mod-wsqi dengan pip3:
```
pisang$ doas pip install mod-wsgi
doas (muntaza@pisang.muntaza.id) password:
Collecting mod-wsgi
  Using cached mod_wsgi-4.7.1.tar.gz (498 kB)
Using legacy 'setup.py install' for mod-wsgi, since package 'wheel' is not installed.
Installing collected packages: mod-wsgi
    Running setup.py install for mod-wsgi ... done
Successfully installed mod-wsgi-4.7.1
pisang$
```


Pengecekan aplikasi apa saja yang telah terinstall:
```
pisang$ pkg_info
apache-httpd-2.4.46p0 apache HTTP server
apr-1.6.5p0         Apache Portable Runtime
apr-util-1.6.1p2    companion library to APR
argon2-20190702     C implementation of Argon2 - password hashing function
brotli-1.0.7        generic lossless compressor
bzip2-1.0.8         block-sorting file compressor, unencumbered
curl-7.72.0p0       transfer files with FTP, HTTP, HTTPS, etc.
db-4.6.21p7v0       Berkeley DB package, revision 4
femail-1.0p1        simple SMTP client
femail-chroot-1.0p3 simple SMTP client for chrooted web servers
gettext-runtime-0.21 GNU gettext runtime libraries and programs
giflib-5.1.6        tools and library routines for working with GIF images
intel-firmware-20200616v0 microcode update binaries for Intel CPUs
jansson-2.12        library for manipulating JSON data
jpeg-2.0.5v0        SIMD-accelerated JPEG codec replacement of libjpeg
libffi-3.3          Foreign Function Interface
libiconv-1.16p0     character set conversion library
libsodium-1.0.18p1  library for network communications and cryptography
libwebp-1.1.0       Google WebP image format conversion tool
libxml-2.9.10p2     XML parsing library
lz4-1.9.2p0         fast BSD-licensed data compression
nghttp2-1.41.0p1    library for HTTP/2
oniguruma-6.9.6     regular expressions library
pcre-8.41p2         perl-compatible regular expression library
pcre2-10.35         perl-compatible regular expression library, version 2
php-7.4.13          server-side HTML-embedded scripting language
php-gd-7.4.13       image manipulation extensions for php
php-pdo_pgsql-7.4.13 PDO pgsql database access extensions for php
php-pgsql-7.4.13    pgsql database access extensions for php
png-1.6.37          library for manipulating PNG images
postgresql-client-12.5 PostgreSQL RDBMS (client)
postgresql-contrib-12.5 PostgreSQL RDBMS contributions
postgresql-server-12.5 PostgreSQL RDBMS (server)
py3-pip-20.1.1p0    tool for installing Python packages
py3-setuptools-41.6.0p0v0 simplified packaging system for Python modules
python-3.8.6p0      interpreted object-oriented programming language
quirks-3.440        exceptions to pkg_add rules
sqlite3-3.31.1p0    embedded SQL implementation
tiff-4.1.0          tools and library routines for working with TIFF images
vim-8.2.1805-no_x11-python3 vi clone, many additional features
xz-5.2.5            LZMA compression and decompression tools
zstd-1.4.5p0        zstandard fast real-time compression algorithm
pisang$
```

Instalasi Psycopg2, kemudian tampilkan paket python3 apa aja yang
sudah terinstall, terlihat bahwa Django sudah terinstall, namun saya lupa
mengcapture proses instalasi Django tersebut:
```
pisang$ doas pip install psycopg2
Collecting psycopg2
  Downloading psycopg2-2.8.6.tar.gz (383 kB)
     |████████████████████████████████| 383 kB 342 kB/s
Using legacy 'setup.py install' for psycopg2, since package 'wheel' is not installed.
Installing collected packages: psycopg2
    Running setup.py install for psycopg2 ... done
Successfully installed psycopg2-2.8.6
pisang$
pisang$ pip list
Package    Version
---------- -------
Django     2.2.17
mod-wsgi   4.7.1
pip        20.3.3
psycopg2   2.8.6
pytz       2020.5
setuptools 41.6.0
sqlparse   0.4.1
pisang$
```

Cek versi Django:
```
pisang$ django-admin --version
2.2.17
pisang$
```


Instalasi Rsync untuk fasilitas backup:
```
pisang$ doas /usr/sbin/pkg_add rsync
doas (muntaza@pisang.muntaza.id) password:
quirks-3.440 signed on 2020-12-23T21:18:09Z
Ambiguous: choose package for rsync
a	0: <None>
	1: rsync-3.2.3
	2: rsync-3.2.3-iconv
Your choice: 1
rsync-3.2.3: ok
The following new rcscripts were installed: /etc/rc.d/rsyncd
See rcctl(8) for details.
```


Konfigurasi awal PostgreSQL:
```
pisang$ ls
pisang$ cat /etc/passwd | grep postgres
_postgresql:*:503:503:PostgreSQL Manager:/var/postgresql:/bin/sh
pisang$ doas su - _postgresql
doas (muntaza@pisang.muntaza.id) password:
pisang$
pisang$ pwd
/var/postgresql
pisang$
pisang$ ls
pisang$ mkdir data
pisang$
pisang$ initdb -D /var/postgresql/data -U _postgresql -A md5 -W
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
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 20
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Makassar
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctl -D /var/postgresql/data -l logfile start

pisang$
```

Demikian sedikit catatan ini, semoga bermanfaat, terkhusus diri saya
sendiri. Aamiin.


# Alhamdulillah
