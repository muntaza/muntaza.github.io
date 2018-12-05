---
author: muntaza
comments: true
date: 2007-12-20 01:35:03+00:00
layout: post
link: https://muntaza.wordpress.com/2007/12/20/instal-mandriva-20080/
slug: instal-mandriva-20080
title: Instal Mandriva 2008.0
wordpress_id: 4
categories:
- linux
---

Hari (19/12/2007) ini dikantor saya, saya menginstalkan mandriva 2008.0 pada komputer
rekan kerja saya.

Cukup menakutkan juga menginstal linux, soalnya pada laptop teman saya itu
tersimpan data kerja selama ini yang menggunakan sistem operasi Microsoft
Windows (R). Khawatir sekali kalau instalasi gagal dan men-delete seluruh
data pada komputer teman saya ini.

Hanya ada satu partisi pada komputer tsb! dengan kapasitas 80 GB

Saya mulai menginstal mandriva 2008.0 dengan langkah sbb:
1. Meresize Partisi tunggal menjadi 4 Partisi
- partisi windows 56 G
- Ext 3 untuk "/" linux 15 G
- Linux swap 300 M
- sisanya 8 G lebih
2. Menginstal Mandriva 2008.0 dari dvd yang saya beli di www.gudanglinux.com
3. Mensetting boot loader agar bisa dual boot (win xp dan mandriva).

setelah proses instalasi selesai, saya test booting ke windows xp nya dulu,
soalnya untuk mencek apakah data yang ada apakah masih aman-aman aja.

O, ternyata bisa masih bila masuk win xp he..he..
dan login seperti biasanya, lalu cek file di My Document and ternyata
everything is fine.

berikutnya shutdwon win xp dan test masuk ke mandriva.
Cek-cek setting yang dilakukan di mandriva sbb:
1. mount partisi window
$su
#mkdir /mnt/c
#mount /dev/sda1 /mnt/c
2. test sound
#cd /mnt/c
#konqueror .

cari file mp3 lalu di mainkan, ternyata bunyi he..he..

setelah itu saya bilang teman saya kalau saya mau menginstalkan ntfs-3g
ke komputer nya, agar dapat read/write file "win xp -nya", tapi dilain hari aja.

sekian dulu. thanks

muhammad muntaza
