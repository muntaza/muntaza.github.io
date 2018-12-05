---
author: muntaza
comments: true
date: 2011-04-28 07:19:35+00:00
layout: post
link: https://muntaza.wordpress.com/2011/04/28/membatasi-kecepatan-download-pada-wget/
slug: membatasi-kecepatan-download-pada-wget
title: Membatasi kecepatan download pada wget
wordpress_id: 256
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
- programming
tags:
- Linux
- Openbsd
- Wget
---

bismillah,

pada saat mendownload, bila kita ingin membatasi kecepatan pada level tertentu, gunakan option --limit-rate=xy. limit rate ini, nilai x adalah angka sedangankan y adalah k dan m (k adalah kiloBytes dan m adalah megaBytes).

sebuah contoh:
`wget -c --limit-rate=20k http://localhost/file.txt`

ini akan mendownload file.txt dengan kecepatan 20 kiloBytes per second (kBps)

cara ini sangat berguna bagi admin yang perlu mendownload paket untuk server tanpa menggangu aktifitas user yang sedang mengakses server tersebut, karena bila wget tidak dibatasi, ia akan memakan semua bandwith yang ada.

walhamdulillah.

catatan: Saya sangat ingin tinggal di kota Banjarbaru. Semoga Allah Subhanahu Wa Ta’ala  memudahkan saya untuk tinggal di Kota Banjarbaru.


sumber: 
`$man wget`
