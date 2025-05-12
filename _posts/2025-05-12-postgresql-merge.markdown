---
layout: post
title:  "Contoh Penggunaan fitur MERGE di PostgreSQL"
date:   2025-05-12 01:26:56 +0800
categories: postgresql
---

# Bismillah,

Fitur 
[merge](https://www.postgresql.org/docs/16/sql-merge.html)
pada PostgreSQL berfungsi untuk melakukan insert, delete, atau update bersyarat. 
Apabila syarat terpenuhi, maka di lakukan perintah dimaksud, namun apabila syarat tidak terpenuhi
maka tidak di jalankan perintah tadi.

Gambaran akan lebih jelas dengan contoh, pertama buat table dulu untuk menampung data.


```text
latihan1=> CREATE TABLE customer_account (
latihan1(> id SERIAL,
latihan1(> customer_id INTEGER,
latihan1(> balance INTEGER
latihan1(> );
CREATE TABLE
latihan1=> CREATE TABLE recent_transactions (
id SERIAL,
customer_id INTEGER,
transaction_value INTEGER
);
CREATE TABLE
```

Cek table yang di buat:

```text
latihan1=> \d
                     List of relations
 Schema |            Name            |   Type   |  Owner   
--------+----------------------------+----------+----------
 public | customer_account           | table    | latihan1
 public | customer_account_id_seq    | sequence | latihan1
 public | recent_transactions        | table    | latihan1
 public | recent_transactions_id_seq | sequence | latihan1
(4 rows)

latihan1=> \dt customer_account 
              List of relations
 Schema |       Name       | Type  |  Owner   
--------+------------------+-------+----------
 public | customer_account | table | latihan1
(1 row)

latihan1=> \dt customer_account 
              List of relations
 Schema |       Name       | Type  |  Owner   
--------+------------------+-------+----------
 public | customer_account | table | latihan1
(1 row)

latihan1=> \d customer_account 
                               Table "public.customer_account"
   Column    |  Type   | Collation | Nullable |                   Default       
             
-------------+---------+-----------+----------+---------------------------------
-------------
 id          | integer |           | not null | nextval('customer_account_id_seq
'::regclass)
 customer_id | integer |           |          | 
 balance     | integer |           |          | 

latihan1=> \dt 
                List of relations
 Schema |        Name         | Type  |  Owner   
--------+---------------------+-------+----------
 public | customer_account    | table | latihan1
 public | recent_transactions | table | latihan1
(2 rows)

latihan1=> \d customer_account 
                               Table "public.customer_account"
   Column    |  Type   | Collation | Nullable |                   Default       
             
-------------+---------+-----------+----------+---------------------------------
-------------
 id          | integer |           | not null | nextval('customer_account_id_seq
'::regclass)
 customer_id | integer |           |          | 
 balance     | integer |           |          | 
```

Masukkan data ke table yang telah di buat:

```text
latihan1=> INSERT INTO customer_account (customer_id, balance)
latihan1-> VALUES (1, 15);
INSERT 0 1
latihan1=> INSERT INTO customer_account (customer_id, balance)
VALUES (2, 25);
INSERT 0 1
latihan1=> select * from customer_account;
 id | customer_id | balance 
----+-------------+---------
  1 |           1 |      15
  2 |           2 |      25
(2 rows)

                                                      ^
latihan1=> INSERT INTO recent_transactions (customer_id, transaction_value)
VALUES (2, 10);
INSERT 0 1
latihan1=> INSERT INTO recent_transactions (customer_id, transaction_value)
VALUES (3, 40);
INSERT 0 1
latihan1=> select * from recent_transactions;
 id | customer_id | transaction_value 
----+-------------+-------------------
  1 |           2 |                10
  2 |           3 |                40
(2 rows)
```

Contoh penggunaan fitur merge:

```text
latihan1=> MERGE INTO customer_account ca
latihan1-> USING recent_transactions t
latihan1-> ON t.customer_id = ca.customer_id
latihan1-> WHEN MATCHED THEN
latihan1->   UPDATE SET balance = balance + transaction_value
latihan1-> WHEN NOT MATCHED THEN
latihan1->   INSERT (customer_id, balance)
latihan1->   VALUES (t.customer_id, t.transaction_value);
MERGE 2
latihan1=> select * from recent_transactions;
 id | customer_id | transaction_value 
----+-------------+-------------------
  1 |           2 |                10
  2 |           3 |                40
(2 rows)

latihan1=> select * from customer_account;
 id | customer_id | balance 
----+-------------+---------
  1 |           1 |      15
  2 |           2 |      35
  3 |           3 |      40
(3 rows)

latihan1=> 
```

Terlihat bahwa table *customer_account* berhasil diupdate khusus untuk id yang 
datanya ada pada table *recent_transactions*. Kemudian, pada id yang hanya ada di table 
*recent_transactions*, dilakukan proses insert ke table *customer_account*.

Semoga dengan contoh ini lebih jelas fungsi fitur merge ini. 


# Alhamdulillah
