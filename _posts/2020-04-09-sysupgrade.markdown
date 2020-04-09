---
layout: post
title:  "OpenBSD: sysupgrade"
date:   2020-04-09 12:26:56 +0800
categories: openbsd
---

# Bismillah,

Alhamdulillah, saya berkesempatan menuliskan pengalaman saya menggunakan
[sysupgrade](https://man.openbsd.org/sysupgrade) yang merupakan program
yang berfungsi untuk melakan upgrade system OpenBSD. Pada contoh ini,
saya menggunakan versi snapshot, sehingga upgrade nya ke snapshot
terbaru.

```text
muntaza@E202SA:~$ ssh bphtb.paringin.com
Last login: Wed Apr  8 21:23:07 2020 from 182.1.181.75
OpenBSD 6.7-beta (GENERIC) #110: Tue Apr  7 19:32:36 MDT 2020

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

```

Login ssh ke mesin saya.

```text
bphtb$ doas su
doas (muntaza@bphtb.paringin.com) password:
```

Menjadi Super User (root).

```text
bphtb# sysupgrade
Fetching from https://cloudflare.cdn.openbsd.org/pub/OpenBSD/snapshots/amd64/
SHA256.sig   100% |*************************************|  2141       00:00
Signature Verified
INSTALL.amd64 100% |************************************| 43512       00:00
base67.tgz   100% |*************************************|   238 MB    00:29
bsd          100% |*************************************| 18098 KB    00:02
bsd.mp       100% |***************************************| 18178 KB    00:02
bsd.rd       100% |***************************************| 10100 KB    00:01
comp67.tgz   100% |***************************************| 74421 KB    00:08
game67.tgz   100% |***************************************|  2745 KB    00:01
man67.tgz    100% |***************************************|  7454 KB    00:01
xbase67.tgz  100% |***************************************| 22912 KB    00:03
xfont67.tgz  100% |***************************************| 39342 KB    00:04
xserv67.tgz  100% |***************************************| 16766 KB    00:02
xshare67.tgz 100% |***************************************|  4499 KB    00:00
Verifying sets.
Fetching updated firmware.
Upgrading.
Connection to bphtb.paringin.com closed by remote host.
Connection to bphtb.paringin.com closed.
```

Menjalankan perintah sysupgrade. Sebagaimana terlihat, sysupgrade ini mendownload
fileset (file instalasi), kemudian langsung reboot dan menjalankan proses upgrade.
Proses download ini bervariasi lamanya, tergantung speed bandwith mesin kita.

```text
muntaza@E202SA:~$ ssh bphtb.paringin.com
Last login: Thu Apr  9 08:40:49 2020 from 182.1.196.174
OpenBSD 6.7-beta (GENERIC) #111: Wed Apr  8 10:35:45 MDT 2020

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

bphtb$
```

Setelah sekitar -+ 15 menit proses upgrade berjalan, saya coba ssh dan
berhasil kembali login. terlihat di sini bahwa system sudah upgrade dari
seri 110 ke seri 111.

```text
bphtb$ doas su
doas (muntaza@bphtb.paringin.com) password:
bphtb# sysupgrade
Fetching from https://cloudflare.cdn.openbsd.org/pub/OpenBSD/snapshots/amd64/
SHA256.sig   100% |****************************************|  2141       00:00
Signature Verified
Already on latest snapshot.
bphtb#
bphtb# exit
```

Disini saya coba lagi jalankan sysupgrade, dan ternyata ada pesan bahwa kita
sudah berada di versi snapshot terbaru.

```text
bphtb$ date
Thu Apr  9 08:43:17 WITA 2020
```

Tanggal hari saat proses upgrade ini. Semoga tulisan ini bermanfaat, terutama
bagi yang baru mengenal OpenBSD, bahwa OpenBSD ini sangat user friendly, sangat
mudah di gunakan, proses upgrade nya pun mudah pula.



# Alhamdulillah
