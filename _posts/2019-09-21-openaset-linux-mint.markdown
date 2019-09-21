---
layout: post
title:  "Deploy OpenAset di Linux Mint 19"
date:   2019-09-21 12:26:56 +0800
categories: linux
---

# Bismillah,

Ini adalah catatan ringkas, sebagai pengingat bagi diri saya pribadi khususnya,
proses deploy aplikasi [OpenAset](https://github.com/muntaza/Open-Aset) di
[Linux Mint](https://www.linuxmint.com/).
Mengapa memilih Linux ketika ini? Jawabannya adalah, agar bisa di lihat bahwa aplikasi
ini tidak hanya bisa jalan di [OpenBSD](https://www.openbsd.org/) saja.

Catatan ini saya buat lebih ringkas dari tulisan saya
[sebelumnya](https://www.muntaza.id/openbsd/2019/03/17/deploy-openbsd1.html), yang mana
di sini saya tidak menampilkan output dari perintah yang saya jalankan, kecuali
sebagian kecilnya saja.

{% highlight text %}
{% endhighlight %}

Versi Linux Mint yang di gunakan:

{% highlight text %}
$ cat /etc/linuxmint/info | grep Linux
DESCRIPTION="Linux Mint 19 Tara"
GRUB_TITLE=Linux Mint 19 MATE
{% endhighlight %}

$ sudo apt remove vim-tiny
$ sudo apt install vim
$ sudo apt install cvs
$ sudo apt install openssh-server
$ sudo systemctl restart sshd


sudo apt install postgresql-10
sudo apt install python-pip

sudo pip install --upgrade pip
$ pip2 --version
pip 19.2.3 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)

sudo pip2 install Django==1.11.24
$ django-admin --version
1.11.24

buat ssh publik key, upload ke server cvs

muntaza@muntaza-Satellite-C40-A:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/muntaza/.ssh/id_rsa):


$ sudo apt install apache2 libapache2-mod-wsgi

sudo apt install php7.2
sudo apt install php7.2-pgsql
sudo apt install php7.2-xml
sudo apt install php7.2-gd


sudo apt install postgresql-server-dev-10
sudo pip2 install setuptools
sudo pip2 install psycopg2-binary


   64  sudo mkdir django
   70  sudo chown muntaza:www-data django

sudo su - postgres
createuser -U postgres kabupaten -P
createdb -O kabupaten kabupaten

/etc/httpd.conf

server "openaset.muntaza.net" {
        listen on 103.56.207.72 port 80
        root "/htdocs/openaset.muntaza.net"
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }
        location * {
                block return 302 "https://$HTTP_HOST$REQUEST_URI"
        }
}


etc/acme-client.conf

domain openaset.muntaza.net {
        domain key "/etc/ssl/private/openaset.muntaza.net.key"
        domain certificate "/etc/ssl/openaset.muntaza.net.crt"
        domain full chain certificate "/etc/ssl/openaset.muntaza.net.fullchain.pem"
        sign with letsencrypt
}


muhammad$ doas acme-client -vAD openaset.muntaza.net


disable port 80 pada httpd.conf untuk domain openaset.muntaza.net

muhammad$ doas cp httpd.conf /etc/
doas (muntaza@muhammad.muntaza.id) password:
muhammad$ doas rcctl restart httpd
httpd(ok)
httpd(ok)



local setting pada linux mint


$ ls -l ssl* sochache*
lrwxrwxrwx 1 root root 36 Sep 21 14:23 sochache_shmcb.load -> ../mods-available/socache_shmcb.load
lrwxrwxrwx 1 root root 26 Sep 21 14:20 ssl.conf -> ../mods-available/ssl.conf
lrwxrwxrwx 1 root root 26 Sep 21 14:20 ssl.load -> ../mods-available/ssl.load

enable ssl config, isi sertifikat dengan sertifikat yang di dapat lewat let's encrypt tadi.

muntaza@muntaza-Satellite-C40-A:/etc/apache2/sites-enabled$ ls -l
total 0
lrwxrwxrwx 1 root root 35 Sep 20 22:08 000-default.conf -> ../sites-available/000-default.conf
lrwxrwxrwx 1 root root 35 Sep 21 14:21 default-ssl.conf -> ../sites-available/default-ssl.conf
muntaza@muntaza-Satellite-C40-A:/etc/apache2/sites-enabled$ cat default-ssl.conf | grep openaset
		SSLCertificateFile	/etc/ssl/openaset.muntaza.net.fullchain.pem
		SSLCertificateKeyFile /etc/ssl/private/openaset.muntaza.net.key

restore global, restore kabupaten

sebagai user postgres

$ sudo su postgres
postgres@muntaza-Satellite-C40-A:/home/muntaza/back_up$ id
uid=122(postgres) gid=130(postgres) groups=130(postgres),110(ssl-cert)

psql -U postgres template1 < global_2019-09-21_13_12.sql
psql -U postgres kabupaten < kabupaten_2019-09-21_00_10.sql

sudo systemctl restart apache2


PHP sudah di enable, cek setting pgsql dengan script phpinfo

$ cat phpinfo.php
<?php
phpinfo();
?>

ambil archive laporan dari server, dan untar di /var/www/html
selesai.
# Alhamdulillah
