---
layout: post
title:  "Pivot table PostgreSQL"
date:   2021-05-26 14:26:56 +0800
categories: sql
---

# Bismillah,

Pada tulisan kali ini, saya akan membahas tentang teknik membuat baris menjadi kolom pada PostgreSQL. Contoh ini bersumber dari sebuah jawaban pertanyaan pada group telegram PostgreSQL Indonesia di [sini](https://t.me/postgresql_id/22432).


1.    Buat table contoh:

      ```text
      latihan=# create table evaluation (
      student varchar(60),
      subject varchar(60),
      evaluation_result numeric);
      CREATE TABLE
      latihan=# \dt
                 List of relations
       Schema |    Name    | Type  |  Owner   
      --------+------------+-------+----------
       public | evaluation | table | postgres
      (3 rows)
      
      latihan=# \d evaluation 
                               Table "public.evaluation"
            Column       |         Type          | Collation | Nullable | Default 
      -------------------+-----------------------+-----------+----------+---------
       student           | character varying(60) |           |          | 
       subject           | character varying(60) |           |          | 
       evaluation_result | numeric               |           |          | 
      
      ```

2.    Masukkan data kedalam table evaluation:

      ```text
      latihan=# insert into evaluation values ('Ahmad', 'Matematika', 9);
      INSERT 0 1
      latihan=# insert into evaluation values ('Ahmad', 'Bahasa Indonesia', 7);
      INSERT 0 1
      latihan=# insert into evaluation values ('Ahmad', 'Bahasa Arab', 8);
      INSERT 0 1
      latihan=# insert into evaluation values ('Fauzan', 'Matematika', 6);
      INSERT 0 1
      latihan=# insert into evaluation values ('Fauzan', 'Bahasa Indonesia', 9);
      INSERT 0 1
      latihan=# insert into evaluation values ('Fauzan', 'Bahasa Arab', 8);
      INSERT 0 1
      ```
      
3.    Cek isi table evaluation:

      ```text
      latihan=# select * from evaluation ;
       student |     subject      | evaluation_result 
      ---------+------------------+-------------------
       Ahmad   | Matematika       |                 9
       Ahmad   | Bahasa Indonesia |                 7
       Ahmad   | Bahasa Arab      |                 8
       Fauzan  | Matematika       |                 6
       Fauzan  | Bahasa Indonesia |                 9
       Fauzan  | Bahasa Arab      |                 8
      (6 rows)
      ```

4.    Aktifkan ekstensi tablefunc:

      ```text
      latihan=# CREATE EXTENSION tablefunc;
      ```

5.   Gunakan fungsi crosstab untuk menghasilkan table yang kita rencanakan:
      
      ```text
      latihan=# SELECT *
      FROM   crosstab(
         'SELECT student, subject, evaluation_result
          FROM   evaluation
          ORDER  BY 1,2'  -- needs to be "ORDER BY 1,2" here
         ) AS ct ("Nama" varchar(60), "Bahasa Arab" numeric, "Bahasa Indonesia" numeric, "Matematika" numeric);
        Nama  | Bahasa Arab | Bahasa Indonesia | Matematika 
      --------+-------------+------------------+------------
       Ahmad  |           8 |                7 |          9
       Fauzan |           8 |                9 |          6
      (2 rows)
       ```

6.    Perlu diperhatikan, bahwa type data yang digunakan harus sama persis antara table sumber dengan table yang akan dihasilkan. Contoh diatas terlihat bahwa type data varchar(60) yang digunakan untuk field student, maka field Nama juga menggunakan type data varchar(60).

7.    Pada fungsi crosstab, dilakukan "ORDER BY 1,2", maka susunan kategori kita sesuaikan agar tepat judul dan nilainya. 

Daftar Pustaka:
- [PostgreSQL Crosstab Query](https://stackoverflow.com/questions/3002499/postgresql-crosstab-query/11751905#11751905)
- [PostgreSQL: tablefunc](https://www.postgresql.org/docs/11/tablefunc.html)

# Alhamdulillah
