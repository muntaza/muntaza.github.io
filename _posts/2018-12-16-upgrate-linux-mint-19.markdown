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

Setelah beberapa kali gagal crash, lalu akhirnya selesai proses upgrade linux mint, Namun ternyata gagal booting ke Linux Mint 19.

Lalu penulis booting ulang dengan flash disk Linux mint 18.1, mengcopy file iso Linux Mint 19.0 ke flash disk lain dengan perintah dd

Booting ulang lagi dengan flash disk Linux Mint 19.0, install di partisi lain dan Alhamdulillah, berhasil di install. Ini screenshoot nya:

![Gambar2](/assets/Linux_mint_desktop.png)

Satu permasalah lagi, saya kehilangan password yang tersimpan di Linux Mint lama saya, setelah browsing di google, menemukan alamat ini:

[Recover user names and passwords -Firefox Forum Support-](https://support.mozilla.org/en-US/questions/1189667)

Maka langkah yang saya lakukan adalah mensetting firefox di Linux Mint 19 agar menggunakan master password, maka file key3.db menjadi file key4.db di folder firefox. Saya kemudian mengcopy tindih (replace) file key4.db dan file login.json dari folder firefox di Linux Mint 18.1 ke folder Firefox 19.0

ini command nya:


{% highlight bash %}
muntaza@E202SA:/media/muntaza/67cf12b2-b88f-4726-9f5d-61faa90cb86b/home/muntaza/.mozilla$ cp firefox/mwad0hks.default/key4.db ~/.mozilla/firefox/xxxgxf3x.default/key4.db

muntaza@E202SA:/media/muntaza/67cf12b2-b88f-4726-9f5d-61faa90cb86b/home/muntaza/.mozilla$ cp firefox/mwad0hks.default/logins.json ~/.mozilla/firefox/xxxgxf3x.default/

{% endhighlight %}

Alhamdulillah, semua user name dan password yang tersimpan bisa kembali di gunakan, dengan master password lama.

Alhamdulillah, serasa memiliki laptop baru, karena tampilan Linux Mint 19.0 sangat bagus.

# Alhamdulillah
