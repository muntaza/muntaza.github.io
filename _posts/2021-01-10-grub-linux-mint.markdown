---
layout: post
title:  "Grub2 Recovery"
date:   2021-01-10 09:14:56 +0800
categories: linux
---

# Bismillah,

Ini adalah catatan setting Grub2 yang saya gunakan untuk booting ke mesin Linux Mint saya.
Setting ini, pernah saya gunakan saat Grub2 saya mengalami error, sehingga perlu melakukan
edit manual pada command line Grub2 untuk recovery, agar bisa booting.

```text
menuentry 'Linux Mint' {
	set root=(hd0,gpt7)
	insmod gzio
	insmod part_msdos
	insmod btrfs
	insmod normal

	linux /boot/vmlinuz-5.4.0-60-generic root=/dev/sda7
	initrd /boot/initrd.img-5.4.0-60-generic

	boot
}
```

Saat terjadi gagal booting, masuk ke command line grub2, lakukan langkah berikut secara
berurutan:

- setting posisi partisi dengan perintah _set root_ 
- aktifkan modul-modul yang diperlukan, dengan perintah _insmod_
- pilih kernel, jangan lupa setting _root=/posisi/partisi_
- pilih miniroot image
- ctrl-x untuk booting

Semoga bermanfaat. Aamiin

# Alhamdulillah
