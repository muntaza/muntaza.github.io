---
layout: post
title:  "Perpanjang Masa Aktif GnuPG Key"
date:   2025-12-13 11:00:00 +0800
categories: gnupg
---

# Bismillah,

Saat menggunakan password manager [pass](https://www.muntaza.id/security/2020/04/15/pass.html) saya melihat 
bahwa salah satu [GnuPG](https://www.muntaza.id/cryptography/2025/11/23/tanda-tangan-digital.html) Key saya sudah expired.

```text
abdullah@E202SA:~$ pass -c ssh/abdullah_key 
gpg: Note: secret key 840A4C6EXXXXXXXX expired at Tue 23 Sep 2025 10:21:04 AM WITA
Copied ssh/abdullah_key to clipboard. Will clear in 45 seconds.
```

Baik, saya cek dulu dengan kondisinya:

```text
abdullah@E202SA:~$ 
abdullah@E202SA:~$ gpg --list-key abdullah@muntaza.id
pub   rsa3072 2020-08-16 [SC] [expired: 2025-09-23]
      55FB01545D893727472E1828E8CCFF0EXXXXXXXX
uid           [ expired] Abdullah <abdullah@muntaza.id>
```

Iya, ternyata memang expired, Kemudian, saya akan memperpanjang nya 1 tahun, dengan perintah _"edit-key"_ seperti ini

```text
abdullah@E202SA:~$ 
abdullah@E202SA:~$ gpg --edit-key abdullah@muntaza.id
gpg (GnuPG) 2.2.4; Copyright (C) 2017 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa3072/E8CCFF0EXXXXXXXX
     created: 2020-08-16  expired: 2025-09-23  usage: SC  
     trust: ultimate      validity: expired
ssb  rsa3072/840A4C6EXXXXXXXX
     created: 2020-08-16  expired: 2025-09-23  usage: E   
[ expired] (1). Abdullah <abdullah@muntaza.id>
```

Ketik expire, perpanjang 1 tahun dengan perintah 1y dan konfirmasi.

```text
gpg> expire 
Changing expiration time for the primary key.
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Sun 13 Dec 2026 06:50:43 AM WITA
Is this correct? (y/N) y

sec  rsa3072/E8CCFF0EXXXXXXXX
     created: 2020-08-16  expires: 2026-12-12  usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa3072/840A4C6EXXXXXXXX
     created: 2020-08-16  expired: 2025-09-23  usage: E   
[ultimate] (1). Abdullah <abdullah@muntaza.id>

gpg: WARNING: Your encryption subkey expires soon.
gpg: You may want to change its expiration date too.
```

Kemudian, saya perpanjang juga subkey nya, ketik "key 1", lakukan perintah expire dan perpanjang 1 tahun juga:

```text
gpg> key 1

sec  rsa3072/E8CCFF0EXXXXXXXX
     created: 2020-08-16  expires: 2026-12-12  usage: SC  
     trust: ultimate      validity: ultimate
ssb* rsa3072/840A4C6EXXXXXXXX
     created: 2020-08-16  expired: 2025-09-23  usage: E   
[ultimate] (1). Abdullah <abdullah@muntaza.id>

gpg> expire
Changing expiration time for a subkey.
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Sun 13 Dec 2026 06:52:03 AM WITA
Is this correct? (y/N) y

sec  rsa3072/E8CCFF0EXXXXXXXX
     created: 2020-08-16  expires: 2026-12-12  usage: SC  
     trust: ultimate      validity: ultimate
ssb* rsa3072/840A4C6EXXXXXXXX
     created: 2020-08-16  expires: 2026-12-12  usage: E   
[ultimate] (1). Abdullah <abdullah@muntaza.id>
```


Langkah terakhir, ketik "save" untuk menyimpan. 

```text
gpg> save
abdullah@E202SA:~$ 
```

Saya cek bahwa GnuPG benar sudah di perpanjang:

```text
abdullah@E202SA:~$ gpg --list-key abdullah@muntaza.id
pub   rsa3072 2020-08-16 [SC] [expires: 2026-12-12]
      55FB01545D893727472E1828E8CCFF0EXXXXXXXX
uid           [ultimate] Abdullah <abdullah@muntaza.id>
sub   rsa3072 2020-08-16 [E] [expires: 2026-12-12]
```


Demikian proses perpanjangan masa aktif GnuPG Key, semoga bermanfaat.

# Alhamdulillah
