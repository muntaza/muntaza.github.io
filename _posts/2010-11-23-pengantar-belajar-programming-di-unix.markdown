---
author: muntaza
comments: true
date: 2010-11-23 00:49:32+00:00
layout: post
link: https://muntaza.wordpress.com/2010/11/23/pengantar-belajar-programming-di-unix/
slug: pengantar-belajar-programming-di-unix
title: Pengantar Belajar Programming di Unix
wordpress_id: 194
categories:
- linux
- OpenBSD
---

$Id: Belajar_programming,v 1.3 2010/11/22 11:33:44 muntaza Exp $

Tulisan ini adalah pengatar belajar programming, untuk selanjutnya silakan menuju ke links yang disebutkan dibawah ini untuk masing-masing programming lenguage:

1. Assembly
Program ini dalam bahasa aseembly, untuk menampilkan kata "pertama"

kalimat:
.ascii    "pertama\n"

ujung_kalimat:
.equ panjang_kalimat, ujung_kalimat - kalimat

.text
.globl _start
_start:
movl    $4, %eax
movl    $1, %ebx
movl    $kalimat, %ecx
movl    $panjang_kalimat, %edx
int    $0x80

movl    $1, %eax
movl    $0, %ebx
int    $0x80

semua links tanggal 25 Mei 2010

-----assembly:
http://savannah.nongnu.org/projects/pgubook/
http://www.drpaulcarter.com/pcasm/index.php

------C:
http://www.iu.hio.no/~mark/CTutorial/CTutorial.html
http://www.eskimo.com/~scs/cclass/cclass.html

------C++:
http://www.steveheller.com/cppad/Output/dialogTOC.html

------python:
http://en.wikibooks.org/wiki/Non-Programmer%27s_Tutorial_for_Python_2.6
http://upload.wikimedia.org/wikibooks/en/6/69/Non-Programmer%27s_Tutorial_for_Python_2.6.pdf
http://docs.python.org/archives/python-2.6.5-docs-pdf-letter.zip

-------bash:
http://www.tldp.org/guides.html
http://www.tldp.org/LDP/Bash-Beginners-Guide/Bash-Beginners-Guide.pdf
http://www.tldp.org/LDP/abs/abs-guide.pdf

-------perl:
http://www.greglondon.com/iperl/index.htm
http://www.greglondon.com/iperl/pdf/iperl.pdf

http://www.ebb.org/PickingUpPerl/
http://www.ebb.org/PickingUpPerl/pickingUpPerl.pdf

-------ruby:
http://www.rubyist.net/~slagell/ruby/index.html

-------selanjutnya:
http://www.google.co.id
