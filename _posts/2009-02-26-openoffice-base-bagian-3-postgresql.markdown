---
author: muntaza
comments: true
date: 2009-02-26 01:05:54+00:00
layout: post
link: https://muntaza.wordpress.com/2009/02/26/openoffice-base-bagian-3-postgresql/
slug: openoffice-base-bagian-3-postgresql
title: 'OpenOffice Base Bagian 3: PostgreSQL'
wordpress_id: 71
categories:
- kisah muhammad muntaza
---










Ditulis oleh Muhammad Muntaza bin Hatta bin Ahmad bin Daman.





-






Tulisan ini catatan pribadi saya mengenai Pengelolaan Relasional Database, dalam hal ini menggunakan PostgreSQL (aka postgres), dan OpenOffice Base (aka base) sebagai front end nya. Pemilihan saya pribadi terhadap postgreSQL karena lisensinya, yaitu lisensi BSD yang menjadikan postgreSQL bisa digunakan untuk kepentingan komersial. Beda halnya dengan MySQL, yang hanya bisa digunakan untuk kepentingan non komersial, bila mau menggunakan untuk komersial, harus membeli lisensinya (software asli) yang harganya cukup mahal.





-






latihan saya ini dilakukan pada Mandriva Free 2009.0, menggunakan PostgreSQL 8.3.4, dan OpenOffice 3.0.0, dan Driver postgresql-sdbc-0.7.6.zip dari links  [http://dba.openoffice.org/drivers/postgresql/index.html](http://dba.openoffice.org/drivers/postgresql/index.html) , tulisan ini bertujuan, agar bila suatu hari saya lupa, saya bisa cek ke blog ini untuk dibaca ulang.





-






Kenapa tulisan ini adalah bagian 3, padahal saya belum menulis bagian 1 dan 2, karena saya berencana menulis bagian 1, 2 dan 4 dengan judul sebagai berikut:





-






OpenOffice Base




Bagian 1: Pengantar Database




Insya Allah berisi latihan pembuatan database untuk yang belum pernah menggunakan database, berupa pembuatan tabel, form, query, dengan OpenOffice Base murni (dengan GUI), penginputan pada tabel, penginputan pada form, dan tampilan query.





-






OpenOffice Base




Bagian 2: Relasional Database dan Report




Insya Allah berisi latihan relasional sederhana, query dengan relasional, dan pembuatan report yang baik.







-




OpenOffice Base




Bagian 4: Bahasa SQL




Insya Allah berisi latihan Bahasa SQL sederhana.







Pada awalnya tulisan ini tanpa gambar, tapi karena sulit menjelaskannya, saya masukkan beberapa gambar, agar lebih mudah memahaminya. Adapun bagi pengguna browser tanpa gambar seperti Lynx, tetap dapat mengikuti tulisan ini karena saya berusaha agar tulisan ini tidak tergantung gambar





-






1. Menjalankan PostgreSQL




Install PostgreSQL bila belum terinstall.




Jalankan PostgreSQL server dari "drakconf", pilih "System", pilih "Manage System Services by enabling or disabling them", cari postgresql, contreng "on boot", lalu klik "start".













periksa apakah server sudah jalan dengan perintah:




bash-3.2$ ps ax | grep postgres







2856 ? Ss 0:00 postgres: writer process




2857 ? Ss 0:00 postgres: wal writer process




2858 ? Ss 0:00 postgres: autovacuum launcher process




2859 ? Ss 0:00 postgres: stats collector process




10345 pts/2 R+ 0:00 grep postgres




bash-3.2$




Tampilan diatas menunjukan postgres sudah jalan





-



2. Membuat user untuk menggunakan database




bash-3.2$ su




Password:




[root@localhost muntaza]# su postgres




[postgres@localhost muntaza]$ cd




[postgres@localhost ~]$ createuser -D -R -S -E -P pisang




Enter password for new role:




Enter it again:




[postgres@localhost ~]$







perintah diatas pertama menjadi root, dari root menjadi user postgres, dari user postgres ini membuat "user database" bernama "pisang". catat passwordnya.





-






3. Membuat database bernama "latihan".




[postgres@localhost ~]$ id




uid=74(postgres) gid=74(postgres) groups=74(postgres)




[postgres@localhost ~]$ createdb latihan




[postgres@localhost ~]$





-






4. Membuat tabel "Buku" dan "Penerbit" di database "latihan".







[postgres@localhost ~]$ exit




[root@localhost muntaza]# exit




bash-3.2$ id




uid=500(muntaza) gid=500(muntaza) groups=500(muntaza)




bash-3.2$ psql -U pisang -d latihan




Welcome to psql 8.3.4, the PostgreSQL interactive terminal.







Type: \copyright for distribution terms




\h for help with SQL commands




\? for help with psql commands




\g or terminate with semicolon to execute query




\q to quit







latihan=>







perintah "psql -U pisang -d latihan" digunakan untuk masuk ke prompt server




postgresql










latihan=> CREATE TABLE "Penerbit" (




latihan(> "IDPenerbit" serial PRIMARY KEY,




latihan(> "Penerbit" varchar(80),




latihan(> "Kota" varchar(80)




latihan(> );




NOTICE: CREATE TABLE will create implicit sequence "Penerbit_IDPenerbit_seq" for serial column "Penerbit.IDPenerbit"




NOTICE: CREATE TABLE / PRIMARY KEY will create implicit index "Penerbit_pkey" for table "Penerbit"




CREATE TABLE




latihan=>







perintah diatas untuk membuat table "Penerbit"





-






latihan=> CREATE TABLE "Buku" (




"IDBuku" Serial PRIMARY KEY,




"Judul" varchar(80),




"IDPenerbit" integer REFERENCES "Penerbit" ("IDPenerbit")




ON UPDATE CASCADE ON DELETE NO ACTION




);




NOTICE: CREATE TABLE will create implicit sequence "Buku_IDBuku_seq" for serial column "Buku.IDBuku"




NOTICE: CREATE TABLE / PRIMARY KEY will create implicit index "Buku_pkey" for table "Buku"




CREATE TABLE




latihan=>





-






perintah diatas membuat table "Buku" dengan relasional ke "Penerbit", gambarannya sebagai berikut










"Buku"




IDBuku (PK)




Judul "Penerbit"




IDPenerbit (FK)<-----------IDPenerbit (PK)




Penerbit




Kota







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-2.png)







-




5. Memasukkan Driver postgresql-sdbc-0.7.6.zip




Download Driver postgresql-sdbc-0.7.6.zip dari links diatas, jalankan OpenOffice, klik Tools, pilih "Extension Manager", pilih add, cari file postgresql-sdbc-0.7.6.zip yang didownload tadi, pilih, lalu Restart OpenOffice.







-




6. Masuk Ke OpenOffice Base




Jalankan OpenOffice Base,




pilih "Connect to an existing database"




pilih "postgresql", klik "next >>"




Pada connection settings masukkan "dbname=latihan host=localhost", klik "next >>"




Pada Set up user authentication masukkan user name "pisang", contreng "password required", klik "test connection", masukkan password waktu membuat user di langkah nomor 2 diatas. Bila berhasil akan ada tulisan "The connection was established successfully."




Klik "next >>"




Klik "Finish", simpan file .odb pada tempat yang dipilih, beri nama "latihan" sesuai dengan nama databasenya.





-
























7. Menghilangkan scema yang tidak penting




klik Tools, pilih "Table filter", hilangkan contreng pada information_schema dan pg_catalog, klik OK, klik save. restart OpenOffice





-






8. Membuat Form Penerbit




untuk membuat form penerbit, pilih Forms, pilih "Use Wizard to Create Form..." pilih table: public.Penerbit. masukkan "Penerbit" dan "Kota" dari sisi kiri ke sisi kanan, klik "Next >>"







menu add subform klik "Next >>",




menu arrange controls, pilih Columnar, sisi paling kiri, klik "Next >>",




menu set data entry klik "Next >>",




menu apply style klik "Next >>",




menu set name, beri nama "Form Penerbit", pilih radio button "Work with the form", klik FINISH





-












9. Memasukkan data Pada Form Penerbit




masukkan data ini




1. Penerbit = Berjuang, Kota = Banjarmasin




2. Penerbit = Berlatih, Kota = Paringin




tutup form Penerbit.





-









10. Membuat form Buku, sama seperti diatas, pilih Table: public.Buku, masukkan “Judul” dan “IDPenerbit”,  klik "Next >>",







menu add subform klik "Next >>",




menu arrange controls, pilih Columnar, sisi paling kiri, klik "Next >>",




menu set data entry klik "Next >>",




menu apply style klik "Next >>",




menu set name, beri nama "Form Buku", pilih radio button "Work with the form", klik FINISH







Keluar dari form, tekan save pada Jendela utama







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-9.png)




Pada tampilan diatas tampak bahwa kita memasukkan Buku.IDPenerbit Berupa angka agar sesuai dengan nilai pada tabel Penerbit.IDPenerbit, bila memasukkan nilai yang tidak ada maka akan error, (dalam rangka menjaga integritas data).







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-10.png)




Agar mempermudah, maka akan dibuat list box yang menampilkan nama Penerbit, tapi nilai yang dimasukkan adalah IDPenerbit.




Ganti lblIDPenerbit menjadi Penerbit, CTRL+klik pada “IDPenerbit”, klik kanan, pilih Control, pada General, Ganti Label dari “IDPenerbit” menjadi “Penerbit”, tutup Properties, tekan ESC, tekan save.







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-11.png)




CRTL+klik pada kolom isian Penerbit, tekan delete. Lalu klik icon list box disisi kiri.







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-12.png)




Lalu buat kolom list box didepan Penerbit, pilih “public.Penerbit”, klik “Next >>”, pilih Penerbit, klik “Next >>”, pilih IDPenerbit pada dua sisi untuk memasukkan nilainya, klik Finish







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-13.png)







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-14.png)







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-15.png)




CTRL+klik pada kolom list box, klik kanan, klik Control pada Properties list box, ganti name menjadi Penerbit, Label Field klik <...>, pilih Penerbit. Tekan save. Keluar dari edit form.





-






Test memasukkan data, Judul = Pendidikan Matematika, Penerbit = Berlatih, dengan memanfaatkan list box, sudah bisa langsung dipilih Penerbitnya.







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-16.png)










11. membuat query




pilih Queries, pilih Create Query in SQL view, klik logo [SQL] (paling kanan), tuliskan perintah dibawah ini:







SELECT "Buku"."Judul", "Penerbit"."Penerbit", "Penerbit"."Kota"




FROM "public"."Buku" AS "Buku", "public"."Penerbit" AS "Penerbit"




WHERE "Buku"."IDPenerbit" = "Penerbit"."IDPenerbit"







tekan save, beri nama “Query_Buku”. Tutup jendela query, save pada Jendela Utama.







Untuk melihat hasil Query, klik “ Query_Buku” pada Kolom Queries.







![](http://muntaza.files.wordpress.com/2009/02/sbres-1235609431-17.png)







---------




PENUTUP




Sampai disini dulu, semoga bermanfaat untuk saya pribadi khususnya, ikhwah fillah salafiyyun dimana saja berada barakallahu fiikum, Pemerintah Indonesia, dan kaum muslimin pada umumnya yang ingin menggunakan software Open Source. Wallahu a'lam.






















"DAFTAR PUSTAKA"








[http://documentation.openoffice.org/manuals/oooauthors2/0110GS-GettingStartedWithBase.pdf
](http://documentation.openoffice.org/manuals/oooauthors2/0110GS-GettingStartedWithBase.pdf)





[http://dba.openoffice.org/drivers/postgresql/index.html](http://dba.openoffice.org/drivers/postgresql/index.html) tanggal 25 Pebruari 2009







[http://en.wikipedia.org/wiki/Openoffice_base](http://en.wikipedia.org/wiki/Openoffice_base) tanggal 25 Pebruari 2009










Rusmanto dan Muhammad Hanif. 2004. _Membangun Database Berbasis OpenOffice dan MySQL_. Jakarta: Dian Rakyat







Suharto, B. Herry dan Soesilo Wijono. 2004. _Membangun Aplikasi Menggunakan Qt Designer dengan Database PostgreSQL/MySQL_. Yogyakarta: C.V Andi Offset







Sinarmata, Janner. 2007. _Perancangan Basis Data_. Yogyakarta: C.V Andi Offset




