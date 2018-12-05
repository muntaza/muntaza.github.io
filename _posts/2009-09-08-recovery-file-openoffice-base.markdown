---
author: muntaza
comments: true
date: 2009-09-08 03:19:49+00:00
layout: post
link: https://muntaza.wordpress.com/2009/09/08/recovery-file-openoffice-base/
slug: recovery-file-openoffice-base
title: Recovery File OpenOffice Base
wordpress_id: 107
categories:
- linux
---

ini adalah catatan mengenai pengalaman saya, mengalami kerusakan pada file openoffice base, disebut odb. file tersebut dibuat dengan OO 3.0 dan tidak bisa dibuka. berikut pemecahan masalah saya:

[sourcecode lenguage="bash"]
muntaza@pisang:~/recover$ ls
contoh.odb*
muntaza@pisang:~/recover$ du -h contoh.odb
1.1M    contoh.odb
muntaza@pisang:~/recover$ cp contoh.odb contoh_back_up.odb
muntaza@pisang:~/recover$ ls
contoh.odb*  contoh_back_up.odb*
muntaza@pisang:~/recover$ mv contoh.odb contoh.zip
muntaza@pisang:~/recover$ unzip contoh.zip
Archive:  contoh.zip
End-of-central-directory signature not found.  Either this file is not a zipfile, or it constitutes one disk of a multi-part archive.  In the latter case the central directory and zipfile comment will be found on the last disk(s) of this archive.
note:  contoh.zip may be a plain executable, not an archive 
unzip:  cannot find zipfile directory in one of contoh.zip or contoh.zip.zip, and cannot find contoh.zip.ZIP, period.

muntaza@pisang:~/recover$

muntaza@pisang:~/recover$ zip -FF contoh.zip > /dev/null
muntaza@pisang:~/recover$ ls
contoh.zip*  contoh_back_up.odb*
muntaza@pisang:~/recover$ mv contoh.zip contoh.odb
muntaza@pisang:~/recover$ du -h contoh.odb
700K    contoh.odb
muntaza@pisang:~/recover$
[/sourcecode]

penjelasan:
1. file ini rusak, ukurannya 1.1MB, back_up dulu file ini
2. rubah nama file dari .odb menjadi .zip
3. tes unzip file contoh.zip, ternyata error (pertanda file zip ini rusak)
4. perbaiki file zip dengan perintah "zip -FF nama_file.zip"
5. kembalikan .zip ke .odb

Penutup:
pada kejadian yang saya alami, bisa memperoleh file odb yang rusak tadi menjadi baik, dan pastinya tidak semua file .odb bisa diperbaiki dengan cara diatas. Alhamdulillah.
