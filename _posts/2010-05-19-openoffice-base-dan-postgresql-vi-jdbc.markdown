---
author: muntaza
comments: true
date: 2010-05-19 05:16:41+00:00
layout: post
link: https://muntaza.wordpress.com/2010/05/19/openoffice-base-dan-postgresql-vi-jdbc/
slug: openoffice-base-dan-postgresql-vi-jdbc
title: OpenOffice Base dan Postgresql via JDBC
wordpress_id: 185
categories:
- kisah muhammad muntaza
- linux
- Windows XP
---

bash-4.1$ createdb -U postgres -O muntaza bukusaya

bash-4.1$ psql bukusaya
psql (8.4.2)
Type "help" for help.

bukusaya=> CREATE TABLE buku (
bukusaya(>      id serial PRIMARY KEY,
bukusaya(>      judul varchar(150),
bukusaya(>      penerbit varchar(150)
bukusaya(> );
NOTICE:  CREATE TABLE will create implicit sequence "buku_id_seq" for serial column "buku.id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "buku_pkey" for table "buku"
CREATE TABLE
bukusaya=>

document jdbc:
http://jdbc.postgresql.org/documentation/84/

tempat mendownload file archive jdbc:
http://jdbc.postgresql.org/download/postgresql-8.4-701.jdbc4.jar

proses download:
bash-4.1$ cd
bash-4.1$ mkdir ~/postgres
bash-4.1$ cd ~/postgres/
bash-4.1$ pwd
/home/muntaza/postgres
bash-4.1$ wget -c http://jdbc.postgresql.org/download/postgresql-8.4-701.jdbc4.jar
--2010-05-10 15:15:22--  http://jdbc.postgresql.org/download/postgresql-8.4-701.jdbc4.jar
Resolving jdbc.postgresql.org (jdbc.postgresql.org)... 200.46.204.71
Connecting to jdbc.postgresql.org (jdbc.postgresql.org)|200.46.204.71|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 510170 (498K) [application/octet-stream]
Saving to: "postgresql-8.4-701.jdbc4.jar"

100%[==================================================================================================>] 510,170     5.65K/s   in 85s

2010-05-10 15:16:48 (5.86 KB/s) - "postgresql-8.4-701.jdbc4.jar" saved [510170/510170]

bash-4.1$

Setting di OpenOffice

Tools>Options>Java>Class Path>Add Folder> "/home/muntaza/postgres" >Select
Tools>Options>Java>Class Path >Add Archive> (/home/muntaza/postgres)postgresql-8.4-701.jdbc4.jar >Open>OK>OK

restart OpenOffice, bila anda di Windows, restart juga Quick start.

Connect to an existing database>JDBC
Datasource URL> jdbc:postgresql://192.168.0.80/bukusaya

JDBC driver class> org.postgresql.Driver

Next>Username: muntaza, Password required ok>Next>Finish
Save as "postgres_bukusaya.odb"
