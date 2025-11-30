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

# UPDATE 31 Maret 2019
website pindah alamat ke [www.muntaza.id](https://www.muntaza.id)

# Fitur lain Jekyll

- Generate seluruh website untuk di letakkan di Apache Root Directory

Kita bisa menggunakan perintah build, sehingga seluruh website
di generate dan tinggal meletakkan folder tersebut di Apache Root Direktory.
Contoh penggunaannya:

{% highlight text %}
$ ~/.gem/ruby/2.6.0/bin/jekyll build -d muntaza.github.io
Configuration file: /home/muntaza/working/muntaza.github.io/_config.yml
            Source: /home/muntaza/working/muntaza.github.io
       Destination: /home/muntaza/working/muntaza.github.io/muntaza.github.io
 Incremental build: disabled. Enable with --incremental
      Generating... 
                    done in 3.921 seconds.
 Auto-regeneration: disabled. Use --watch to enable.
{% endhighlight %}

- Serve Jekyll dengan local webservice

Jekyll datang dengan webserver bawaannya, yang bisa kita gunakan 
untuk mengetest hasil editan/postingan kita, sebelum di publish
di internet. Kita bisa mengakses ke http://localhost:4000

Berikut ini contohnya:

{% highlight text %}
$ ~/.gem/ruby/2.6.0/bin/jekyll serve --trace
Configuration file: /home/muntaza/working/muntaza.github.io/_config.yml
            Source: /home/muntaza/working/muntaza.github.io
       Destination: /home/muntaza/working/muntaza.github.io/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
                    done in 4.333 seconds.
 Auto-regeneration: enabled for '/home/muntaza/working/muntaza.github.io'
    Server address: http://127.0.0.1:4000/
  Server running... press ctrl-c to stop.
{% endhighlight %}

Sekian dan semoga bermanfaat.

# Alhamdulillah


Daftar Pustaka

1. [Github Pages Jekyll](https://www.google.com/search?q=github+pages+jekyll)
