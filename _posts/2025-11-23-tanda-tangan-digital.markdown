---
layout: post
title:  "Tanda Tangan Digital dengan GnuPG"
date:   2025-11-23 11:26:56 +0800
categories: cryptography
---

# Bismillah,

Tanda Tangan Digital berguna untuk memvalidasi bahwa pesan yang di kirim itu
benar sesuai dengan yang di tulis oleh pengirim pesan. Disini saya mencontohkan
pengiriman pesan dari user muntaza ke user khalid, kemudian user khalid memverifikasi
pesan tersebut.

Proses validasi pesan menggunakan software yang bernama [GnuPG](https://www.gnupg.org/gph/en/manual/book1.html). Baik, disini kita mulai proses nya. Gunakan perintah _id_ untuk menampilkan user yang aktif:

```text
$ id
uid=1000(muntaza) gid=1000(muntaza) groups=1000(muntaza)
```

Tampilkan keyid yang dimiliki oleh muntaza:

```text
$ gpg --list-key --keyid-format=long muhammad@muntaza.id
pub   rsa2048/C618BBE52188BDF7 2017-12-06 [SC]
```

[Kirim](https://askubuntu.com/questions/220063/how-do-i-publish-a-gpg-key) public key ke keyserver [keyserver.ubuntu.com](https://keyserver.ubuntu.com/)

```text
$ gpg --keyserver keyserver.ubuntu.com --send-keys C618BBE52188BDF7
gpg: sending key C618BBE52188BDF7 to hkp://keyserver.ubuntu.com
```

Setelah itu, muntaza membuat pesan pada file _data.txt_ dengan isi pesan "ini latihan":

```text
$ echo "ini latihan" > data.txt
$ ls
data.txt
$ cat data.txt 
ini latihan
```

Tanda tangani file _data.txt_ tadi dengan perintah berikut:

```text
$ gpg --clear-sign data.txt
$ ls
data.txt  data.txt.asc
```

Terlihat diatas, bahwa sudah ada file baru dengan nama _data.txt.asc_, sekarang kita lihat isinya:

```text
$ cat data.txt.asc 
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

ini latihan
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEEKSspj2RhQXYVHdZxhi75SGIvfcFAmkiv1IACgkQxhi75SGI
vfcEOAgAnu41rd31ym5+4B2a+ZFmlhLbscIg+JXPl3txtUn6L6j1n50+mM58trb2
9ZuMc8h2JKD0IQYgV/uU5EepbUU+/JTKM7V15/SJx2F2wjbL/v0FXm3nDItkzh0m
yO+sII7ys8oKUFWa8gaX581Izpr0MwCxR/SDsdYlgcvOuFn72RU6gl2KmgA1QKz0
LoUYoFjRYMTInGutQf0apxWUfAB8SXovXodzzrHDEPIKkvT4zgMLCWF5EOt+cP3K
JQUvegXci5CcWo4ysxng1aX9E64Y3esE8gXf5C1G7ORlZyc1k+5TWyryBrFac6Mt
jehtkVjIGurLPA5DyNTm4GyEWd/V9Q==
=Kunz
-----END PGP SIGNATURE-----
```

Baik, kita copy file tersebut ke folder /tmp

```text
$ cp data.txt.asc /tmp/
```

Sekarang pindah ke user khalid, cek dengan peritah _id_

```text
$ id
uid=1005(khalid) gid=1005(khalid) groups=1005(khalid)
```

Khalid mencoba melakukan verifikasi terhadap pesan yang dikirim oleh muntaza. Terlihat bahwa pesan nya tidak bisa di verifikasi, hal ini karena belum ada public key muntaza.

```text
$ gpg --verify /tmp/data.txt.asc 
gpg: Signature made Sun 23 Nov 2025 04:03:33 PM WITA
gpg:                using RSA key 10A4ACA63D918505D8547759C618BBE52188BDF7
gpg: Can't check signature: No public key
```

Baik, Khalid akan [mendownload](https://askubuntu.com/questions/36507/how-do-i-import-a-public-key)
 public key dari keyserver.ubuntu.com

```text
$ gpg --keyserver keyserver.ubuntu.com --recv C618BBE52188BDF7
gpg: key C618BBE52188BDF7: public key "Muhammad Muntaza <muhammad@muntaza.id>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

Setelah public key didownload, Khalid melakukan verifikasi terhadap pesan yang dikirim. Disini terlihat bahwa pesan ini masih original, tidak ada perubahan pada pesan. Tandanya adalah 
adanya tulisan "Good signature from ..."

```text
$ gpg --verify /tmp/data.txt.asc 
gpg: Signature made Sun 23 Nov 2025 04:03:33 PM WITA
gpg:                using RSA key 10A4ACA63D918505D8547759C618BBE52188BDF7
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: Good signature from "Muhammad Muntaza <muhammad@muntaza.id>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 10A4 ACA6 3D91 8505 D854  7759 C618 BBE5 2188 BDF7
```

Khalid melihat isi pesan:

```text
$ cat /tmp/data.txt.asc 
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

ini latihan
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEEKSspj2RhQXYVHdZxhi75SGIvfcFAmkiv9UACgkQxhi75SGI
vffL4wf+I4i1en0BGTEfzLB3SWqazQQpGaseYkFdYCMXY94k2g7t0y5GalK2txW/
NWyfkawq6EbJNSEq1SVBG55+RJKdqtcWXFoLyhiXmCUTrsln9ngy9DC+sqzrrlIp
w6EDh2BDLwpy0qZdlNzCTIOnVuPA49+zjxggZBu8WFH5sZN2MOGOQupAWs4qjTON
be0odob5Q2CPd0yH1cuapt0IC2pfpVNdB6JkXhWvhnSGING8iqURgD+9qW9hh5hf
vVbqv9gHtxucf0rnuOewrtSoT3thi0qLswf3PISug+yeJlC9cH7QgM7TTpuOVHL/
ZbbR0JoFU0ofeeQKqmXwl0di6+8vYA==
=HRuV
-----END PGP SIGNATURE-----
```

Demikian gambaran sederhana penggunaan tanda tangan digital. Hal ini
juga bermanfaat untuk [verifikasi](https://www.muntaza.id/ssh/2019/12/05/verify-iso-file.html) file, misalnya file iso yang akan digunakan
untuk menginstall sistem operasi.

Dibawah ini contoh sekiranya file yang dikirim mengalami perubahan dalam perjalanan nya. Kita akan mengedit file dan merubah isi pesan menjadi "ini laporan".

```text
$ cp /tmp/data.txt.asc .
$ vim data.txt.asc
$ cat data.txt.asc 
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

ini laporan
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEEKSspj2RhQXYVHdZxhi75SGIvfcFAmkiv9UACgkQxhi75SGI
vffL4wf+I4i1en0BGTEfzLB3SWqazQQpGaseYkFdYCMXY94k2g7t0y5GalK2txW/
NWyfkawq6EbJNSEq1SVBG55+RJKdqtcWXFoLyhiXmCUTrsln9ngy9DC+sqzrrlIp
w6EDh2BDLwpy0qZdlNzCTIOnVuPA49+zjxggZBu8WFH5sZN2MOGOQupAWs4qjTON
be0odob5Q2CPd0yH1cuapt0IC2pfpVNdB6JkXhWvhnSGING8iqURgD+9qW9hh5hf
vVbqv9gHtxucf0rnuOewrtSoT3thi0qLswf3PISug+yeJlC9cH7QgM7TTpuOVHL/
ZbbR0JoFU0ofeeQKqmXwl0di6+8vYA==
=HRuV
-----END PGP SIGNATURE-----
```

Lalu Khalid melakukan verifikasi terhadap file yang sudah di edit:

```text
$ gpg --verify data.txt.asc 
gpg: Signature made Sun 23 Nov 2025 04:03:33 PM WITA
gpg:                using RSA key 10A4ACA63D918505D8547759C618BBE52188BDF7
gpg: BAD signature from "Muhammad Muntaza <muhammad@muntaza.id>" [unknown]
```

Dengan perubahan pada isi pesan, muncul tulisan "BAD signature from ...". 

Kesimpulan dari tulisan ini, pesan asli atau original akan menampilkan "Good Signature .." sedangkan pesan yang sudah tidak asli lagi sebaliknya, menampilkan "BAD Signature ...". Jadi, insyaAllah, dengan aplikasi GnuPG ini, file dapat di kirim dan diverifikasi kebenarannya.

Demikian, semoga bermanfaat.


# Alhamdulillah
