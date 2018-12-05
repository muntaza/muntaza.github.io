---
author: muntaza
comments: true
date: 2010-04-22 03:02:53+00:00
layout: post
link: https://muntaza.wordpress.com/2010/04/22/bekerja-dengan-cvs/
slug: bekerja-dengan-cvs
title: Bekerja dengan CVS
wordpress_id: 178
categories:
- linux
- OpenBSD
---

[sourcecode lenguage="bash"]
#-----catatan bekerja dengan cvs ---------

# bukan tutorial, dibuat ringkas semoga bermanfaat. selanjutnya ketik info cvs.

# buat cvsroot dan $CVSROOT

bash-3.1$ mkdir cvsroot
bash-3.1$ export CVSROOT=/home/muntaza/cvsroot

bash-3.1$ cvs init
bash-3.1$ ls -R ~/cvsroot 
/home/muntaza/cvsroot:
CVSROOT

/home/muntaza/cvsroot/CVSROOT:
Emptydir	commitinfo    config,v	     editinfo	 loginfo    modules,v  rcsinfo	  taginfo,v  verifymsg,v
checkoutlist	commitinfo,v  cvswrappers    editinfo,v  loginfo,v  notify     rcsinfo,v  val-tags
checkoutlist,v	config	      cvswrappers,v  history	 modules    notify,v   taginfo	  verifymsg

/home/muntaza/cvsroot/CVSROOT/Emptydir:
bash-3.1$ 

# buat direktori kerja dan direktori awal

bash-3.1$ mkdir cvswork cvsco
bash-3.1$ mkdir cvsawal
bash-3.1$ cd cvsawal/

# import "file" dengan nama module "program"

bash-3.1$ echo "isi file" > file
bash-3.1$ cvs import -m "awal"  program file muntaza
N program/file

No conflicts created by this import

bash-3.1$ 

# bekerja dengan cvs di ~/cvswork

bash-3.1$ cd ~/cvswork/
bash-3.1$ cvs co program
cvs checkout: Updating program
U program/file
bash-3.1$ cd program/
bash-3.1$ echo "tambah baris" >> file 
bash-3.1$ cvs ci -m "tambah baris"
cvs commit: Examining .
Checking in file;
/home/muntaza/cvsroot/program/file,v  <--  file
new revision: 1.2; previous revision: 1.1
done
bash-3.1$ echo "tambah baris lagi" >> file 
bash-3.1$ cvs ci -m "tambah baris2"
cvs commit: Examining .
Checking in file;
/home/muntaza/cvsroot/program/file,v  <--  file
new revision: 1.3; previous revision: 1.2
done


# menggunakan cvs log
<<<<<<----------
log

bash-3.1$ cvs log file 

RCS file: /home/muntaza/cvsroot/program/file,v
Working file: file
head: 1.3
branch:
locks: strict
access list:
symbolic names:
	muntaza: 1.1.1.1
	file: 1.1.1
keyword substitution: kv
total revisions: 4;	selected revisions: 4
description:
----------------------------
revision 1.3
date: 2010/04/22 02:16:28;  author: muntaza;  state: Exp;  lines: +1 -0
tambah baris2
----------------------------
revision 1.2
date: 2010/04/22 02:16:08;  author: muntaza;  state: Exp;  lines: +1 -0
tambah baris
----------------------------
revision 1.1
date: 2010/04/22 02:14:34;  author: muntaza;  state: Exp;
branches:  1.1.1;
Initial revision
----------------------------
revision 1.1.1.1
date: 2010/04/22 02:14:34;  author: muntaza;  state: Exp;  lines: +0 -0
awal
=============================================================================
bash-3.1$ 

----->>>>>>>

# cek isi file

bash-3.1$ cat file 
isi file
tambah baris
tambah baris lagi
bash-3.1$ ls 
CVS  file
bash-3.1$ 

# check out file edisi lama di dir ~/cvsco

bash-3.1$ cd ~/cvsco/
bash-3.1$ cvs co -r 1.1 program
cvs checkout: Updating program
U program/file
bash-3.1$ cat program/file 
isi file
bash-3.1$ 



# Ditulis berdasar pengalaman pribadi, semoga ada manfaatnya.

[/sourcecode]
