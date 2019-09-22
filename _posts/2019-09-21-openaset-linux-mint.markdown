---
layout: post
title:  "Deploy OpenAset di Linux Mint 19"
date:   2019-09-21 12:26:56 +0800
categories: linux
---

# Bismillah,
{% highlight text %}
{% endhighlight %}

Ini adalah catatan ringkas, sebagai pengingat bagi diri saya pribadi khususnya,
proses deploy aplikasi [OpenAset](https://github.com/muntaza/Open-Aset) di
[Linux Mint](https://www.linuxmint.com/).
Mengapa memilih Linux ketika ini? Jawabannya adalah, agar bisa di lihat bahwa aplikasi
ini tidak hanya bisa jalan di [OpenBSD](https://www.openbsd.org/) saja.

Catatan ini saya buat lebih ringkas dari tulisan saya
[sebelumnya](https://www.muntaza.id/openbsd/2019/03/17/deploy-openbsd1.html), yang mana
di sini saya tidak menampilkan output dari perintah yang saya jalankan, kecuali
sebagian kecilnya saja.


Versi Linux Mint yang di gunakan:

{% highlight text %}
$ cat /etc/linuxmint/info | grep Linux
DESCRIPTION="Linux Mint 19 Tara"
GRUB_TITLE=Linux Mint 19 MATE
{% endhighlight %}

Ganti vim default di sistem dengan vim yang lebih lengkap fitur nya.

{% highlight text %}
$ sudo apt remove vim-tiny
$ sudo apt install vim
{% endhighlight %}

Install CVS, inilah yang saya gunakan untuk mendevelop aplikasi ini:

{% highlight text %}
$ sudo apt install cvs
{% endhighlight %}

Saya mengenal
Git juga, blog saya ini di bangun dengan
[jekyll](https://jekyllrb.com/) yang di hosting di
[Github Pages](https://pages.github.com/) sebagaimana saya
[kisahkan](https://www.muntaza.id/kisah/2018/12/04/github-pages-jekyll.html),
yang mana tentunya menggunakan git untuk menampilkan postingan blog,
namun karena CVS adalah pengelola source code yang pertama saya kenal,
jadi sulit berpindah dari cinta pertama, he...he...

Install [OpenSSH](https://www.openssh.com/) server dan jalankan:

{% highlight text %}
$ sudo apt install openssh-server
$ sudo systemctl restart sshd
{% endhighlight %}

Install [PostgreSQL](https://www.postgresql.org/) versi 10:

{% highlight text %}
$ sudo apt install postgresql-10
$ sudo apt install postgresql-server-dev-10
{% endhighlight %}

Sepertinya server PostgreSQL langsung jalan setelah terinstall,
nah, inilah salah satu kelemahan Linux Mint ini menurut saya,
karena seharusnya, admin lah yang menjalankan suatu server, bukan
otomatis setelah di install langsung jalan, he...he...

Install [Python pip](https://pypi.org/project/pip/), program ini untuk menginstall
Aplikasi python lainnya:

{% highlight text %}
$ sudo apt install python-pip
$ sudo pip install --upgrade pip
$ pip2 --version
pip 19.2.3 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)
{% endhighlight %}

[Python](https://www.python.org/) versi 2 akan [berakhir](https://www.python.org/doc/sunset-python-2/) masa aktif
nya pada 1 Januari 2020, oleh karena ini, saya merencanakan, insyaAllah, menggunakan
python versi 3 pada [OpenBSD 6.6](https://www.openbsd.org/66.html).


Install [Django](https://www.djangoproject.com/):

{% highlight text %}
$ sudo pip2 install Django==1.11.24
$ django-admin --version
1.11.24
{% endhighlight %}


Buat ssh publik key,
upload ke server cvs, untuk mengambil
aplikasi OpenAset nantinya:

{% highlight text %}
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/muntaza/.ssh/id_rsa):
{% endhighlight %}

Bahkan pernah saya
[tegaskan](https://www.muntaza.id/openbsd/ssh/2018/12/09/public-key-only-ssh-openbsd.html) bahwa
seharusnya, koneksi ke ssh hanya bisa dengan publik key saja,
dan menonaktifkan metode authentication lainnya.


Install [apache-httpd2](https://httpd.apache.org/) dan
[mod-wsqi](https://modwsgi.readthedocs.io/en/develop/):


{% highlight text %}
$ sudo apt install apache2 libapache2-mod-wsgi
{% endhighlight %}

Mod-wsgi ini sebagai driver yang menghubungkan Python dengan
Apache Web Server.

Install PHP7.2 dan modul pendukungnya:

{% highlight text %}
sudo apt install php7.2
sudo apt install php7.2-pgsql
sudo apt install php7.2-xml
sudo apt install php7.2-gd
{% endhighlight %}

Termasuk di dalamnya mod-php, yang merupakan driver yang
menghubungkan PHP ke Apache Web server.

Install [Psycopg2]()
yang merupakan driver penghubung Python ke Database PostgreSQL:

{% highlight text %}
sudo pip2 install setuptools
sudo pip2 install psycopg2-binary
{% endhighlight %}

Buat direktori /home/django, untuk menempatkan aplikasi OpenAset:

{% highlight text %}
$ cd /home
$ sudo mkdir django
$ sudo chown muntaza:www-data django
{% endhighlight %}

Berpindah ke server cloud, saya membuat sertifikat ssl dari
[Let’s Encrypt](https://letsencrypt.org/) menggunakan server
cloud saya (dengan sistem operasi OpenBSD),
sertifikat ini untuk domain openaset.muntaza.net
sehingga aplikasi OpenAset ini juga disetting dengan perlindungan
ssl.

Adapun langkahnya, yaitu dengan menambahkan baris dibawah ini pada file
[/etc/httpd.conf](https://man.openbsd.org/httpd.conf):

{% highlight text %}
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
{% endhighlight %}

Menambahkan juga baris dibawah ini pada file
[etc/acme-client.conf](https://man.openbsd.org/acme-client.conf):

{% highlight text %}
domain openaset.muntaza.net {
        domain key "/etc/ssl/private/openaset.muntaza.net.key"
        domain certificate "/etc/ssl/openaset.muntaza.net.crt"
        domain full chain certificate "/etc/ssl/openaset.muntaza.net.fullchain.pem"
        sign with letsencrypt
}
{% endhighlight %}

OK, restart httpd service:

{% highlight text %}
muhammad$ doas rcctl restart httpd
httpd(ok)
httpd(ok)
{% endhighlight %}

Kemudian, buat sertifikat tersebut:

{% highlight text %}
muhammad$ doas acme-client -vAD openaset.muntaza.net
{% endhighlight %}

Nah, sudah di dapat sertifikat nya, tinggal di copy aja sertifikat tadi
ke server Linux Mint.
Hal penting lain, sertifikat ini memiliki masa aktif 3 (tiga) bulan,
sehingga untuk saat ini, saya nonaktifkan domain openaset.muntaza.net
dan setting di file /etc/httpd.conf nya, kemudian pastikan restart lagi
server httpd nya.

{% highlight text %}
muhammad$ doas rcctl restart httpd
httpd(ok)
httpd(ok)
{% endhighlight %}



Setting Apache Web Server:

{% highlight text %}
$ ls -l ssl* sochache*
lrwxrwxrwx 1 root root 36 Sep 21 14:23 sochache_shmcb.load -> ../mods-available/socache_shmcb.load
lrwxrwxrwx 1 root root 26 Sep 21 14:20 ssl.conf -> ../mods-available/ssl.conf
lrwxrwxrwx 1 root root 26 Sep 21 14:20 ssl.load -> ../mods-available/ssl.load
{% endhighlight %}

aktifkan modul ssl dan modul shmcb, dengan membuat file soft link di folder
mods-enabled ke folder mods-available seperti contoh di atas.

Aktifkan konfigurasi ssl config, dengan membuat file soft link di folder
sites-enabled ke folder sites-available seperti contoh di bawah, dan isi
sertifikat ssl sesuai dengan file sertifikat yang kita buat dari Let'e Encrypt
tadi.

{% highlight text %}
/etc/apache2/sites-enabled$ ls -l
total 0
lrwxrwxrwx 1 root root 35 Sep 20 22:08 000-default.conf -> ../sites-available/000-default.conf
lrwxrwxrwx 1 root root 35 Sep 21 14:21 default-ssl.conf -> ../sites-available/default-ssl.conf
/etc/apache2/sites-enabled$ cat default-ssl.conf | grep openaset
		SSLCertificateFile	/etc/ssl/openaset.muntaza.net.fullchain.pem
		SSLCertificateKeyFile /etc/ssl/private/openaset.muntaza.net.key
{% endhighlight %}

Ini isi lengkap file [default-ssl.conf]()

Setting Database PostgreSQL.

Pindah ke user postgres, buat user kabupaten, dan buat Database kabupaten:

{% highlight text %}
sudo su - postgres
$ id
uid=122(postgres) gid=130(postgres) groups=130(postgres),110(ssl-cert)
createuser -U postgres kabupaten -P
createdb -O kabupaten kabupaten
{% endhighlight %}

Restore global Database, yang meliputi pembuatan seluruh user,
kemudian baru restore database kabupaten:

{% highlight text %}
psql -U postgres template1 < global_2019-09-21_13_12.sql
psql -U postgres kabupaten < kabupaten_2019-09-21_00_10.sql
{% endhighlight %}

Restart Apache Web Server:

{% highlight text %}
$ sudo systemctl restart apache2
{% endhighlight %}

Nah, sampai di sini menu entry sudah bisa saya akses. Alhamdulillah

Setting PHP

Saat instalasi PHP, modul mod-php sudah otomatis di aktifkan di
Linux Mint ini, untuk melihatnya, bisa di cek yaitu:

{% highlight text %}
$ pwd
/etc/apache2/mods-enabled
$ ls| grep php
php7.2.conf
php7.2.load
{% endhighlight %}

Saya buat script phpinfo.php yang berguna untuk menvalidasi
setting PHP, dan juga memastikan bahwa Modul php-pgsql dan
php-pdo-pgsql sudah aktif. Ini isi script nya:

{% highlight php %}
<?php
phpinfo();
?>
{% endhighlight %}

Setelah PHP sudah di validasi, tinggal
ambil archive laporan dari server, dan untar di folder /var/www/html.

Selesai sudah proses deploy OpenAset di Linux Mint ini. Semoga
bermanfaat.

# Alhamdulillah
