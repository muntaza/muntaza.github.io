---
layout: post
title:  "OpenBSD 7.1 pada Asus E202S"
date:   2022-06-01 11:26:56 +0800
categories: openbsd
---

# Bismillah,

Catatan instalasi OpenBSD 7.1 pada Laptop Asus E202S. Di bawah ini beberapa foto 
layar Laptop tersebut (gambar), akan saya beri komentar sedikit di bagian bawahnya.

<img src="/assets/openbsd_71/openbsd_71_e.jpeg" alt="openbsd_71_e" width="400"/>

Setting Grub2, sebenarnya chainloader +1 ini tidak berfungsi, karena type partisinya
GPT, namun yang di pakai di sini adalah perintah "exit", dengan perintah ini
maka langsung Grub2 meload bootloader OpenBSD sebagaimana gambar di bawah ini:

<img src="/assets/openbsd_71/openbsd_71_d.jpeg" alt="openbsd_71_d" width="400"/>

Nah, terlihat bootloader OpenBSD sudah berhasil di tampilkan oleh Grub2.

<img src="/assets/openbsd_71/openbsd_71_c.jpeg" alt="openbsd_71_c" width="400"/>

Proses booting, terlihat tulisan huruf dengan background biru, khas OpenBSD, he..he..

Di sini sedikit saya sampaikan, bahwa baru kali ini, di rilis 7.1 ini, saya bisa
mengatur kecerahan layar atau screen brightness pada laptop Asus S202S ini.
Saya atur agar brightness nya 10% sebagaimana terlihat pada gambar.

<img src="/assets/openbsd_71/openbsd_71_b.jpeg" alt="openbsd_71_b" width="400"/>

Tampil menu login, he...he...

<img src="/assets/openbsd_71/openbsd_71_a.jpeg" alt="openbsd_71_a" width="400"/>

Tampilkan versi OpenBSD nya.

Beberapa hal yang masih kurang, yaitu interface wifi 
belum di support bahkan sampai versi 7.1 ini, he..he.., jadi tidak bisa konek internet
dari laptop ini, duh....
Solusi nya mungkin dengan di belikan USB Wifi merk TP link.

Tanya jawab:

1. Mengapa menginstall OpenBSD di hardisk, bukankah bisa di Virtualbox?

     Jawaban:

     Karena kita menginstall di hardware langsung, di bare metal, di mesin langsung,
     akan terasa jauh berbeda dengan kalau hanya mencoba di mesin virtual seperti
     Virtualbox. Saya pribadi menginstall nya di Laptop yang berisi data dengan menyiapkan
     partisi khusus untuk OpenBSD. Saran saya, kalau ragu dan takut kehilangan data,
     sebaiknya instalasi di lakukan pada laptop khusus yang tidak dual boot.

2. OpenBSD jarang di gunakan di Indonesia, saya belum pernah ketemu pengguna OpenBSD, 
   Apa manfaat belajar OpenBSD?

     Jawaban:

     Sedikitnya jumlah pengguna tidak menunjukkan bahwa Sistem Operasi OpenBSD tidak bagus.
     Manfaat belajar OpenBSD diantaranya; melatih skill command line, terbuka kesempatan
     belajar PF Firewall, dan OpenBSD termasuk Sistem Operasi yang secure by default sehingga
     relatif lebih aman menurut saya.


Sekian dulu cerita dari saya, semoga bermanfaat.

# Alhamdulillah
