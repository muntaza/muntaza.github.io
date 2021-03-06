---
layout: post
title:  "Instalasi SPSE v4.3 pada CentOS 7"
date:   2019-06-02 12:26:56 +0800
categories: centos7
---

# Bismillah,

Instalasi SPSE v4.3 dengan Menggunakan CentOS 7

Asumsi:
- Hanya untuk di Virtual Machine, bukan di server utama dan tulisan ini hanya
ditujukan kepada Admin System LPSE.

- CentOS 7.1 yang di gunakan

	lihat versi yang ada saat ini:

{% highlight text %}
[muntaza@lpse ~]$ cat /etc/redhat-release
CentOS Linux release 7.1.1503 (Core)
[muntaza@lpse ~]$ uname -a
Linux lpse.muntaza.id 3.10.0-229.1.2.el7.x86_64 #1 SMP Fri Mar 27 03:04:26 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
{% endhighlight %}

- Bahan instalsi berupa Java1.8.0, curl-7.28.1.tar.gz, modsecurity-apache_2.6.5.tar.gz, file dblat.zip,
Anda bisa menghubungi Admin LKPP untuk mendapatkannya. Penulis memperoleh nya saat bimtek Admin System
16 Mei 2017 di LKPP Jakarta

- Bahan instalasi berupa SPSE v4.3 latihan, Anda bisa menghubungi Admin LKPP untuk mendapatkannya.
Penulis memperolehnya saat bimtek Admin System 27 September 2018 Banjarmasin

Langkah-langkah:

## 0. Pembuatan User biasa
{% highlight text %}
[root@lpse ssh]# useradd muntaza
[root@lpse ssh]# passwd muntaza

[root@lpse ssh]# cat /etc/group | grep wheel
wheel:x:10:
[root@lpse ssh]# id muntaza
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza)
[root@lpse ssh]# cat /etc/group | grep wheel
wheel:x:10:
[root@lpse ssh]# usermod muntaza -G muntaza,wheel
[root@lpse ssh]# cat /etc/group | grep wheel
wheel:x:10:muntaza
[root@lpse ssh]# id
uid=0(root) gid=0(root) groups=0(root)
[root@lpse ssh]# id muntaza
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza),10(wheel)
{% endhighlight %}


## 1. SSH dengan Authentication Public key only

# A. Buat key pair dari host yang akan melakukan koneksi

{% highlight text %}
openbsd$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/muntaza/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/muntaza/.ssh/id_rsa.
Your public key has been saved in /home/muntaza/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:iL8JYFQhsv2TX3tQndjyIIw8j0371SiW5GByLHkqEzI muntaza@openbsd.muntaza.id
The key's randomart image is:
+---[RSA 2048]----+
|. . o.           |
| + o . =   + .   |
|. E . B X * +    |
| . + + # B = o   |
|  o B + S = + .  |
| . . * . = o     |
|    . o . o      |
|     . o .       |
|      o          |
+----[SHA256]-----+
{% endhighlight %}

Saat pembuatan kunci ini, password di biarkan kosong

# B. Buat direktory .ssh di VM

{% highlight text %}
[muntaza@lpse ~]$ mkdir .ssh
[muntaza@lpse ~]$ ls -la
total 28
drwx------ 3 muntaza muntaza 4096 Sep 30 00:52 .
drwxr-xr-x 3 root    root    4096 Sep 30 00:33 ..
- -rw------- 1 muntaza muntaza   37 Sep 30 00:42 .bash_history
- -rw-r--r-- 1 muntaza muntaza   18 Mar  5  2015 .bash_logout
- -rw-r--r-- 1 muntaza muntaza  193 Mar  5  2015 .bash_profile
- -rw-r--r-- 1 muntaza muntaza  231 Mar  5  2015 .bashrc
drwxrwxr-x 2 muntaza muntaza 4096 Sep 30 00:52 .ssh
[muntaza@lpse ~]$ ls -lad .ssh/
drwxrwxr-x 2 muntaza muntaza 4096 Sep 30 00:52 .ssh/
[muntaza@lpse ~]$ chmod -R og-rwx .ssh/
[muntaza@lpse ~]$ ls -lad .ssh/
drwx------ 2 muntaza muntaza 4096 Sep 30 00:52 .ssh/
{% endhighlight %}

# C. Copy Public key ke server VM

{% highlight text %}
openbsd$ scp .ssh/id_rsa.pub muntaza@lpse.muntaza.id:/home/muntaza/.ssh/authorized_keys
muntaza@lpse.muntaza.id's password:
id_rsa.pub                                                      100%  408   181.7KB/s   00:00
openbsd$
openbsd$ ssh muntaza@lpse.muntaza.id
Last login: Sun Sep 30 00:51:47 2018 from 182.1.190.37
[muntaza@lpse ~]$
{% endhighlight %}

Terlihat kalau koneksi sudah berhasil dengan public key

# D. Non aktifkan Authentication lain selain public key

{% highlight text %}
[muntaza@lpse ~]$ cd /etc/ssh/
[muntaza@lpse ssh]$ sudo vi sshd_config
{% endhighlight %}


Setting pada file /etc/ssh/sshd_config, pastikan bahwa Autentikasi lainnya di disable

{% highlight text %}
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
GSSAPIAuthentication no
{% endhighlight %}

Restart sshd

{% highlight text %}
[muntaza@lpse ssh]$ sudo systemctl restart sshd
{% endhighlight %}

cek koneksi dari host atau server lain

{% highlight text %}
openbsd$ ssh muntaza@lpse.muntaza.id
Last login: Sun Sep 30 00:57:58 2018 from 45.64.99.182
[muntaza@lpse ~]$
[muntaza@lpse ~]$ exit
logout
Connection to lpse.muntaza.id closed.
openbsd$
openbsd$ ssh hasan@lpse.muntaza.id
hasan@lpse.muntaza.id: Permission denied (publickey).
openbsd$
{% endhighlight %}

Terlihat, bahwa koneksi dengan user muntaza bisa, karena sudah punya public
key, sedangkan dari user hasan, yang tidak eksis di sistem, tidak  bisa,
dan menampilkan error bahwa hanya Authentication publickey yang diterima.


## 2. Update OS ke versi terakhir

{% highlight text %}
[muntaza@lpse ssh]$ sudo yum update

Transaction Summary
==========================================================================================================================
Install    5 Packages (+21 Dependent packages)
Upgrade  183 Packages

Total download size: 238 M
Is this ok [y/d/N]:
{% endhighlight %}


Weh 238 MB, lumayan juga besarnya (senyum)

{% highlight text %}
[muntaza@lpse ssh]$ cat /etc/redhat-release
CentOS Linux release 7.5.1804 (Core)
[muntaza@lpse ssh]$
{% endhighlight %}


nah, sudah di versi 7.5

## 3. Setting firewall dengan Firewalld


Kenapa firewall di aktifkan, ibarat sebuah rumah, maka agar udara masuk,
kita perlu membuka jendela, yang dilindungi dengan jeruji besi,
tidak harus membuka pintu depan setiap saat.

# A. Instalasi firewalld

{% highlight text %}
[muntaza@lpse ssh]$ sudo yum install firewalld
{% endhighlight %}

# B. Reboot system

{% highlight text %}
[muntaza@lpse ~]$ sudo /sbin/reboot
{% endhighlight %}

# C. Disable iptables dan aktifkan firewalld

{% highlight text %}
[muntaza@lpse ~]$ sudo systemctl status iptables
[sudo] password for muntaza:
iptables.service - IPv4 firewall with iptables
   Loaded: loaded (/usr/lib/systemd/system/iptables.service; disabled; vendor preset: disabled)
   Active: inactive (dead)

[muntaza@lpse ~]$ sudo systemctl stop iptables
[muntaza@lpse ~]$ sudo systemctl disable iptables

[muntaza@lpse ~]$ sudo systemctl start firewalld
[muntaza@lpse ~]$ sudo systemctl enable firewalld

[muntaza@lpse ~]$ sudo systemctl status firewalld
firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2018-09-30 01:28:54 UTC; 1min 3s ago
     Docs: man:firewalld(1)
 Main PID: 339 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─339 /usr/bin/python -Es /usr/sbin/firewalld --nofork --nopid

Sep 30 01:28:52 lpse.muntaza.id systemd[1]: Starting firewalld - dynamic firewall daemon...
Sep 30 01:28:54 lpse.muntaza.id systemd[1]: Started firewalld - dynamic firewall daemon.
{% endhighlight %}


# D. Buka port https untuk koneksi dari luar

{% highlight text %}
[muntaza@lpse ~]$ sudo firewall-cmd --list-services
ssh dhcpv6-client
[muntaza@lpse ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth1
  sources:
  services: ssh dhcpv6-client
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

[muntaza@lpse ~]$ sudo firewall-cmd --add-service=https
success
[muntaza@lpse ~]$ sudo firewall-cmd --add-service=https --permanent
success
[muntaza@lpse ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth1
  sources:
  services: ssh dhcpv6-client https
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

[muntaza@lpse ~]$ sudo firewall-cmd --list-all --permanent
public
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh dhcpv6-client https
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

[muntaza@lpse ~]$
{% endhighlight %}


Kenapa hanya port https yang dibuka, karena pada contoh kali ini
port 80 tidak akan aktif, kita hanya menjalankan service di port 443 saja



## 4. SElinux

SElinux kita aktifkan, SElinux ini fitur bukan bug, malah meningkatkan
keamanan server kita kalau SElinux ini aktif.

{% highlight text %}
[muntaza@lpse ~]$ sudo vi /etc/sysconfig/selinux
[muntaza@lpse ~]$ cat /etc/sysconfig/selinux

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
{% endhighlight %}

# A. Instalasi paket-paket pendukung SElinux

{% highlight text %}
[muntaza@lpse ~]$ sudo yum install policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans

[muntaza@lpse ~]$ sudo /sbin/reboot
{% endhighlight %}

# B. Cek status SElinux
{% highlight text %}
[muntaza@lpse ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      31
[muntaza@lpse ~]$
{% endhighlight %}

Terlihat bahwa SElinux sudah aktif

# C. Setting SElinux agar SPSE v4.3 bisa berjalan

{% highlight text %}
[muntaza@lpse ~]$ cat setting_selinux.sh
setsebool httpd_anon_write 1
setsebool httpd_builtin_scripting 1
setsebool httpd_can_network_connect 1
setsebool httpd_enable_cgi 1
setsebool httpd_graceful_shutdown 1
setsebool named_tcp_bind_http_port 1
[muntaza@lpse ~]$
[muntaza@lpse ~]$ sudo sh setting_selinux.sh
[sudo] password for muntaza:
[muntaza@lpse ~]$
[muntaza@lpse ~]$  getsebool -a| grep http| grep "> on"
httpd_anon_write --> on
httpd_builtin_scripting --> on
httpd_can_network_connect --> on
httpd_enable_cgi --> on
httpd_graceful_shutdown --> on
named_tcp_bind_http_port --> on
[muntaza@lpse ~]$
{% endhighlight %}

## 5. setting file /etc/resolv.conf

{% highlight text %}
[muntaza@lpse ~]$ cat /etc/resolv.conf
nameserver 27.50.20.21
nameserver 27.50.30.21
nameserver 8.8.8.8
[muntaza@lpse ~]$
{% endhighlight %}

## 6. Postgresql 10

# A. Instalasi Postgresql 10

{% highlight text %}
[muntaza@lpse ~]$ sudo yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm

[muntaza@lpse ~]$ sudo yum install postgresql10 postgresql10-server postgresql10-contrib vim unzip
{% endhighlight %}

Disamping menginstall postgresql, penulis menginstall vim karena lupa, dan menginstall juga unzip


# B. Setting Postgresql 10

Buat Cluster Database:

{% highlight text %}
[muntaza@lpse ~]$ sudo /usr/pgsql-10/bin/postgresql-10-setup initdb
Initializing database ... OK

[muntaza@lpse ~]$
{% endhighlight %}

Pastikan bahwa Postgresql hanya aktif untuk localhost dan koneksi dari Localhost
menggunakan metode md5

{% highlight text %}
[muntaza@lpse ~]$ sudo su postgres
bash-4.2$ cd
bash-4.2$ ls
10

bash-4.2$ cp 10/data/postgresql.conf 10/data/postgresql.conf_asli
bash-4.2$ vi 10/data/postgresql.conf
bash-4.2$ cp 10/data/pg_hba.conf 10/data/pg_hba.conf_asli
bash-4.2$ vi 10/data/pg_hba.conf
bash-4.2$ diff 10/data/postgresql.conf 10/data/postgresql.conf_asli
59c59
< listen_addresses = 'localhost'		# what IP address(es) to listen on;
- ---
> #listen_addresses = 'localhost'		# what IP address(es) to listen on;
bash-4.2$ diff 10/data/pg_hba.conf 10/data/pg_hba.conf_asli
82c82
< host    all             all             127.0.0.1/32            md5
- ---
> host    all             all             127.0.0.1/32            ident
84c84
< host    all             all             ::1/128                 md5
- ---
> host    all             all             ::1/128                 ident
bash-4.2$
{% endhighlight %}

restart service postgresql

{% highlight text %}
bash-4.2$ exit
exit
[muntaza@lpse ~]$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[muntaza@lpse ~]$ sudo systemctl restart postgresql-10
[sudo] password for muntaza:
[muntaza@lpse ~]$ sudo systemctl enable postgresql-10
Created symlink from /etc/systemd/system/multi-user.target.wants/postgresql-10.service to /usr/lib/systemd/system/postgresql-10.service.
[muntaza@lpse ~]$ sudo systemctl status postgresql-10
postgresql-10.service - PostgreSQL 10 database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql-10.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2018-09-30 02:28:45 UTC; 10s ago
     Docs: https://www.postgresql.org/docs/10/static/
 Main PID: 9520 (postmaster)
   CGroup: /system.slice/postgresql-10.service
           ├─9520 /usr/pgsql-10/bin/postmaster -D /var/lib/pgsql/10/data/
           ├─9521 postgres: logger process
           ├─9523 postgres: checkpointer process
           ├─9524 postgres: writer process
           ├─9525 postgres: wal writer process
           ├─9526 postgres: autovacuum launcher process
           ├─9527 postgres: stats collector process
           └─9528 postgres: bgworker: logical replication launcher

Sep 30 02:28:45 lpse.muntaza.id systemd[1]: Starting PostgreSQL 10 database server...
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.856 UTC [9520] LOG:  listening on IPv6 addre... 5432
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.858 UTC [9520] LOG:  listening on IPv4 addre... 5432
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.861 UTC [9520] LOG:  listening on Unix socke...5432"
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.866 UTC [9520] LOG:  listening on Unix socke...5432"
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.882 UTC [9520] LOG:  redirecting log output ...ocess
Sep 30 02:28:45 lpse.muntaza.id postmaster[9520]: 2018-09-30 02:28:45.882 UTC [9520] HINT:  Future log output will...log".
Sep 30 02:28:45 lpse.muntaza.id systemd[1]: Started PostgreSQL 10 database server.
Hint: Some lines were ellipsized, use -l to show in full.
[muntaza@lpse ~]$
{% endhighlight %}


# C. Buat user epns

Password user epns jangan epns, tapi suatu password yang bersifat rahasia, di contoh ini,
passwordnya adalah "inirahasia" dan setting ini nanti di sesuaikan saat konfigurasi SPSE,
jadi tidak masalah apapun password epns, yang penting di sesuaikan konfigurasi SPSE nya

{% highlight text %}
[muntaza@lpse ~]$ cd
[muntaza@lpse ~]$ pwd
/home/muntaza
[muntaza@lpse ~]$ sudo su postgres
bash-4.2$ cd
bash-4.2$ id
uid=26(postgres) gid=26(postgres) groups=26(postgres) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
bash-4.2$ psql
psql (10.5)
Type "help" for help.

postgres=# \q
bash-4.2$
bash-4.2$ createuser -U postgres epns -P
Enter password for new role:
Enter it again:
bash-4.2$ createdb -O epns epns_lat
bash-4.2$
bash-4.2$
bash-4.2$ exit
exit
[muntaza@lpse ~]$
{% endhighlight %}


# D. Restore

Untuk merestore data, copy file sql nya dan sekalian copy juga bahan-bahan lainnya
{% highlight text %}
openbsd$ scp *
curl-7.28.1.tar.gz                      jdk1.8.0.tgz                            spse.conf
dblat.zip                               modsecurity-apache_2.6.5.tar.gz         spselat_asli.tgz
openbsd$ scp * muntaza@lpse.muntaza.id:/home/muntaza
curl-7.28.1.tar.gz                                                                      100% 3114KB   6.9MB/s   00:00
dblat.zip                                                                               100%   12MB   6.3MB/s   00:01
jdk1.8.0.tgz                                                                            100%  288MB   6.1MB/s   00:47
modsecurity-apache_2.6.5.tar.gz                                                         100%  763KB   6.6MB/s   00:00
spse.conf                                                                               100% 4473     1.5MB/s   00:00
spselat_asli.tgz                                                                        100%  160MB   6.2MB/s   00:25
openbsd$
{% endhighlight %}

Restore database

{% highlight text %}
[muntaza@lpse ~]$ ls
curl-7.28.1.tar.gz  jdk1.8.0.tgz                     setting_selinux.sh  spselat_asli.tgz
dblat.zip           modsecurity-apache_2.6.5.tar.gz  spse.conf
[muntaza@lpse ~]$ cd /tmp/
[muntaza@lpse tmp]$ unzip ~/dblat.zip
Archive:  /home/muntaza/dblat.zip
  inflating: epns_lat_23-01-2017-14-32-28.sql
[muntaza@lpse tmp]$ sudo su postgres
bash-4.2$ cd
bash-4.2$ id
uid=26(postgres) gid=26(postgres) groups=26(postgres) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

bash-4.2$ psql epns_lat < /tmp/epns_lat_23-01-2017-14-32-28.sql

bash-4.2$ exit
exit
[muntaza@lpse tmp]$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
{% endhighlight %}

Test koneksi

{% highlight text %}
[muntaza@lpse ~]$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[muntaza@lpse ~]$ psql -U epns epns_lat -h localhost
Password for user epns:
psql (10.5)
Type "help" for help.

epns_lat=>
epns_lat=> \q
[muntaza@lpse ~]$
{% endhighlight %}


## 7. Java
Ekstrak file java1.8.0

{% highlight text %}
[muntaza@lpse src]$ cd /usr/local/src/
[muntaza@lpse src]$ sudo tar -xzf /home/muntaza/jdk1.8.0.tgz
[muntaza@lpse src]$ ls
jdk1.8.0_copy
[muntaza@lpse src]$ sudo mv jdk1.8.0_copy jdk1.8.0
[muntaza@lpse src]$
[muntaza@lpse src]$ ls
jdk1.8.0
{% endhighlight %}


## 8. Apache HTTPD, Mod SSL dan Tools Development

{% highlight text %}
[muntaza@lpse src]$ sudo yum install httpd httpd-devel gcc-c++ mod_evasive mod_security pcre-devel libxml2-devel
[muntaza@lpse ~]$ sudo yum install mod_ssl
{% endhighlight %}

## 9. Curl dan Mod Security

# A. Curl
{% highlight text %}
[muntaza@lpse ~]$ tar -xzf curl-7.28.1.tar.gz
[muntaza@lpse ~]$ cd curl-7.28.1
[muntaza@lpse curl-7.28.1]$ ./configure --with-apxs=/usr/bin/apxs
[muntaza@lpse curl-7.28.1]$ make
[muntaza@lpse curl-7.28.1]$ sudo make install
{% endhighlight %}



# B. Mod Security
{% highlight text %}
[muntaza@lpse ~]$ tar -xzf modsecurity-apache_2.6.5.tar.gz
[muntaza@lpse ~]$ cd modsecurity-apache_2.6.5
[muntaza@lpse modsecurity-apache_2.6.5]$ ./configure --with-apxs=/usr/bin/apxs
[muntaza@lpse modsecurity-apache_2.6.5]$ make
[muntaza@lpse modsecurity-apache_2.6.5]$ sudo make install
{% endhighlight %}


## 10. Mod Evasive

Ada di EPEL repository, dan repo ini untuk Fedora
sehingga kualitas untuk paket ini agak meragukan,
konsultasi kan dengan Admin LKPP tentang paket ini

{% highlight text %}
[muntaza@lpse ~]$ sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/m/mod_evasive-1.10.1-22.el7.x86_64.rpm
Retrieving https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/m/mod_evasive-1.10.1-22.el7.x86_64.rpm
warning: /var/tmp/rpm-tmp.SalqCq: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:mod_evasive-1.10.1-22.el7        ################################# [100%]
{% endhighlight %}


## 11. SPSE v43

# A. Buat folder, setting agar file spse4 bisa di eksekusi

{% highlight text %}
[muntaza@lpse ~]$ sudo mkdir /home/appserv
[muntaza@lpse ~]$ cd /home/appserv/

[muntaza@lpse appserv]$ sudo tar -xzf ~/spselat_asli.tgz
[muntaza@lpse appserv]$ ls
spselat_asli
[muntaza@lpse appserv]$ sudo mv spselat_asli spselat
[muntaza@lpse appserv]$ cd spselat/
[muntaza@lpse spselat]$ ls
README.md  framework  spse4.original  webapp
[muntaza@lpse spselat]$ sudo cp spse4.original spse4
[muntaza@lpse spselat]$ sudo chmod +x spse4
[muntaza@lpse spselat]$
{% endhighlight %}

# B. Konfigurasi SPSE v4.3

{% highlight text %}
[muntaza@lpse spselat]$ cd webapp/conf/
[muntaza@lpse conf]$ sudo cp application.conf.lat application.conf
[muntaza@lpse conf]$ sudo vi application.conf
[muntaza@lpse conf]$ diff application.conf application.conf.lat
9c9
< http.path=/eproc43lat
- ---
> http.path=/eproc4lat
28c28
< db.pass=inirahasia
- ---
> db.pass=epns
91,92c91,92
< http.port=9909
< sikap.url=https://latihan-lpse.lkpp.go.id/sikap
- ---
> http.port=9009
> sikap.url=https://latihan-lpse.lkpp.go.id/sikap
{% endhighlight %}


## 12. Setting Apache HTTPD

Aktifkan httpd dan cek modul evasive, security dan ssl sudah aktif

{% highlight text %}
[muntaza@lpse ~]$ sudo systemctl restart httpd
[muntaza@lpse ~]$ sudo systemctl enable httpd
Created symlink from /etc/systemd/system/multi-user.target.wants/httpd.service to /usr/lib/systemd/system/httpd.service.
[muntaza@lpse ~]$ sudo systemctl status httpd
httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2018-09-30 03:30:32 UTC; 18s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 26949 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/httpd.service
           ├─26949 /usr/sbin/httpd -DFOREGROUND
           ├─26950 /usr/sbin/httpd -DFOREGROUND
           ├─26951 /usr/sbin/httpd -DFOREGROUND
           ├─26952 /usr/sbin/httpd -DFOREGROUND
           ├─26953 /usr/sbin/httpd -DFOREGROUND
           └─26954 /usr/sbin/httpd -DFOREGROUND

Sep 30 03:30:30 lpse.muntaza.id systemd[1]: Starting The Apache HTTP Server...
Sep 30 03:30:32 lpse.muntaza.id httpd[26949]: AH00557: httpd: apr_sockaddr_info_get() failed for lpse.muntaza.id
Sep 30 03:30:32 lpse.muntaza.id httpd[26949]: AH00558: httpd: Could not reliably determine the server's fully qual...ssage
Sep 30 03:30:32 lpse.muntaza.id systemd[1]: Started The Apache HTTP Server.
Hint: Some lines were ellipsized, use -l to show in full.

[muntaza@lpse ~]$
[muntaza@lpse ~]$ sudo  httpd -M | grep -e ssl -e evasive -e security
 ssl_module (shared)
 security2_module (shared)
 evasive20_module (shared)
[muntaza@lpse ~]$
{% endhighlight %}

File konfigurasi spse.conf

{% highlight text %}
[muntaza@lpse ~]$ ls
curl-7.28.1         dblat.zip     modsecurity-apache_2.6.5         setting_selinux.sh  spselat_asli.tgz
curl-7.28.1.tar.gz  jdk1.8.0.tgz  modsecurity-apache_2.6.5.tar.gz  spse.conf
[muntaza@lpse ~]$ sudo cp spse.conf /etc/httpd/conf.d/
[muntaza@lpse ~]$ cd /etc/httpd/conf.d/
[muntaza@lpse conf.d]$ sudo vi spse.conf
[muntaza@lpse conf.d]$ cd ..
[muntaza@lpse httpd]$ ls
conf  conf.d  conf.modules.d  logs  modsecurity.d  modules  run
[muntaza@lpse httpd]$ cd conf
[muntaza@lpse conf]$ pwd
/etc/httpd/conf
[muntaza@lpse conf]$
{% endhighlight %}

Isi file spse.conf :

{% highlight text %}
Alias /file_latihan /home/file_latihan
Alias /file_prod /home/file_prod


SetOutputFilter DEFLATE
DeflateBufferSize 65536
DeflateCompressionLevel 9
DeflateFilterNote Input instream
DeflateFilterNote Output outstream
DeflateFilterNote Ratio ratio
DeflateMemLevel 9
DeflateWindowSize 15
BrowserMatch ^Mozilla/4\.0[678] no-gzip
BrowserMatch "Windows 98" gzip-only-text/html
BrowserMatch "MSIE [45]" gzip-only-text/html
BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html
SetEnvIfNoCase Request_URI \.(?:gif|jpeg|jpe|jpg|png|ico|t?gz|zip|rar|pdf|doc|xls|dat)$ no-gzip dont-vary
LogFormat '"%r" %{outstream}n/%{instream}n (%{ratio}n%%)' deflate
CustomLog /var/log/httpd/deflate_log deflate

<IfModule mod_headers.c>
   Header append Vary User-Agent env=!dont-vary
</IfModule>

##Update By JF##
ProxyRequests Off
ProxyVia Off
ProxyPreserveHost On
ProxyTimeout 600
ProxyPass /eproc43lat http://localhost:9909/eproc43lat
ProxyPassReverse /eproc43lat http://localhost:9909/eproc43lat


#<VirtualHost *:80>
# LogLevel warn
# CustomLog /var/log/httpd/access.log combined
# RedirectMatch ^/$ /eproc4
# RedirectMatch ^/latihan$ /latihan/
# AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript application/x-httpd-php
# SetInputFilter DEFLATE
# SetOutputFilter DEFLATE
#</VirtualHost>

<IfModule mod_evasive20.c>
    DOSHashTableSize    6194
    DOSPageCount        25
    DOSSiteCount        80
    DOSPageInterval     1
    DOSSiteInterval     1
    DOSBlockingPeriod   10
</IfModule>

SecAuditEngine RelevantOnly
SecRequestBodyAccess On
SecResponseBodyAccess On
SecAuditLogParts ABCFHZ
SecAuditLog /var/log/httpd/audit_apache.log
SecDebugLog /var/log/httpd/modsec_debug.log
SecDebugLogLevel 3
SecDefaultAction log,auditlog,deny,status:403,phase:2,t:none
SecRuleEngine On
SecServerSignature "Netscape-Enterprise/6.0 PHP5.2.0 mod_asp/3.4.5"
SecRule ARGS "\.\./"
SecRule ARGS "<[[:space:]]*script"
#SecRule ARGS "<(.|\n)+>"
SecRule REQUEST_BODY "(document\.cookie|Set-Cookie|SessionID=)"
SecRule REQUEST_BODY "<[^>]*meta*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*style*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*script*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*iframe*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*object*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*img*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*applet*\"?[^>]*>"
SecRule REQUEST_BODY "<[^>]*form*\"?[^>]*>"
SecRule REQUEST_HEADERS:User-Agent "Nikto" "log,deny,status:403,msg:'Nikto Scanners Identified'"
SecRule HTTP_HOST "\x25"
SecRule HTTP_HOST "^$" "log,allow,msg:'no http host'"
SecRule HTTP_USER_AGENT "^$" "log,allow,msg:'No user agent'"
SecRule REQUEST_BODY "/^(etc|bin|sbin|tmp|var|opt|dev|kernel|exe)$/"
SecRule ARGS "delete[[:space:]]+from"
SecRule ARGS "insert[[:space:]]+into"
SecRule ARGS "select.+from"
SecRule ARGS "\<\!--\#"
#SecRule ARGS "((=))[^\n]*(<)[^\n]+(>)"
SecRule REQUEST_BODY "(\'|\")"
#### bikin logut denied ####
#SecRule REQUEST_BODY "!^[\x20-\x7f]+$"
SecRule REQUEST_URI "^/(bin|cgi|cgi(\.cgi|-91[45]|-sys|-local|s|-win|-exe|-home|-perl)|(mp|web)cgi|(ht|ows-)bin|scripts|fcgi-bin)/"
SecRule REQUEST_BODY "/bin/ps"
SecRule ARGS "wget\x20"
SecRule ARGS "uname\x20-a"
SecRule REQUEST_BODY "/nessus_is_probing_you_"
SecRule REQUEST_URI "^OR 1=1--*"

SecRequestBodyLimit 800000000
SecResponseBodyLimit 800000000


<LocationMatch /cgi-bin/>
SecRule REQUEST_URI "!(script1\.cgi|script2\.cgi|custom_email\.pl|form\.cgi\.exe)"
</LocationMatch>

SecReadStateLimit 15

SecRule RESPONSE_STATUS "@streq 408" "phase:5,t:none,nolog,pass,setvar:ip.slow_dos_counter=+1,expirevar:ip.slow_dos_counter=60"
SecRule IP:SLOW_DOS_COUNTER "@gt 15" "phase:1,t:none,log,drop,msg:'Client Connection Dropped due to high # of slow DoS alerts'"

{% endhighlight %}


Disable port 80

{% highlight text %}
[muntaza@lpse conf]$ ls
httpd.conf  magic
[muntaza@lpse conf]$ sudo cp httpd.conf httpd.conf_asli
[muntaza@lpse conf]$ sudo vi httpd.conf
[muntaza@lpse conf]$ diff httpd.conf httpd.conf_asli
42c42
< #Listen 80
- ---
> Listen 80
[muntaza@lpse conf]$
{% endhighlight %}

Setting SSL

{% highlight text %}
[muntaza@lpse conf]$ pwd
/etc/httpd/conf
[muntaza@lpse conf]$ cd ../conf.d/
[muntaza@lpse conf.d]$ ls
README  autoindex.conf  mod_evasive.conf  mod_security.conf  spse.conf  ssl.conf  userdir.conf  welcome.conf
[muntaza@lpse conf.d]$ sudo cp ssl.conf ssl.conf_asli
[muntaza@lpse conf.d]$ sudo vi ssl.conf
{% endhighlight %}

Tambahkan 7 baris ini di bawah tulisan <VirtualHost _default_:443>

{% highlight text %}
<VirtualHost _default_:443>
 LogLevel warn
 CustomLog /var/log/httpd/access.log combined
 RedirectMatch ^/$ /eproc43lat
 RedirectMatch ^/latihan$ /latihan/
 AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript application/x-httpd-php
 SetInputFilter DEFLATE
 SetOutputFilter DEFLATE
{% endhighlight %}

Sehingga menjadi seperti di atas


## 13. Mulai SPSE v4.3

{% highlight text %}
[muntaza@lpse spselat]$ sudo sh spse4 stop
[sudo] password for muntaza:
Stop SPSE 4 ... /home/appserv/spselat
SPSE 4 stopped

[muntaza@lpse spselat]$ sudo sh spse4 migration
Using JAVA_HOME: /usr/local/src/jdk1.8.0
Sistem akan Melakukan Migration
Harap Dilakukan Backup Database SPSE
[muntaza@lpse spselat]$ sudo sh spse4 start
Starting SPSE 4 ... /home/appserv/spselat
Using JAVA_HOME: /usr/local/src/jdk1.8.0
SPSE 4 started
{% endhighlight %}

Cek log

{% highlight text %}
[muntaza@lpse logs]$ pwd
/home/appserv/spselat/webapp/logs
[muntaza@lpse logs]$ sudo tail -f spse4.3.log
{% endhighlight %}

Buat folder file_latihan

{% highlight text %}
[muntaza@lpse spselat]$ sudo mkdir -p /home/file/file_latihan

[muntaza@lpse spselat]$ sudo sh spse4 restart
Stop SPSE 4 ... /home/appserv/spselat
SPSE 4 stopped
Starting SPSE 4 ... /home/appserv/spselat
Using JAVA_HOME: /usr/local/src/jdk1.8.0
SPSE 4 started
[muntaza@lpse spselat]$ sudo systemctl restart httpd
[muntaza@lpse spselat]$
{% endhighlight %}


## 14. cek hasil nya di https://lpse.muntaza.id/eproc43lat

Alhamdulillah berhasil

Aktifkan tiap booting

{% highlight text %}
[muntaza@lpse ~]$ cd /home/appserv/
[muntaza@lpse appserv]$ ls
spselat
[muntaza@lpse appserv]$ cd spselat/
[muntaza@lpse spselat]$ ls
README.md  framework  spse4  spse4.original  webapp
[muntaza@lpse spselat]$ sudo su
[root@lpse spselat]# echo

[root@lpse spselat]#
[root@lpse spselat]# echo "/home/appserv/spselat/spse4 restart" >> /etc/rc.local
[root@lpse spselat]#
{% endhighlight %}

Aktifkan Konfigurasi SElinux

{% highlight text %}
[muntaza@lpse ~]$ sudo cp setting_selinux.sh /root/
[muntaza@lpse ~]$ sudo su
[root@lpse muntaza]# cd
[root@lpse ~]# echo "sh /root/setting_selinux.sh" >> /etc/rc.local
[root@lpse ~]# exit
exit
[muntaza@lpse ~]$ cat /etc/rc.local
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
/home/appserv/spselat/spse4 restart
sh /root/setting_selinux.sh
[muntaza@lpse ~]$
{% endhighlight %}


Testing hasilnya dengan reboot

{% highlight text %}
[muntaza@lpse ~]$ sudo /sbin/reboot
{% endhighlight %}

Alhamdulillah, kembali berhasil

## 15. Perbaharui sertifikat SSL

Karena sertifikat SSL yang ada adalah bawaan dari Mod SSL, kita harus buat baru
agar dapat di gunakan untuk membeli sertifikat asli dari Penyedia Jasa/Penjual
Sertifikat SSL seperti Comodo.

{% highlight text %}
[muntaza@lpse ~]$ sudo su
[root@lpse muntaza]# cd /etc/ssl
[root@lpse ssl]# ls
certs
[root@lpse ssl]# mkdir private
[root@lpse ssl]# openssl genrsa -out /etc/ssl/private/server.key 2048
Generating RSA private key, 2048 bit long modulus
........+++
............+++
e is 65537 (0x10001)
[root@lpse ssl]# ls
certs  private
[root@lpse ssl]# ls private/
server.key
[root@lpse ssl]# openssl req -new -key /etc/ssl/private/server.key \
> -out /etc/ssl/private/lpse.muntaza.id.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
- -----
Country Name (2 letter code) [XX]:ID
State or Province Name (full name) []:KALIMANTAN SELATAN
Locality Name (eg, city) [Default City]:PARINGIN
Organization Name (eg, company) [Default Company Ltd]:LATIHAN
Organizational Unit Name (eg, section) []:LATIHAN
Common Name (eg, your name or your server's hostname) []:lpse.muntaza.id
Email Address []:muhammad@muntaza.id

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
[root@lpse ssl]#
{% endhighlight %}

Isikan dengan benar pada proses pembuatan file .csr diatas, karena
contoh yang ada hanya ilustrasi

{% highlight text %}
[root@lpse ssl]# ls private/
lpse.muntaza.id.csr  server.key
[root@lpse ssl]#
{% endhighlight %}

Seleteh file .csr jadi, maka file ini di gunakan untuk copy paste
saat ini membeli sertifikat asli. Penulis menyarankan beli Comodo saja
karena Positive SSL dari Comodo harganya hanya Rp99.000 untuk 1 (satu) tahun

Karena ini hanya latihan, penulis menggunakan tanda tangan sendiri pada proses
penerbitan file .crt

{% highlight text %}
[root@lpse ssl]# ls private/
lpse.muntaza.id.csr  server.key
[root@lpse ssl]# openssl x509 -sha256 -req -days 3650 \
> -in /etc/ssl/private/lpse.muntaza.id.csr \
> -signkey /etc/ssl/private/server.key \
> -out /etc/ssl/server.crt
Signature ok
{% endhighlight %}

Nah sudah selesai di tanda tangani he...he..., segera kita rubah file
konfigurasi ssl.conf

{% highlight text %}
[muntaza@lpse ~]$ cd /etc/httpd/conf.d/
[muntaza@lpse conf.d]$ ls
README          mod_evasive.conf   spse.conf  ssl.conf_asli  welcome.conf
autoindex.conf  mod_security.conf  ssl.conf   userdir.conf

[muntaza@lpse conf.d]$ sudo vi ssl.conf
[muntaza@lpse conf.d]$ sudo diff ssl.conf ssl.conf_asli
57,63d56
<  LogLevel warn
<  CustomLog /var/log/httpd/access.log combined
<  RedirectMatch ^/$ /eproc43lat
<  RedirectMatch ^/latihan$ /latihan/
<  AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript application/x-httpd-php
<  SetInputFilter DEFLATE
<  SetOutputFilter DEFLATE
107c100
< SSLCertificateFile /etc/ssl/server.crt
- ---
> SSLCertificateFile /etc/pki/tls/certs/localhost.crt
114c107
< SSLCertificateKeyFile /etc/ssl/private/server.key
- ---
> SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
{% endhighlight %}


Yah sudah aktif, sudah di ganti key default dengan key sementara
coba restart httpd

{% highlight text %}
[muntaza@lpse conf.d]$ sudo systemctl restart httpd
{% endhighlight %}


## 16. Install AIDE

security cek, disini di contohkan AIDE
{% highlight text %}
[muntaza@lpse ~]$ sudo yum install aide

initialisasi aide, lalu copy ke tempat lain
[muntaza@lpse ~]$ sudo su
[root@lpse muntaza]# aide --init

AIDE, version 0.15.1

AIDE database at /var/lib/aide/aide.db.new.gz initialized.

[root@lpse muntaza]# exit
exit
[muntaza@lpse ~]$ sudo cp /var/lib/aide/aide.db.new.gz .
[muntaza@lpse ~]$ sudo chown muntaza aide.db.new.gz
[muntaza@lpse ~]$
{% endhighlight %}


Copy ke tempat lain

{% highlight text %}
muntaza@E202SA ~ $ scp muntaza@lpse.muntaza.id:/home/muntaza/aide*  .
aide.db.new.gz                                                                          100% 2122KB 303.1KB/s   00:07
{% endhighlight %}

Testing check

{% highlight text %}
[muntaza@lpse ~]$ sudo cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
[muntaza@lpse ~]$ sudo aide --check

AIDE, version 0.15.1

All files match AIDE database. Looks okay!

[muntaza@lpse ~]$
{% endhighlight %}

Testing buat file baru di /root/

{% highlight text %}
[muntaza@lpse ~]$ sudo touch /root/.coba
[muntaza@lpse ~]$ sudo aide --check
AIDE 0.15.1 found differences between database and filesystem!!
Start timestamp: 2018-09-30 07:58:05

Summary:
  Total number of files:	59884
  Added files:			1
  Removed files:		0
  Changed files:		0


- ---------------------------------------------------
Added files:
- ---------------------------------------------------

added: /root/.coba
[muntaza@lpse ~]$
{% endhighlight %}

Terlihat kalau pembuatan file .coba tertangkap oleh AIDE (senyum)


## 17. CHKrootkit

Untuk scan root kit di server

{% highlight text %}
[muntaza@lpse ~]$ mkdir chkrootkit
[muntaza@lpse ~]$ cd chkrootkit/
[muntaza@lpse chkrootkit]$ wget -c ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz
[muntaza@lpse chkrootkit]$ wget -c ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.md5

[muntaza@lpse chkrootkit]$ cat chkrootkit.md5
0c864b41cae9ef9381292b51104b0a04  chkrootkit.tar.gz
[muntaza@lpse chkrootkit]$ md5sum chkrootkit.tar.gz
0c864b41cae9ef9381292b51104b0a04  chkrootkit.tar.gz
[muntaza@lpse chkrootkit]$

muntaza@lpse chkrootkit]$ ls
chkrootkit.md5  chkrootkit.tar.gz
[muntaza@lpse chkrootkit]$ tar -xzvf chkrootkit.tar.gz
chkrootkit-0.52/ACKNOWLEDGMENTS
chkrootkit-0.52/check_wtmpx.c
chkrootkit-0.52/chkdirs.c
chkrootkit-0.52/chklastlog.c
chkrootkit-0.52/chkproc.c
chkrootkit-0.52/chkrootkit
chkrootkit-0.52/chkrootkit.lsm
chkrootkit-0.52/chkutmp.c
chkrootkit-0.52/chkwtmp.c
chkrootkit-0.52/COPYRIGHT
chkrootkit-0.52/ifpromisc.c
chkrootkit-0.52/Makefile
chkrootkit-0.52/README
chkrootkit-0.52/README.chklastlog
chkrootkit-0.52/README.chkwtmp
chkrootkit-0.52/strings.c
[muntaza@lpse chkrootkit]$ sudo yum install wget gcc-c++ glibc-static

[muntaza@lpse chkrootkit]$ cd chkrootkit-0.52/
[muntaza@lpse chkrootkit-0.52]$ sudo make sense
cc -DHAVE_LASTLOG_H -o chklastlog chklastlog.c
cc -DHAVE_LASTLOG_H -o chkwtmp chkwtmp.c
cc -DHAVE_LASTLOG_H   -D_FILE_OFFSET_BITS=64 -o ifpromisc ifpromisc.c
cc  -o chkproc chkproc.c
cc  -o chkdirs chkdirs.c
cc  -o check_wtmpx check_wtmpx.c
cc -static  -o strings-static strings.c
cc  -o chkutmp chkutmp.c
[muntaza@lpse chkrootkit-0.52]$
{% endhighlight %}

Test jalankan

{% highlight text %}
[muntaza@lpse chkrootkit-0.52]$ sudo ./chkrootkit
{% endhighlight %}


## 18.Firewall Tambahan

Firewall ini adalah dengan menggunakan System Operasi OpenBSD dan
Firewall PF, dengan fitur Synproxy, Anti DOS, dan Hanya menerima koneksi
dari IP Indonesia. ini adalah contoh script pf.conf:

{% highlight text %}
#       $Id: pf.conf_gateway,v 1.9 2015/01/05 05:37:27 muntaza Exp $
#       $OpenBSD: pf.conf,v 1.53 2014/01/25 10:28:36 dtucker Exp $

# macros
ext_if = "axe0"
int_if = "axe1"

server = "10.0.0.3"
tcp_services = "https"

laptop_admin = "192.168.0.1"
local = "ssh"

# options
set skip on lo

# match rules
match out on $ext_if inet from $server to any nat-to $ext_if:0

# filter rules
block return    # block stateless traffic

# block ip attacker
table <ip_attacker> persist file "/etc/ip_attacker"
block in quick from <ip_attacker>

table <abusive_hosts> persist
block in quick from <abusive_hosts>

table <ip_indonesia> persist file "/etc/ip_indonesia"

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

pass in on $ext_if inet proto tcp from <ip_indonesia> to $ext_if \
    port ssh \
    flags S/SA synproxy state \
    (max-src-conn 100, max-src-conn-rate 15/5, overload <abusive_hosts> flush)

# izinkan website Qualys melakukan scan kualitas SSL
pass in on $ext_if inet proto tcp from 64.41.200.0/24 to $ext_if \
    port $tcp_services rdr-to $server port $tcp_services \
    flags S/SA synproxy state


pass out on $int_if inet proto tcp to $server \
    port $tcp_services


# izinkan dari firewall ke server
pass out on $int_if inet proto tcp to $server \
    port 22

block in quick from urpf-failed to any  # use with care

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

{% endhighlight %}

Penjelasan lebih lanjut terkait OpenBSD PF ini ada di blog penulis yang penulis cantumkan
di bagian paling bawah daftar pustaka


## 19. Hal-hal yang masih belum di selesaikan

Karena terbatasnya waktu, maka ada beberapa hal yang belum penulis
tuntaskan, yaitu:

- Setting cron agar menjalankan AIDE dan CHKrootKIT tiap jam 00.00
- Back up database tiap jam 01.00
- Instalasi Mail Server untuk mengirimkan hasil cron pengecekan AIDE dan CHKrootKIT
    ke Alamat email administrator (percuma ada AIDE tapi admin tidak dapat
    alert tiap ada gejala mencurigakan)
- Membuka port untuk Cloud LPSE
- etc.

Dan masih ada hal-hal lain yang kurang, dan penulis tidak bisa berjanji
untuk menyelesaikan toturial ini, sehingga di harapkan admin system lain
yang punya waktu dan kesempatan untuk menyempurnakannya.


Sementara sampai di sini dulu kawan-kawan para System Admin LPSE.
Semoga bermanfaat.


# Alhamdulillah

Abu Muhammad Muhammad Muntaza bin Hatta

Admin LPSE Kabupaten Balangan - KALSEL (s.d 2018)

muhammad@muntaza.id




Daftar Pustaka
-  https://info.timlpse.lomboktengahkab.go.id/?p=6157
-  http://kloxo.web.id/?p=44
-  https://www.digitalocean.com/community/tutorials/how-to-protect-against-dos-and-ddos-with-mod_evasive-for-apache-on-centos-7
-  https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts
-  https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-apache-for-centos-7
-  https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-centos7
-  https://www.tecmint.com/check-integrity-of-file-and-directory-using-aide-in-linux/
-  http://www.chkrootkit.org
-  https://linoxide.com/linux-how-to/install-chkrootkit-linux/
-  https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/index
-  https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/index
-  https://www.cyberciti.biz/tips/linux-security.html
-  https://www.tldp.org/LDP/solrhe/Securing-Optimizing-Linux-The-Ultimate-Solution-v2.0.pdf
-  https://www.tecmint.com/linux-server-hardening-security-tips/
-  https://muntaza.wordpress.com/2016/08/17/openbsd-pf-firewall-untuk-terima-koneksi-hanya-dari-ip-indonesia/
