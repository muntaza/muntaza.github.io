---
layout: post
title:  "OpenBSD-httpd Web Server dan PHP"
date:   2019-08-31 12:26:56 +0800
categories: openbsd
---

# Bismillah,

Setelah sekian lama Apache httpd saya gunakan bersama PHP sebagaimana
saya tulis pada tutorial saya di [sini](https://www.muntaza.id/openbsd/2019/03/17/deploy-openbsd1.html), maka saya melihat bahwa server sangat terbenani dengan konfigurasi ini, sehingga saya memutuskan, untuk menjadikan OpenBSD-httpd Web Server untuk menjalankan program PHP. Hasilnya adalah peningkatan kinerja server, karena OpenBSD-httpd lebih ringan dan tidak banyak memakan sumber daya sistem.

Untuk membedakan dengan direktori 'htdocs' yang dilayani Apache httpd, saya membuat direktori baru yaitu direktori 'pub' di bawah /var/www.

{% highlight text %}
$ ls -ld /var/www/pub
drwxr-xr-x  5 root  daemon  512 Jul 22 08:07 /var/www/pub
{% endhighlight %}

Konfigurasi OpenBSD-httpd Web Server berada di /etc/httpd.conf, ini adalah contoh isi file tersebut:

{% highlight text %}
server "latihan.muntaza.id" {
        listen on * tls port 4443
        root "/pub"

        # Set max upload size to 513M (in bytes)
        connection max request body 537919488

        # Set max timeout to 600 seconds
        connection request timeout 600

        tls {
                certificate "/etc/ssl/latihan.muntaza.id.crt"
                key "/etc/ssl/private/latihan.muntaza.id.key"
        }
        location "/pub/*" {
                directory index index.php
        }
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }


        # First deny access to the specified files
        location "/db_structure.xml" { block }
        location "/.ht*"             { block }
        location "/README"           { block }
        location "/data*"            { block }
        location "/config*"          { block }


        location "*.php*" {
                fastcgi socket "/run/php-fpm.sock"
        }
}

{% endhighlight %}

Berikut penjelasan isi konfigurasi httpd.conf diatas:

{% highlight text %}
server "latihan.muntaza.id" {
{% endhighlight %}

Nama Web Server yang digunakan

{% highlight text %}
        listen on * tls port 4443
{% endhighlight %}

Port 4443 dengan TLS di aktifkan

{% highlight text %}
        connection max request body 537919488
{% endhighlight %}

Koneksi dan transfer data dari server, maksimal sekitar 513 MB


{% highlight text %}
        connection request timeout 600
{% endhighlight %}

Saat download file besar, diperlukan batas timeout yang cukup, disini
saya contohkan 10 menit, yang mana kalau batas ini terlalu rendah,
maka koneksi akan di putus oleh server saat melewati batas waktu timeout yang
didefinisikan.


{% highlight text %}
        tls {
                certificate "/etc/ssl/latihan.muntaza.id.crt"
                key "/etc/ssl/private/latihan.muntaza.id.key"
        }
{% endhighlight %}

Konfigurasi kunci publik dan kunci private untuk menjalankan TLS

{% highlight text %}
        location "/.well-known/acme-challenge/*" {
                root "/acme"
                request strip 2
        }
{% endhighlight %}

Setting acme untuk pembuatan free SSL Certificate.


{% highlight text %}
        location "/db_structure.xml" { block }
        location "/.ht*"             { block }
        location "/README"           { block }
        location "/data*"            { block }
        location "/config*"          { block }
{% endhighlight %}

Block file-file sensitif yang mengandung 'password' atau konfigurasi PHP
yang tidak boleh di download oleh user.

{% highlight text %}
{% endhighlight %}


{% highlight text %}
{% endhighlight %}


{% highlight text %}
httpd_flags=
pkg_scripts=php56_fpm
{% endhighlight %}




# Alhamdulillah
