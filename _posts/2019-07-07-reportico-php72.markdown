---
layout: post
title:  "Reportico 4.6 dengan PHP 7.2"
date:   2019-07-07 12:26:56 +0800
categories: php7
---

# Bismillah,

OpenBSD 6.5 datang dengan PHP7, yang saya pilih untuk server kami adalah php7.2

{% highlight text %}

thinkpad$ pkg_info | grep php
php-7.2.18          server-side HTML-embedded scripting language
php-apache-7.2.18   php module for Apache httpd
php-gd-7.2.18       image manipulation extensions for php
php-pdo_pgsql-7.2.18 PDO pgsql database access extensions for php
php-pgsql-7.2.18    pgsql database access extensions for php
thinkpad$

{% endhighlight %}

Namun, masalah muncul saat saya mencoba Reportico 4.6, yaitu error numeric value,
seperti gambar di bawah ini:

![Gambar1](/assets/reportico_error1.png)

Kemudian saya mencoba mencari solusinya di google dan menemukan
link [ini](http://www.reportico.org/forum/d/52152-a-non-well-formed-numeric-value-encountered)
yang berhasil saya terapkan dan membuat Reportico 4.6 bisa jalan dengan
baik di PHP7.2



# Alhamdulillah
