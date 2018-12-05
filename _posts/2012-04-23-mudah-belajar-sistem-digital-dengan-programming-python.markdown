---
author: muntaza
comments: true
date: 2012-04-23 07:33:17+00:00
layout: post
link: https://muntaza.wordpress.com/2012/04/23/mudah-belajar-sistem-digital-dengan-programming-python/
slug: mudah-belajar-sistem-digital-dengan-programming-python
title: Mudah Belajar Sistem Digital dengan Programming Python
wordpress_id: 374
categories:
- kisah muhammad muntaza
- programming
- Python
- Windows XP
---

Bismillah,

Dibawah ini adalah Pengoperasian Operator Logika dengan Bahasa Python. Berikut daftar Operator Logika pada Python:
AND   --> &
OR    --> |
XOR   --> ^
NOT   --> not

Contoh Pengoperasian:
A AND B    -->  A & B
A OR B     -->  A | B
A XOR B    -->  A ^ B
NOT A      --> not A

Dibawah ini contoh source kode python:
1. sd1.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| A.B");
print ("=================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		print (A, " \t|", B, "  \t| ", A & B);
[/sourcecode]

1. sd2.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| - A \t\t | - B");
print ("=================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		print (A, " \t|", B, " \t| ", not A, "  \t | ", not B);
[/sourcecode]

3. sd3.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| - A \t\t | - B \t\t| -A + -B");
print ("=================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		print (A, " \t|", B, " \t| ", not A, "  \t | ", not B, "\t| ", (not A) | (not B));
[/sourcecode]

4. sd4.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| -(-A + -B)");
print ("=================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		print (A, " \t|", B, "  \t| ", not ((not A) | (not B)));
[/sourcecode]

screnshoot program setelah dijalankan:
[![](http://muntaza.files.wordpress.com/2012/04/python.jpg)](http://muntaza.files.wordpress.com/2012/04/python.jpg)

5. sd5.py:

[sourcecode languange="python" wraplines="false"]

#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| A XOR B");
print ("=================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		print (A, " \t|", B, "  \t| ", A ^ B);
[/sourcecode]

6. sd6.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| C \t\t|\t (A XOR B) XOR C ");
print ("=================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		for k in range(2):
			if k == 0:
				C = False
			else:
				C = True
			print (A, " \t|", B, "  \t| ", C, "   \t |"
			, (A ^ B) ^ C);
[/sourcecode]

7. sd7.py:

[sourcecode languange="python" wraplines="false"]
#!c:/Python32/python.exe

# Copyright 2012 @ Muhammad Muntaza bin Hatta
# Lisensi: GPL v3                             
# Program dengan Operator LOGIKA
# web: muntaza.wordpress.com                  
# email: muntaza@binhatta.com                 

print ("A  \t| B  \t\t| C  \t\t|\t  D \t | (A & B) & (C & D) ");
print ("====================================================================");

for i in range(2):
	if i == 0:
		A = False
	else:
		A = True
	for j in range(2):
		if j == 0:
			B = False
		else:
			B = True
		for k in range(2):
			if k == 0:
				C = False
			else:
				C = True
			for l in range(2):
				if l == 0:
					D = False
				else:
					D = True
				print (A, " \t|", B, "  \t| ", C, "   \t |"
				, D, "   \t| ", (A & B) & (C & D));
[/sourcecode]

Screenshoot dari program diatas:

[![](http://muntaza.files.wordpress.com/2012/04/python2.jpg)](http://muntaza.files.wordpress.com/2012/04/python2.jpg)

Dari Contoh-contoh diatas, terlihat betapa mudahnya pengoperasian LOGIKA dengan Python. Namun harus diperhatikan urutan Operasinya dengan menggunakan tanda kurung, Misalnya:

(A AND B) OR (C XOR (NOT D))

Urutan Operasinya adalah:
1. A di AND kan dengan B (A AND B)
2. D di NOT kan (NOT D)
3. (NOT D) di XOR kan dengan C
4. (A AND B) di OR kan dengan (C XOR (NOT D))

Bila diterjemahkan kedalam Python menjadi:
(A & B) | (C ^ (not D))

Semoga Tulisan ini bermanfaat

Walhamdulillah. Semoga Allah Rabbuna Jalla Wa ‘Ala Memudahkan saya untuk tinggal di Banjarbaru

ditulis oleh: Al faqir ilaa maghfirati rabbihi Abu Husnul Khatimah Muhammad Muntaza bin Hatta
