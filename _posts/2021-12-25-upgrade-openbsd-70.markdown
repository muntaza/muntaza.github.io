---
layout: post
title:  "Upgrade OpenBSD 7.0 dengan sysupgrade"
date:   2021-12-25 1:26:56 +0800
categories: openbsd
---

# Bismillah,

Alhamdulillah, saya berkesempatan menuliskan catatan tentang upgrade OpenBSD 7.0 
pada mesin gateway yang saat ini masih saya kelola.

Baik, pertama login dan tampilkan versi OpenBSD saat ini.


```text
Last login: Tue Dec 21 06:42:10 2021 from 114.122.228.47
OpenBSD 6.9 (GENERIC.MP) #4: Tue Aug 10 08:12:23 MDT 2021

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

gateway$ uname -a                                                   
OpenBSD gateway.muntaza.id 6.9 GENERIC.MP#4 amd64
gateway$ 
```

Cek setting mirror saat ini:

```text
gateway$ cat /etc/installurl                                                      
https://mirror.labkom.id/pub/OpenBSD
```

Jalankan sysupgrade


```text
gateway$ doas sysupgrade                   
Fetching from https://mirror.labkom.id/pub/OpenBSD/7.0/amd64/
SHA256.sig   100% |************************************************|  2144       00:00    
Signature Verified
Verifying old sets.
base70.tgz    47% |************************************************|   302 MB    01:28    
bsd          100% |************************************************| 21090 KB    00:08    
bsd.mp       100% |************************************************| 21181 KB    00:07    
bsd.rd       100% |************************************************|  4109 KB    00:03    
comp70.tgz   100% |************************************************| 73002 KB    00:22    
game70.tgz   100% |************************************************|  2743 KB    00:02    
man70.tgz    100% |************************************************|  7580 KB    00:13    
xbase70.tgz  100% |************************************************| 54408 KB    00:16    
xfont70.tgz  100% |************************************************| 22965 KB    00:08    
xserv70.tgz  100% |************************************************| 19659 KB    00:08    
xshare70.tgz 100% |************************************************|  4494 KB    00:03    
Verifying sets.
Upgrading.
Connection to aset.muntaza.id closed by remote host.
Connection to aset.muntaza.id closed.
```

Perhatikan, gunakan mirror terdekat agar proses download lebih cepat. File SHA256.sig di verifikasi dengan public key yang ada di bsd.rd. Kemudian, file set lainnya di verifikasi dengan SHA256.sig

Setelah semua file terdownload, mesin melakukan reboot dan melakukan proses upgrade tanpa perintah (otomatis).

Setelah selesai upgrade, saya coba login dan cek versi sekarang.



```text
Last login: Tue Dec 21 06:57:04 2021 from 114.122.228.47
OpenBSD 7.0 (GENERIC.MP) #232: Thu Sep 30 14:25:29 MDT 2021

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

gateway$ 
gateway$ uname -a                                                                                
OpenBSD gateway.muntaza.id 7.0 GENERIC.MP#232 amd64
```

Untuk update konfigurasi, saya jalankan sysmerge, file akan saya review diff nya, kalau
ternyata aman untuk di delete, saya delete file baru dengan perintah 'd', sehingga config
tetap file lama.

```text
gateway$ doas sysmerge 

  Use 'd' to delete the temporary ./etc/ssh/sshd_config
  Use 'i' to install the temporary ./etc/ssh/sshd_config
  Use 'm' to merge the temporary and installed versions
  Use 'v' to view the diff results again

  Default is to leave the temporary file to deal with by hand

How should I deal with this? [Leave it for later] d

===> Deleting ./etc/ssh/sshd_config

delete file sementara
```

Tidak lupa dengan syspatch,

```text
gateway$ doas syspatch        
Get/Verify syspatch70-001_nsd.tgz 100% |**************************|   760 KB    00:01    
Installing patch 001_nsd
Get/Verify syspatch70-002_bpf.tgz 100% |**************************|   106 KB    00:00    
Installing patch 002_bpf
Get/Verify syspatch70-003_uipc.tgz 100% |*************************| 91867       00:00    
Installing patch 003_uipc
Get/Verify syspatch70-004_rpki.tgz 100% |*************************|   168 KB    00:00    
Installing patch 004_rpki
Get/Verify syspatch70-005_unpcon.tgz 100% |***********************| 91953       00:00    
Installing patch 005_unpcon
Get/Verify syspatch70-006_x509.tgz 100% |*************************| 17614 KB    00:09    
Installing patch 006_x509
Get/Verify syspatch70-007_xserver... 100% |***********************|  4341 KB    00:04    
Installing patch 007_xserver
Get/Verify syspatch70-008_mrt.tgz 100% |**************************|   139 KB    00:00    
Installing patch 008_mrt
Relinking to create unique kernel... done; reboot to load the new kernel
Errata can be reviewed under /var/syspatch
gateway$ 
```


Tentunya, harus reboot setelah install patch kernel

```text
gateway$ doas reboot
doas (muntaza@gateway.muntaza.id) password: 
Connection to aset.muntaza.id closed by remote host.
Connection to aset.muntaza.id closed.
```

Login lagi dan verifikasi hasil instalasi syspatch


```text
OpenBSD 7.0 (GENERIC.MP) #3: Wed Dec 15 13:14:26 MST 2021

Welcome to OpenBSD: The proactively secure Unix-like operating system.

Please use the sendbug(1) utility to report bugs in the system.
Before reporting a bug, please try to reproduce it with the latest
version of the code.  With bug reports, please try to ensure that
enough information to reproduce the problem is enclosed, and if a
known fix for it exists, include that as well.

gateway$ syspatch -l                                                                               
001_nsd
002_bpf
003_uipc
004_rpki
005_unpcon
006_x509
007_xserver
008_mrt
gateway$ 
gateway$ uname -a                                                                                  
OpenBSD gateway.muntaza.id 7.0 GENERIC.MP#3 amd64
gateway$
```

Demikian dari saya, semoga bermanfaat bagi saya pribadi dan pengguna OpenBSD lainnya.


# Alhamdulillah
