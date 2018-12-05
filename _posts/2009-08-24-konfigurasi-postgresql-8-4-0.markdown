---
author: muntaza
comments: true
date: 2009-08-24 01:26:37+00:00
layout: post
link: https://muntaza.wordpress.com/2009/08/24/konfigurasi-postgresql-8-4-0/
slug: konfigurasi-postgresql-8-4-0
title: Konfigurasi PostgreSQL 8.4.0
wordpress_id: 93
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

setelah selesai compile, saya lakukan langkah konfigurasi sbb:

[sourcecode languange="bash" wraplines="false"]
muntaza@pisang:~/Download/postgresql-8.4.0$ sudo gmake install 
muntaza@pisang:~/Download/postgresql-8.4.0$ sudo su
root@pisang:/home/muntaza/Download/postgresql-8.4.0# cd
root@pisang:~# useradd -u 130 -d /usr/local/pgsql postgres
root@pisang:~# passwd postgres
Changing password for postgres
Enter the new password (minimum of 5, maximum of 127 characters)
Please use a combination of upper and lower case letters and numbers.
New password:
Re-enter new password:
Password changed.
root@pisang:~#

root@pisang:~# cd /usr/local/pgsql/
root@pisang:/usr/local/pgsql# ls
bin  include  lib  share
root@pisang:/usr/local/pgsql# mkdir data
root@pisang:/usr/local/pgsql# chown -R postgres data

root@pisang:/usr/local/pgsql# su postgres
postgres@pisang:~$ pwd
/usr/local/pgsql

postgres@pisang:~$ /usr/local/pgsql/bin/initdb -A md5 -D /usr/local/pgsql/data -W
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.
............
............
Enter new superuser password:
Enter it again:
setting password ... ok
............
............
Success. You can now start the database server using:

/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
or
/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start

postgres@pisang:~$
postgres@pisang:~$ cd data/
postgres@pisang:~/data$ /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start
server starting

postgres@pisang:~/data$ /usr/local/pgsql/bin/createuser -P -E durian
Enter password for new role:
Enter it again:
Shall the new role be a superuser? (y/n) n
Shall the new role be allowed to create databases? (y/n) n
Shall the new role be allowed to create more new roles? (y/n) n
Password:        #password superuser
postgres@pisang:~/data$

postgres@pisang:~/data$ /usr/local/pgsql/bin/createdb --owner=durian percobaan
Password:        #password superuser

postgres@pisang:~/data$ exit
exit
root@pisang:/usr/local/pgsql# exit
exit
muntaza@pisang:~/Download/postgresql-8.4.0$ cd
muntaza@pisang:~$ /usr/local/pgsql/bin/psql -U durian percobaan
Password for user durian:
psql: FATAL:  password authentication failed for user "durian"       #bila password user durian salah he..he..

muntaza@pisang:~$ /usr/local/pgsql/bin/psql -U durian percobaan
Password for user durian:
psql (8.4.0)
Type "help" for help.

percobaan=>
[/sourcecode]

Catatan:
1. install program yang telah di compile
2. buat user postgres (sebagai superuser server nantinya)
3. buat direktori data pada /usr/local/pgsql dan dimiliki oleh user postgres
4. lakulan initdb pada direktori data (disini bisa dengan tambahan option -A md5 dan -W)
5. start server
6. buat role (user database) baru untuk penggunaan biasa
7. buat database contoh
8. connect ke database (dengan user database durian pada contoh ini)

Wallahu Ta'ala A'lam


**DAFTAR PUSTAKA**







	
  1. 


Suharto, 	B. Herry dan Soesilo Wijono. 2004. _Membangun 	Aplikasi Menggunakan Qt Designer dengan Database PostgreSQL/MySQL_. 	Yogyakarta: C.V Andi Offset




	
  2. 


Utami, 	Ema dan dan Suwanto Raharjo. 2006. _RDBMS dengan PostgreSQL di 	GNU/Linux_. Yogyakarta: C.V Andi 	Offset






