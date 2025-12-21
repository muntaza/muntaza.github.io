---
layout: post
title:  "Pelajaran SQL WITH Queries (Common Table Expressions)"
date:   2025-12-15 01:00:00 +0800
categories: sql
---

# Bismillah,

Tulisan ini terkait penggunaan CTE, yang mana bermanfaat untuk mempersingkat penulisan query.
Dulu, saya menggunakan query bertingkat, misalnya buat view_a, kemudian buat view_b dengan sumber
view_a untuk filter lebih lanjut. Dengan CTE ini, filter bisa langsung built-in di dalam sebuah view.

Disini saya contoh kan pembuatan user dan database latihan, proses pembuatan dengan user postgres di sistem linux.

```text
$ createuser latihan -P
Enter password for new role: 
Enter it again: 
$ createdb latihan -O latihan
$ exit
exit
```

Koneksi ke database latihan dengan user latihan:

```text
abdullah@E202SA$ psql -U latihan latihan -h localhost
Password for user latihan: 
psql (12.22 (Ubuntu 12.22-0ubuntu0.20.04.4), server 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.
```

Disini saya contoh kan pembuatan table, pengisian data kedalam table, sehingga query yang ada disini dapat di jalankan.

```text
CREATE TABLE penjualan (
     wilayah    varchar(60),
     produk     varchar(60),
     jumlah     integer,
     harga      integer
);
```

```text
INSERT INTO penjualan VALUES ('Barabai', 'A', 5, 1000);
INSERT INTO penjualan VALUES ('Barabai', 'B', 6, 1000);
INSERT INTO penjualan VALUES ('Barabai', 'C', 7, 1000);
INSERT INTO penjualan VALUES ('Barabai', 'D', 8, 1000);
INSERT INTO penjualan VALUES ('Barabai', 'E', 5, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'A', 5, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'B', 6, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'C', 7, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'D', 8, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'E', 5, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'A', 5, 1000);
INSERT INTO penjualan VALUES ('Amuntai', 'A', 5, 1000);
INSERT INTO penjualan VALUES ('Tanjung', 'A', 5, 1000);
INSERT INTO penjualan VALUES ('Tanjung', 'B', 6, 1000);
INSERT INTO penjualan VALUES ('Tanjung', 'C', 7, 1000);
INSERT INTO penjualan VALUES ('Tanjung', 'A', 3, 1000);
INSERT INTO penjualan VALUES ('Tanjung', 'A', 5, 1000);
```

Ini tampilan data yang ada di table penjualan saat ini:

```text
SELECT * FROM penjualan;

 wilayah | produk | jumlah | harga
---------+--------+--------+-------
 Barabai | A      |      5 |  1000
 Barabai | B      |      6 |  1000
 Barabai | C      |      7 |  1000
 Barabai | D      |      8 |  1000
 Barabai | E      |      5 |  1000
 Amuntai | A      |      5 |  1000
 Amuntai | B      |      6 |  1000
 Amuntai | C      |      7 |  1000
 Amuntai | D      |      8 |  1000
 Amuntai | E      |      5 |  1000
 Amuntai | A      |      5 |  1000
 Amuntai | A      |      5 |  1000
 Tanjung | A      |      5 |  1000
 Tanjung | B      |      6 |  1000
 Tanjung | C      |      7 |  1000
 Tanjung | A      |      3 |  1000
 Tanjung | A      |      5 |  1000
(17 rows)


```

Baik, kita mulai dengan query sederhana, penggunaan fungsi SUM untuk menjumlahkan total penjualan per produk per wilayah:


```text
SELECT wilayah,
       produk,
       SUM(harga*jumlah) AS total_penjualan
FROM penjualan
GROUP BY wilayah, produk
ORDER BY wilayah, total_penjualan DESC;

 wilayah | produk | total_penjualan
---------+--------+-----------------
 Amuntai | A      |           15000
 Amuntai | D      |            8000
 Amuntai | C      |            7000
 Amuntai | B      |            6000
 Amuntai | E      |            5000
 Barabai | D      |            8000
 Barabai | C      |            7000
 Barabai | B      |            6000
 Barabai | A      |            5000
 Barabai | E      |            5000
 Tanjung | A      |           13000
 Tanjung | C      |            7000
 Tanjung | B      |            6000
(13 rows)
```

Kemudian, di bawah ini total penjualan per wilayah:

```text
SELECT wilayah,
       SUM(harga*jumlah) AS total_penjualan
FROM penjualan
GROUP BY wilayah
ORDER BY wilayah, total_penjualan DESC;


 wilayah | total_penjualan
---------+-----------------
 Amuntai |           41000
 Barabai |           31000
 Tanjung |           26000
(3 rows)
```

Disini contoh penggunaan CTE, mencari wilayah yang penjualannya lebih dari rata-rata semua wilayah. Tampak saat ini wilayah Amuntai lebih besar dari rata-rata. Saat terjadi perubahan, misalnya ada penambahan penjualan pada wilayah Tanjung, maka hasilnya akan
langsung menyesuaikan. Dengan memahami konsep ini, terlihat sekali manfaat CTE ini.


```text
WITH penjualan_wilayah AS (
    SELECT wilayah, SUM(harga*jumlah) AS total_penjualan
    FROM penjualan
    GROUP BY wilayah
) 
    SELECT wilayah
    FROM penjualan_wilayah
    WHERE total_penjualan > (SELECT SUM(total_penjualan)/3 FROM penjualan_wilayah);

 wilayah
---------
 Amuntai
(1 row)
```

Kemudian, CTE di bawah ini lebih rumit lagi, he, yaitu pilih wilayah yang lebih besar dari rata-rata semua wilayah, kemudian tampilkan produk apa saja yang terjual di wilayah tersebut.


```text
WITH penjualan_wilayah AS (
    SELECT wilayah, SUM(harga*jumlah) AS total_penjualan
    FROM penjualan
    GROUP BY wilayah
), wilayah_teratas AS (
    SELECT wilayah
    FROM penjualan_wilayah
    WHERE total_penjualan > (SELECT SUM(total_penjualan)/3 FROM penjualan_wilayah)
)
SELECT wilayah,
       produk,
       SUM(harga*jumlah) AS total_penjualan
FROM penjualan
WHERE wilayah IN (SELECT wilayah FROM wilayah_teratas)
GROUP BY wilayah, produk
ORDER BY total_penjualan DESC;

 wilayah | produk | total_penjualan
---------+--------+-----------------
 Amuntai | A      |           15000
 Amuntai | D      |            8000
 Amuntai | C      |            7000
 Amuntai | B      |            6000
 Amuntai | E      |            5000
(5 rows)
```

Untuk menambah pemahaman, silahkan di coba menambah kan 1 data ke wilayah Tanjung:

```text
INSERT INTO penjualan VALUES ('Tanjung', 'A', 30, 1000);
```

Kemudian silahkan jalankan lagi 2 query CTE diatas, apa hasilnya?

Lebih lanjut terkait CTE, silahkan cek link pada daftar pustaka. Demikian tulisan tentang CTE ini, semoga bermanfaat.

# Alhamdulillah


Daftar Pustaka
1. [WITH Queries (Common Table Expressions)](https://www.postgresql.org/docs/current/queries-with.html)
