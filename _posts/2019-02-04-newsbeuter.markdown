---
layout: post
title:  "Newsbeuter, pembaca RSS di command line"
date:   2019-02-04 12:26:56 +0800
categories: linux
---

# Bismillah,

RSS bermanfaat untuk menbaca ringkasan postingan dari suatu website, tanpa perlu mengunjunginya.
Disini saya menggunakan newsbeuter untuk membaca dari command line. Langkah instalasinya adalah
sebagai berikut:


{% highlight bash %}
muntaza@E202SA:~$ sudo apt install newsbeuter

{% endhighlight %}

Setelah terinstall, tinggal masukkan links RSS atau Feed yang di sediakan di website tersebut pada
file ~/.newsbeuter/urls. Ini contoh isi file urls saya.


{% highlight bash %}
muntaza@E202SA:~$ cat ~/.newsbeuter/urls
https://www.muntaza.net/feed.xml
http://undeadly.org/cgi?action=rss
muntaza@E202SA:~$

{% endhighlight %}

Setelah file urls terisi, tinggal buka aplikasinya. perintah "R" untuk reload dari website,
untuk membaca tinggal "Enter" dan untuk keluar "q". Berikut ini contoh tampilannya:

![Gambar1](/assets/newsbeuter1.png)

![Gambar2](/assets/newsbeuter2.png)

![Gambar3](/assets/newsbeuter3.png)

Semoga bermanfaat.

# Alhamdulillah
