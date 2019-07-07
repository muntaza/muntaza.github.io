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
baik di PHP7.2, yaitu dengan menambahkan '(int)' pada baris 148 di file reportico_report_html.php
dan baris 5380 di file reportico.php. Ini hasil diff dari file yang saya edit:


{% highlight text %}

$ diff -w php5_laporan/reportico_report_html.php  php5_laporan_persediaan/reportico_report_html.php
148c148
< 				( $this->page_height * (int)$height_string ) / 100;
---
> 				( $this->page_height * $height_string ) / 100;
$ diff -w php5_laporan/reportico.php php5_laporan_persediaan/reportico.php
5380c5380
< 				(int)$col->old_column_value +
---
> 				$col->old_column_value +

{% endhighlight %}

Alhamdulillah, untuk saat ini, Reportico 4.6 berfungsi kembali. Sebenarnya saya sudah
menginstall Reportico 6.0.11, namun masih kurang stabil menurut saya, sehingga
saya memilih kembali aja ke Reportico 4.6.

Alternatif yang tersedia seandainya solusi ini tidak jalan, adalah install OpenBSD 6.4 yang
masih menyediakan PHP5.6 (dengan Postgresql 10 tentunya), atau tetap di OpenBSD 6.5 dan
mengcompile PHP5.6 dari source, yang
mana kedua solusi ini cukup memberatkan saya.

Alhamdulillah, ketemu solusi ini, dan semoga tidak ada kendala kedepannya. Aamiin.

# Alhamdulillah
