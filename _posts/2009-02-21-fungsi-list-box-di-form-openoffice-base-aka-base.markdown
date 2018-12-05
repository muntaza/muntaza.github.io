---
author: muntaza
comments: true
date: 2009-02-21 08:37:29+00:00
layout: post
link: https://muntaza.wordpress.com/2009/02/21/fungsi-list-box-di-form-openoffice-base-aka-base/
slug: fungsi-list-box-di-form-openoffice-base-aka-base
title: Fungsi List box di form OpenOffice Base (aka Base)
wordpress_id: 47
categories:
- linux
---

List box

Catatan ini sangat penting bagi saya, karena Saya mengalami masalah pada pembuatan Relasional Database dengan Base, gambarannya sebagai berikut:

TableBuku:
IDBuku (PK)
JudulBuku
IDPenerbit (FK)

TablePenerbit:
IDPenerbit (PK)
Penerbit
Kota

saya membuat form Buku, lalu membuat list box IDPenerbit, yang berisi kode IDPenerbit untuk dipilih dan memasukkan nilai IDPenerbit ke TableBuku

ini suatu masalah serius, karena list box tadi menampilkan nilai IDPenerbit (misal 0,1,2) dan saya harus memprint out Table penerbit sebagai referensi untuk mengisi form Buku.

Saya ingin agar list box tadi menampilkan Nama Penerbit (yaitu field TablePenerbit.Penerbit) dengan tetap memasukan nilai TablePenerbit.IDPenerbit ke TableBuku.IDPenerbit

Alhamdulillah, saya menemukan solusinya, dari link ini:

http://www.oooforum.org/forum/viewtopic.phtml?t=25060&sid=99150a7d9236b58447a816dfdc99c46a

dari links diatas, solusinya sebagai berikut:

list box tadi, ganti “list content” dari:
"SELECT "IDPenerbit", "IDPenerbit" FROM "TablePenerbit""

menjadi:
"SELECT "Penerbit", "IDPenerbit" FROM "TablePenerbit""

cara ini hanya bekerja pada list box dan tidak pada combo box.

Query

Dibawah ini query yang saya gunakan menyatukan dua Table tadi:

SELECT "TableBuku"."JudulBuku", "TablePenerbit"."Penerbit", "TablePenerbit"."Kota" FROM "TableBuku", "TablePenerbit" WHERE "TableBuku"."IDPenerbit" = "TablePenerbit"."IDPenerbit"

selesai.

Muhammad Muntaza bin Hatta

catatan:
sebenarnya saya mau membuat tulisan mengenai Base ini dari dasar sampai lanjutan, tapi belum ada waktu yang cukup. Insya Allah dimasa yang akan datang akan saya usahakan untuk menulisnya, semoga Allah memudahkan.
