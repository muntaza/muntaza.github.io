---
layout: post
title:  "Upgrade Linux Mint ke Versi 19"
date:   2018-12-16 11:26:56 +0800
categories: linux
---

# Bismillah,

Mengupgrade Linux mint dari versi 18.1 ke versi 19.0, saya mengikuti langkah-langkah yang ada di tutotial ini

[How to Upgrade to Linux Mint 19](https://www.tecmint.com/upgrade-to-linux-mint-19/)

Saat dalam proses upgrade pada command ini:

{% highlight bash %}
$ mintupgrade upgrade
{% endhighlight %}

terjadi error depedency:
![Gambar1](/assets/mint_19_a1.png)

sesudah mencari di google dengan keyword ini:
[dependency problems prevent processing triggers for gconf2](https://www.google.com/search?q=dependency+problems+prevent+processing+triggers+for+gconf2)

maka menemukan solusi nya di forum linux mint:
[-SOLVED- Upgrade from Mint 18.3 to 19 failed](https://forums.linuxmint.com/viewtopic.php?t=276547)

![Gambar1](/assets/mint_19_b.png)

Perintah ini adalah solusinya:

{% highlight bash %}
$ sudo dpkg --configure -a
$ sudo apt-get install -f
$ sudo apt autoremove
$ mintupgrade upgrade
{% endhighlight %}


# Alhamdulillah
