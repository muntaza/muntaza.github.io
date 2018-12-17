---
layout: post
title:  "Github Pages dan Jekyll"
date:   2018-12-04 11:26:56 +0800
categories: kisah
---

Bismillah,

Hosting sudah sangat murah, lebih dari itu VPS pun juga tidak mahal, tapi ada yang lebih murah, hosting gratis di Github Pages. OK, mungkin banyak yang berfikir akan pusing menulis file html murni, nah itu ada solusinya, yaitu menggunakan jekyll, yang sudah terintegrasi dengan Github Pages. Yuk, ini catatan kecil saya tentang Github Pages dan Jekyll, selamat menikmati.

Masih agak bingung dari mana memulai, he...he..

Buat Repository dengan nama username.github.io

![Gambar1](/assets/github1.png)

Clone Repository baru tadi ke laptop

{% highlight bash %}
muntaza@E202SA:~/tmp$ git clone git@github.com:muntaza/muntaza.github.io.git
Cloning into 'muntaza.github.io'...
remote: Enumerating objects: 38, done.
remote: Counting objects: 100% (38/38), done.
remote: Compressing objects: 100% (25/25), done.
remote: Total 297 (delta 19), reused 32 (delta 13), pack-reused 259
Receiving objects: 100% (297/297), 1.02 MiB | 300.00 KiB/s, done.
Resolving deltas: 100% (121/121), done.
{% endhighlight %}


Install jekyll di laptop

{% highlight bash %}
muntaza@E202SA:~/tmp$ sudo apt-get install jekyll
{% endhighlight %}

Buat project jekyll dengan nama web

{% highlight bash %}
muntaza@E202SA:~/tmp$ jekyll new web
New jekyll site installed in /home/muntaza/tmp/web.
muntaza@E202SA:~/tmp$ ls
muntaza.github.io  web
{% endhighlight %}

Copy isi folder web ke folder muntaza.github.io

Masukkan file baru ke repository

{% highlight bash %}
muntaza@E202SA:~/tmp/muntaza.github.io$ git add --all
muntaza@E202SA:~/tmp/muntaza.github.io$ git commit --all -m "OK"
muntaza@E202SA:~/tmp/muntaza.github.io$ git push
{% endhighlight %}

Pengaturan Domain, buat alias pada domain untuk mengarah ke muntaza.github.io

![Gambar2](/assets/domain1.png)

Setting alias pada repository

![Gambar3](/assets/github2.png)


# Alhamdulillah


Daftar Pustaka

1. [Github Pages Jekyll](https://www.google.com/search?q=github+pages+jekyll)
