---
layout: post
title:  "Deploy Django dan PHP"
date:   2020-04-09 11:26:56 +0800
categories: openbsd
---

# Bismillah,

Setelah saya install OpenBSD versi snapshot, maka saya mencoba menginstall
paket-paket untuk deploy Django dan PHP. Saya akan berikatan catatan yang
saya anggap perlu di bagian bawah setiap langkah instalasi ini.


```text
bphtb$ doas /usr/sbin/pkg_add vim
doas (muntaza@bphtb.paringin.com) password:
quirks-3.299 signed on 2020-04-02T19:59:42Z
Ambiguous: choose package for vim
a       0: <None>
        1: vim-8.2.356-gtk2
        2: vim-8.2.356-gtk2-lua
        3: vim-8.2.356-gtk2-perl-python-ruby
        4: vim-8.2.356-gtk2-perl-python3-ruby
        5: vim-8.2.356-gtk3
        6: vim-8.2.356-gtk3-lua
        7: vim-8.2.356-gtk3-perl-python-ruby
        8: vim-8.2.356-gtk3-perl-python3-ruby
        9: vim-8.2.356-no_x11-lua
        10: vim-8.2.356-no_x11
        11: vim-8.2.356-no_x11-perl-python-ruby
        12: vim-8.2.356-no_x11-perl-python3-ruby
        13: vim-8.2.356-no_x11-python
        14: vim-8.2.356-no_x11-python3
        15: vim-8.2.356-no_x11-ruby


Your choice: 14
vim-8.2.356-no_x11-python3:bzip2-1.0.8: ok
vim-8.2.356-no_x11-python3:xz-5.2.5: ok
vim-8.2.356-no_x11-python3:sqlite3-3.31.1p0: ok
vim-8.2.356-no_x11-python3:libffi-3.3: ok
vim-8.2.356-no_x11-python3:python-3.7.7: ok
vim-8.2.356-no_x11-python3: ok
```

Saya menginstall vim sebagai editor favorit saya, sekalian python3, dengan
versi python-3.7.7.

```text
bphtb$ doas /usr/sbin/pkg_add py3-pip
quirks-3.299 signed on 2020-04-02T19:59:42Z
py3-pip-19.1.1:py3-setuptools-41.6.0v0: ok
py3-pip-19.1.1: ok
--- +py3-pip-19.1.1 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip3.7 /usr/local/bin/pip
```

Instalasi pip, dengan python3 tentunya.


```text
bphtb$ doas cp pf.conf pf.conf_install
bphtb$ doas vi pf.conf_install
bphtb$ doas /sbin/pfctl -f /etc/pf.conf_install
```

Oh, pf firewall harus saya buka dengan menambahkan baris __pass out__
pada bagian bawah, agar bisa menggunakan pip.

```text
bphtb$ doas pip install --upgrade pip
Collecting pip
  Downloading https://files.pythonhosted.org/packages/54/0c/d01aa759fdc501a58f431eb594a17495f15b88da142ce14b5845662c13f3/pip-20.0.2-py2.py3-none-any.whl (1.4MB)
     |----------------------| 1.4MB 772kB/s
Installing collected packages: pip
  Found existing installation: pip 19.1.1
    Uninstalling pip-19.1.1:
      Successfully uninstalled pip-19.1.1
Successfully installed pip-20.0.2

bphtb$ pip3 --version
pip 20.0.2 from /usr/local/lib/python3.7/site-packages/pip (python 3.7)

bphtb$ doas pip install Django==2.2.12
Collecting Django==2.2.12
  Downloading Django-2.2.12-py3-none-any.whl (7.5 MB)
     |--------------------------------| 7.5 MB 86 kB/s
Collecting sqlparse
  Downloading sqlparse-0.3.1-py2.py3-none-any.whl (40 kB)
     |--------------------------------| 40 kB 65 kB/s
Collecting pytz
  Downloading pytz-2019.3-py2.py3-none-any.whl (509 kB)
     |--------------------------------| 509 kB 89 kB/s
Installing collected packages: sqlparse, pytz, Django
Successfully installed Django-2.2.12 pytz-2019.3 sqlparse-0.3.1

bphtb$ doas /usr/sbin/pkg_add apache-httpd
quirks-3.299 signed on 2020-04-02T19:59:42Z
apache-httpd-2.4.43:jansson-2.12: ok
apache-httpd-2.4.43:pcre-8.41p2: ok
apache-httpd-2.4.43:libxml-2.9.10p0: ok
apache-httpd-2.4.43:brotli-1.0.7: ok
apache-httpd-2.4.43:apr-1.6.5p0: ok
apache-httpd-2.4.43:db-4.6.21p7v0: ok
apache-httpd-2.4.43:apr-util-1.6.1p2: ok
apache-httpd-2.4.43: ok
Running tags: ok
The following new rcscripts were installed: /etc/rc.d/apache2
See rcctl(8) for details.


bphtb$ doas /usr/sbin/pkg_add php-gd php-pdo_pgsql php-pgsql php-apache
quirks-3.299 signed on 2020-04-02T19:59:42Z
Ambiguous: choose package for php-gd
a	0: <None>
	1: php-gd-7.2.29
	2: php-gd-7.3.16
Your choice: 2
php-gd-7.3.16:png-1.6.37: ok
php-gd-7.3.16:libsodium-1.0.18: ok
php-gd-7.3.16:oniguruma-6.9.4p0: ok
php-gd-7.3.16:femail-1.0p1: ok
php-gd-7.3.16:femail-chroot-1.0p3: ok
php-gd-7.3.16:argon2-20171227: ok
php-gd-7.3.16:php-7.3.16: ok
php-gd-7.3.16:jpeg-2.0.4p0v0: ok
php-gd-7.3.16: ok
Ambiguous: choose package for php-pdo_pgsql
a	0: <None>
	1: php-pdo_pgsql-7.2.29
	2: php-pdo_pgsql-7.3.16
Your choice: 2
php-pdo_pgsql-7.3.16:postgresql-client-12.2: ok
php-pdo_pgsql-7.3.16: ok
Ambiguous: choose package for php-pgsql
a	0: <None>
	1: php-pgsql-7.2.29
	2: php-pgsql-7.3.16
Your choice: 2
php-pgsql-7.3.16: ok
Ambiguous: choose package for php-apache
a	0: <None>
	1: php-apache-7.2.29
	2: php-apache-7.3.16
Your choice: 2
php-apache-7.3.16: ok
The following new rcscripts were installed: /etc/rc.d/php73_fpm
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/femail-chroot
	/usr/local/share/doc/pkg-readmes/php-7.3


bphtb$ doas /usr/sbin/pkg_add postgresql-server postgresql-contrib
quirks-3.299 signed on 2020-04-02T19:59:42Z
useradd: Warning: home directory `/var/postgresql' doesn't exist, and -m was not specified
postgresql-server-12.2: ok
postgresql-contrib-12.2: ok
The following new rcscripts were installed: /etc/rc.d/postgresql
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/postgresql-server

bphtb$ doas pip install mod-wsgi
Collecting mod-wsgi
  Downloading mod_wsgi-4.7.1.tar.gz (498 kB)
     |-----------------------| 498 kB 404 kB/s
Installing collected packages: mod-wsgi
    Running setup.py install for mod-wsgi ... done
Successfully installed mod-wsgi-4.7.1

bphtb$ pip3.7 list
Package    Version
---------- -------
Django     2.2.12
mod-wsgi   4.7.1
pip        20.0.2
pytz       2019.3
setuptools 41.6.0
sqlparse   0.3.1


apache-httpd-2.4.43		apache HTTP server
php-7.3.16			server-side HTML-embedded scripting language
php-apache-7.3.16		php module for Apache httpd
php-gd-7.3.16			image manipulation extensions for php
php-pdo_pgsql-7.3.16		PDO pgsql database access extensions for php
php-pgsql-7.3.16		pgsql database access extensions for php
postgresql-client-12.2		PostgreSQL RDBMS (client)
postgresql-contrib-12.2		PostgreSQL RDBMS contributions
postgresql-server-12.2		PostgreSQL RDBMS (server)
py3-pip-19.1.1			tool for installing Python packages
py3-setuptools-41.6.0v0		simplified packaging system for Python modules
python-3.7.7			interpreted object-oriented programming language
vim-8.2.356-no_x11-python3	vi clone, many additional features




# Alhamdulillah
