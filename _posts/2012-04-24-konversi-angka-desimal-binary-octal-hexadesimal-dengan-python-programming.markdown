---
author: muntaza
comments: true
date: 2012-04-24 03:50:37+00:00
layout: post
link: https://muntaza.wordpress.com/2012/04/24/konversi-angka-desimal-binary-octal-hexadesimal-dengan-python-programming/
slug: konversi-angka-desimal-binary-octal-hexadesimal-dengan-python-programming
title: Konversi Angka Desimal, Binary, Octal, Hexadesimal dengan Python Programming
wordpress_id: 390
categories:
- kisah muhammad muntaza
- programming
- Windows XP
tags:
- Python
---

Bismillah,

Dibawah ini adalah source kode dalam bahasa Python untuk Konversi Angka ke Desimal, Binary, Octal dan Hexadesimal.

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program konversi Angka
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("Program konversi Desimal, Binary, Octal, Hexadecimal")
print ("Angka Binary diawali 0b, Hexa diawali 0x, Oktal diawali 0o")
print ("Pilih [1] untuk Desimal ke Binary")
print ("Pilih [2] untuk Desimal ke Hexa")
print ("Pilih [3] untuk Desimal ke Octal")
print ("Pilih [4] untuk Binary ke Desimal")
print ("Pilih [5] untuk Binary ke Hexa")
print ("Pilih [6] untuk Binary ke Oktal")
print ("Pilih [7] untuk Hexa ke Binary")
print ("Pilih [8] untuk Hexa ke Desimal")
print ("Pilih [9] untuk Hexa ke Octal")
print ("Pilih [10] untuk octal ke Binary")
print ("Pilih [11] untuk octal ke Desimal")
print ("Pilih [12] untuk octal ke Hexa")

i = int(input("Masukkan pilihan anda: "))
if i == 1:
	x = int(input("masukkan angka Desimal: "))
	print (bin(x))
elif i == 2:
	x = int(input("masukkan angka Desimal: "))
	print (hex(x))
elif i == 3:
	x = int(input("masukkan angka Desimal: "))
	print (oct(x))
elif i == 4:
	x = int(input("masukkan angka Binary: "),2)
	print (x)
elif i == 5:
	x = int(input("masukkan angka Binary: "),2)
	print (hex(x))
elif i == 6:
	x = int(input("masukkan angka Binary: "),2)
	print (oct(x))
elif i == 7:
	x = int(input("masukkan angka Hexa: "),16)
	print (bin(x))
elif i == 8:
	x = int(input("masukkan angka Hexa: "),16)
	print (x)
elif i == 9:
	x = int(input("masukkan angka Hexa: "),16)
	print (oct(x))
elif i == 10:
	x = int(input("masukkan angka Octal: "),8)
	print (bin(x))
elif i == 11:
	x = int(input("masukkan angka Octal: "),8)
	print (x)
elif i == 12:
	x = int(input("masukkan angka Octal: "),8)
	print (hex(x))
else:
	print("Pilihan anda salah");
[/sourcecode]

Dibawah ini screenshoot saat menjalankan program konversi:

[![](http://muntaza.files.wordpress.com/2012/04/number.jpg)](http://muntaza.files.wordpress.com/2012/04/number.jpg)

Semoga Tulisan ini bermanfaat

Walhamdulillah. Semoga Allah Rabbuna Jalla Wa ‘Ala Memudahkan saya untuk tinggal di Banjarbaru

ditulis oleh: Al faqir ilaa maghfirati rabbihi Abu Husnul Khatimah Muhammad Muntaza bin Hatta
