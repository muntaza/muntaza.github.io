---
layout: post
title:  "Instalasi Ubuntu 8.04"
date:   2008-06-04 11:26:56 +0800
categories: linux
---

# Bismillah,

Kemaren tanggal 3 Juni 2008, aku menginstall Ubuntu 8.04-desktop. 
Menginstallnya dari windows dengan file iso. 
Aku mendapat file iso dari temanku lalu ku copy file iso ke hardisk, 
lalu di mount dengan sebuah program untuk melakukan mounting file iso di Windows. 
Adapun di linux, tidak perlu program khusus untuk mounting file iso, cukup dengan command "mount" saja.

Cara lain, adalah dengan burning file iso ke CD-R, lalu masukkan CD-R nya ke drive nya.

Kembali ke pembicaraan tadi, setelah dimount, aku masuk ke drive tempat me mount, 
lalu klik file "wubi", tampil menu instalasi, klik Install inside Windows, 
lalu tampil menu pilihan drive yang akan diinstall, 
pilih drive hardisknya (yang ada ruang kosong 10GB, misal drive C), 
masukkan username, masukkan password, lalu install.

Setelah file image nya tercopy ke disk, lalu reboot.

Setelah booting, lalu ada menu pilihan windows dan Ubuntu, aku pilih Ubuntu, 
lalu masuk ke Ubuntu dan melanjutkan proses instalasinya.

Setelah selesai, reboot, boot lagi ke Ubuntu, cek sound ternyata OK he..he..

Kesimpulan:

Sangat ku sarankan bagi pemula-pemula yang bingung cara mempartisi di linux 
untuk menginstall Ubuntu dari Windows seperti ini, karena tidak perlu takut kehilangan data karena salah mempartisi. 

Proses instalasi ini sama sekali tidak berhubungan dengan partisi disk yang agak menyulitkan pemula linux

Ubuntu ini, menggunakan NT loader untuk booting, jadi mengedit file boot.ini di drive C, 
file boot.ini ku isinya menjadi seperti ini:

```text
[boot loader]
timeout=15
default=multi(0)disk(0)rdisk(0)partition(1)\WINDOWS
[operating systems]
multi(0)disk(0)rdisk(0)partition(1)\WINDOWS="Microsoft Windows XP Home Edition" /noexecute=optin /fastdetect
c:\wubildr.mbr="Ubuntu"
```

Salam, Muhammad Muntaza bin Hatta

Tinggal di kota Paringin, Kab. Balangan, Prov. Kalimantan Selatan

# Alhamdulillah

Update 21 September 2021:
- Perubahan beberapa kalimat dan susunan penulisan.
- Alhamdulillah, Saya sekarang tinggal di Kota Banjarbaru.
