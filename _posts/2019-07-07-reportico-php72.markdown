---
layout: post
title:  "Reportico 4.6 dengan PHP 7.2"
date:   2019-07-07 12:26:56 +0800
categories: php7
---

# Bismillah,

Sebagaimana telah maklum, bahwa koneksi kita kecepatannya kadang turun naik, nah, biasanya
di desktop, kita akan menggunakan browser untuk mengecek kecepatan koneksi ini. Hasil test
dari browser seperti gambar di bawah ini.

![Gambar1](/assets/speedtest1.png)

Saya pribadi lebih suka aplikasi berbasis command line, di sini yang di gunakan adalah
speedtest-cli. Di Linux Mint saya, sudah saya install speedtest-cli dengan perintah apt.
Di bawah ini contoh hasil pengecekan kecepatan dengan command line.

{% highlight bash %}

muntaza@E202SA:~$ speedtest-cli
Retrieving speedtest.net configuration...
Testing from Telkomsel (114.125.174.166)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by My Republic Indonesia (Jakarta) [0.65 km]: 75.313 ms
Testing download speed..........................................
Download: 15.49 Mbit/s
Testing upload speed............................................
Upload: 4.49 Mbit/s
muntaza@E202SA:~$


muntaza@E202SA:~$
muntaza@E202SA:~$ speedtest-cli
Retrieving speedtest.net configuration...
Testing from Telkomsel (114.125.174.166)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by MYMATRIX (Jakarta) [0.65 km]: 73.489 ms
Testing download speed..........................................
Download: 19.24 Mbit/s
Testing upload speed...........................................
Upload: 4.23 Mbit/s
muntaza@E202SA:~$


{% endhighlight %}

Dari hasil di atas, terlihat bahwa pengecekan dengan speedtest-cli cukup akurat
menurut saya, tidak jauh beda dari pengecekan dengan web browser.


# Alhamdulillah
