---
layout: post
title:  "Penyusutan Aset Tetap"
date:   2021-09-23 11:26:56 +0800
categories: sql
---

# Bismillah,

Ini adalah perhitungan penyusutan aset tetap dengan metode garis lurus. Penyusutan
per tahun, dengan penambahan umur ekonomis bila ada kapitalisasi terhadap aset tetap
tersebut. Saya menuliskan algoritma nya dengan berurutan. Tulisan ini minim keterangan,
saya belum punya waktu yang cukup untuk memberikan keterangan-keterangan penting,
sehingga mungkin sulit dipahami.

Inti yang ingin saya sampaikan, silahkan dipelajari lebih dalam window fungtions pada
PostgreSQL, karena algoritma ini menggunakan banyak fitur pada window fungtions tersebut.

# Pertama

```sql
DROP VIEW IF EXISTS view_penyusutan_108_gb_2021_r2_a1 CASCADE;


CREATE VIEW view_penyusutan_108_gb_2021_r2_a1 AS



SELECT * FROM

(SELECT
gedung_bangunan.id_sub_skpd,

sub_skpd.nama_sub_skpd,
sub_skpd.id_skpd,

skpd.nama_skpd,
skpd.id_lokasi_bidang,

lokasi_bidang.nama_lokasi_bidang,
lokasi_bidang.id_kabupaten,

kabupaten.nama_kabupaten,
kabupaten.id_provinsi,

provinsi.nama_provinsi,

gedung_bangunan.id_mutasi_berkurang,
mutasi_berkurang.mutasi_berkurang,

keadaan_barang.keadaan_barang,
satuan_barang.satuan_barang,
golongan_barang.golongan_barang,
gedung_bangunan.id_golongan_barang,

gedung_bangunan.nama_barang,
LEFT(kode_barang_108.kode_barang_108, 18) kode_barang_108,
LEFT(kode_barang_108.kode_barang_108, 8) kode_l2,
gedung_bangunan.id register,

'' as merk_type,
gedung_bangunan.nomor_dokumen_gedung as no_no,
'' as bahan,
harga_gedung_bangunan.tahun,
CONCAT(SUM(harga_gedung_bangunan.luas_lantai), ' m2') as ukuran_barang,
SUM(harga_gedung_bangunan.harga_bertambah) - SUM(harga_gedung_bangunan.harga_berkurang) harga,
gedung_bangunan.keterangan



FROM
gedung_bangunan as gedung_bangunan, harga_gedung_bangunan as harga_gedung_bangunan, kode_barang_108,
mutasi_berkurang, asal_usul, keadaan_barang, satuan_barang, golongan_barang,
status_tingkat, status_beton,
sub_skpd, skpd, lokasi_bidang, kabupaten, provinsi, view_tanah_tanpa_harga_kabupaten


WHERE
1 = 1  AND
harga_gedung_bangunan.id_gedung_bangunan = gedung_bangunan.id AND
harga_gedung_bangunan.id_asal_usul = asal_usul.id AND

harga_gedung_bangunan.tahun <= 2021 AND

gedung_bangunan.id_kode_barang_108 = kode_barang_108.id AND
gedung_bangunan.id_mutasi_berkurang = mutasi_berkurang.id AND

gedung_bangunan.id_keadaan_barang = keadaan_barang.id AND
gedung_bangunan.id_satuan_barang = satuan_barang.id AND
gedung_bangunan.id_golongan_barang = golongan_barang.id AND

golongan_barang.id = 3 AND

gedung_bangunan.id_status_tingkat = status_tingkat.id AND
gedung_bangunan.id_status_beton = status_beton.id AND


gedung_bangunan.id_tanah = view_tanah_tanpa_harga_kabupaten.id_tanah AND


gedung_bangunan.id_sub_skpd = sub_skpd.id AND
sub_skpd.id_skpd = skpd.id AND
skpd.id_lokasi_bidang = lokasi_bidang.id AND
lokasi_bidang.id_kabupaten = kabupaten.id AND
kabupaten.id_provinsi = provinsi.id



GROUP BY
gedung_bangunan.id_sub_skpd,
sub_skpd.nama_sub_skpd,
sub_skpd.id_skpd,
skpd.nama_skpd,
skpd.id_lokasi_bidang,
lokasi_bidang.nama_lokasi_bidang,
lokasi_bidang.id_kabupaten,
kabupaten.nama_kabupaten,
kabupaten.id_provinsi,
provinsi.nama_provinsi,
gedung_bangunan.id_mutasi_berkurang,
mutasi_berkurang.mutasi_berkurang,
keadaan_barang.keadaan_barang,
satuan_barang.satuan_barang,
golongan_barang.golongan_barang,
gedung_bangunan.id_golongan_barang,
gedung_bangunan.nama_barang,

kode_barang_108,
kode_l2,
register,

merk_type,
no_no,
bahan,
harga_gedung_bangunan.tahun,
gedung_bangunan.keterangan) AS QUERY_GEDUNG_BANGUNAN


;


GRANT ALL PRIVILEGES ON view_penyusutan_108_gb_2021_r2_a1 TO user_laporan;
REVOKE INSERT, UPDATE, DELETE ON view_penyusutan_108_gb_2021_r2_a1 FROM user_laporan;
```

# Kedua

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_e2 CASCADE;

create view view_penyusutan_108_gb_2021_r2_e2 as select
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

register,
harga,
sum (harga) over (partition by register order by tahun asc) as nilai_perolehan,
tahun,
view_penyusutan_108_gb_2021_r2_a1.kode_barang_108,
left(view_penyusutan_108_gb_2021_r2_a1.kode_barang_108, 11) as kode_umur,
rank() over (partition by register order by tahun asc) as rank,
lead(tahun, 1, 2022) over (partition by register order by tahun asc) as tahun_akhir,
umur as masa_manfaat,
0 as penambahan_umur,
umur as umur_awal,

CASE WHEN ((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun) < umur
     THEN umur - ((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun)
ELSE
     0
END as sisa_umur,

harga as nilai_buku_awal,

CASE WHEN ((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun) < umur
     THEN round(((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun) * harga / umur, 0)
ELSE
     harga
END as penyusutan,

CASE WHEN ((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun) < umur
    THEN harga - (round(((lead(tahun, 1, 2022) over (partition by register order by tahun asc)) - tahun) * harga / umur, 0))
ELSE
     0
END as nilai_buku_akhir

from view_penyusutan_108_gb_2021_r2_a1, kode_barang_108

where view_penyusutan_108_gb_2021_r2_a1.kode_barang_108 = left(kode_barang_108.kode_barang_108, 18)

order by register, rank;
```

Cek umur barang, apakah lebih dari umur ekonomis.
Bila lebih, berarti disusutkan seluruh nilainya.


# Ketiga

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_e3 CASCADE;

create view view_penyusutan_108_gb_2021_r2_e3 as

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

harga,
nilai_perolehan,
tahun,
view_penyusutan_108_gb_2021_r2_e2.kode_barang_108,
kode_umur,
rank,
tahun_akhir,


CASE WHEN rank > 1 AND lag(nilai_perolehan) over urutan > 0
          THEN round (100 * (harga / lag(nilai_perolehan) over urutan),2)
     WHEN rank > 1 AND lag(nilai_perolehan) over urutan <= 0
          THEN round(100,2)
     WHEN rank = 1
	  THEN 0
ELSE
     0
END as persen_awal,




CASE WHEN

  CASE WHEN rank > 1 AND lag(nilai_perolehan) over urutan > 0
	    THEN round (100 * (harga / lag(nilai_perolehan) over urutan),2)
      WHEN rank > 1 AND lag(nilai_perolehan) over urutan <= 0
	    THEN round(100,2)
      WHEN rank = 1
	    THEN 0
  ELSE
      0
  END

     > 75
     THEN 100


     WHEN

  CASE WHEN rank > 1 AND lag(nilai_perolehan) over urutan > 0
	    THEN round (100 * (harga / lag(nilai_perolehan) over urutan),2)
      WHEN rank > 1 AND lag(nilai_perolehan) over urutan <= 0
	    THEN round(100,2)
      WHEN rank = 1
	    THEN 0
  ELSE
      0
  END

     > 50
         THEN 75


     WHEN

  CASE WHEN rank > 1 AND lag(nilai_perolehan) over urutan > 0
	    THEN round (100 * (harga / lag(nilai_perolehan) over urutan),2)
      WHEN rank > 1 AND lag(nilai_perolehan) over urutan <= 0
	    THEN round(100,2)
      WHEN rank = 1
	    THEN 0
  ELSE
      0
  END

     > 25
         THEN 50


     WHEN

  CASE WHEN rank > 1 AND lag(nilai_perolehan) over urutan > 0
	    THEN round (100 * (harga / lag(nilai_perolehan) over urutan),2)
      WHEN rank > 1 AND lag(nilai_perolehan) over urutan <= 0
	    THEN round(100,2)
      WHEN rank = 1
	    THEN 0
  ELSE
      0
  END

     > 0
         THEN 25
ELSE
         0
END as persentasi,

masa_manfaat,
penambahan_umur,
umur_awal,
sisa_umur,
nilai_buku_awal,
penyusutan,
nilai_buku_akhir
 from
view_penyusutan_108_gb_2021_r2_e2
 Window
urutan as (partition by register order by rank)


order by register, rank;
```

Mengubah persen_awal menjadi persen yang dapat di link
ke table penambahan_umur.


Adapun sisa_umur_temp di buat untuk mengakses sisa_umur
pada baris sebelumnya.


Akses penambahan_umur, 
terdapat bug pada query sql, yaitu ketika
link ke table penambahan_umur, maka tidak dilakukan
link seperti biasa, yaitu
```sql
persentasi = view_penambahan_umur_108.persen
```

tetapi

```sql
view_penambahan_umur_108.persen > 75 
```
Saya tidak tahu kenapa seperti itu.

# Keempat

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_e4 CASCADE;

create view view_penyusutan_108_gb_2021_r2_e4 as

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

harga,
nilai_perolehan,
tahun,
view_penyusutan_108_gb_2021_r2_e3.kode_barang_108,
kode_umur,
rank,
tahun_akhir,
persen_awal,

persentasi,

masa_manfaat,
CASE WHEN rank > 1
          THEN view_penambahan_umur_108.umur
     WHEN rank = 1
	  THEN 0
ELSE
     0
END as penambahan_umur,


umur_awal,
sisa_umur,
nilai_buku_awal,
penyusutan,
nilai_buku_akhir


 from
view_penyusutan_108_gb_2021_r2_e3, view_penambahan_umur_108

where
view_penyusutan_108_gb_2021_r2_e3.kode_umur = view_penambahan_umur_108.kode_kelompok_barang AND
view_penyusutan_108_gb_2021_r2_e3.persentasi = view_penambahan_umur_108.persen

order by register, rank;
```

# Kelima

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_e5 CASCADE;

create view view_penyusutan_108_gb_2021_r2_e5 as

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

harga,
nilai_perolehan,
tahun,
kode_barang_108,
kode_umur,
rank,
tahun_akhir,
persen_awal,

persentasi,

masa_manfaat,
penambahan_umur,

CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur >= masa_manfaat
          THEN masa_manfaat
     WHEN rank = 1
	  THEN masa_manfaat
ELSE
     lag(sisa_umur,1,0) over urutan + penambahan_umur
END as umur_awal,

CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur - (tahun_akhir - tahun) > 0
          AND lag(sisa_umur,1,0) over urutan + penambahan_umur - (tahun_akhir - tahun) <= masa_manfaat
          THEN lag(sisa_umur,1,0) over urutan + penambahan_umur - (tahun_akhir - tahun)

     WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur - (tahun_akhir - tahun) > 0
          AND lag(sisa_umur,1,0) over urutan + penambahan_umur - (tahun_akhir - tahun) > masa_manfaat
          AND masa_manfaat - (tahun_akhir - tahun) > 0
          THEN masa_manfaat - (tahun_akhir - tahun)

     WHEN rank = 1 AND masa_manfaat - (tahun_akhir - tahun) > 0
	  THEN masa_manfaat - (tahun_akhir - tahun)
ELSE
    0
END as sisa_umur,



COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga as nilai_buku_awal,



CASE WHEN (tahun_akhir - tahun) <

     CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur >= masa_manfaat
          THEN masa_manfaat
     WHEN rank = 1
	  THEN masa_manfaat
     ELSE
     lag(sisa_umur,1,0) over urutan + penambahan_umur
     END


     THEN round((tahun_akhir - tahun) * (COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga) /

     (CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur >= masa_manfaat
          THEN masa_manfaat
     WHEN rank = 1
	  THEN masa_manfaat
     ELSE
     lag(sisa_umur,1,0) over urutan + penambahan_umur
     END),

     0)
ELSE
     COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga
END as penyusutan,

CASE WHEN (tahun_akhir - tahun) <

     CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur >= masa_manfaat
          THEN masa_manfaat
     WHEN rank = 1
	  THEN masa_manfaat
     ELSE
     lag(sisa_umur,1,0) over urutan + penambahan_umur
     END


     THEN (COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga) -
     (round((tahun_akhir - tahun) * (COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga) /

     (CASE WHEN rank > 1 AND lag(sisa_umur,1,0) over urutan + penambahan_umur >= masa_manfaat
          THEN masa_manfaat
     WHEN rank = 1
	  THEN masa_manfaat
     ELSE
     lag(sisa_umur,1,0) over urutan + penambahan_umur
     END),

     0))
ELSE
     (COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga) - (COALESCE(lag(nilai_buku_akhir) over urutan, 0) + harga)
END as nilai_buku_akhir


 from
view_penyusutan_108_gb_2021_r2_e4
 Window
urutan as (partition by register order by rank)

order by register, rank;
```

Algoritma Ketiga, Keempat dan Kelima harus di ulang sejumlah baris data tahun penambahan umur.
Saya tidak tahu kenapa seperti itu, adapun kalau tidak di ulang, maka angka yang dihasilkan 
tidak tepat. Ini adalah bug dalam algoritma ini.

# Keenam

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_a3 CASCADE;

create view view_penyusutan_108_gb_2021_r2_a3 as

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

harga,
nilai_perolehan,
sum(harga) over (partition by register) as harga_total,
tahun,
kode_barang_108,
kode_umur,
rank,
tahun_akhir - 1 as tahun_akhir,
persen_awal,

persentasi,

masa_manfaat,
penambahan_umur,


umur_awal,
sisa_umur,
nilai_buku_awal,
penyusutan,
nilai_buku_akhir


 from
view_penyusutan_108_gb_2021_r2_e29


order by register, rank;

GRANT ALL PRIVILEGES ON view_penyusutan_108_gb_2021_r2_a3 TO user_laporan;
REVOKE INSERT, UPDATE, DELETE ON view_penyusutan_108_gb_2021_r2_a3 FROM user_laporan;
```

# Ketujuh

```sql
DROP view if exists view_penyusutan_108_gb_2021_r2_a4 CASCADE;

create view view_penyusutan_108_gb_2021_r2_a4 as

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

kode_barang_108,
min(tahun) as tahun_awal,

sum(harga) as nilai_perolehan,
sum(penyusutan) as penyusutan,
sum(harga) - sum(penyusutan) as nilai_buku


 from
view_penyusutan_108_gb_2021_r2_a3

GROUP BY
register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

kode_barang_108

order by register;

GRANT ALL PRIVILEGES ON view_penyusutan_108_gb_2021_r2_a4 TO user_laporan;
REVOKE INSERT, UPDATE, DELETE ON view_penyusutan_108_gb_2021_r2_a4 FROM user_laporan;
```

# Kedelapan

```sql
DROP view if exists view_beban_penyusutan_108_gb_2021_r2_a1 CASCADE;

create view view_beban_penyusutan_108_gb_2021_r2_a1 as


select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

kode_barang_108,
tahun_awal,

nilai_perolehan as nilai_perolehan_sd_2020,
0 as nilai_perolehan_sd_2021,

nilai_buku as nilai_buku_sd_2020,
0 as nilai_buku_sd_2021


 from
view_penyusutan_108_gb_2020_r2_a4


UNION ALL

select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

kode_barang_108,
tahun_awal,

0 as nilai_perolehan_sd_2020,
nilai_perolehan as nilai_perolehan_sd_2021,

0 as nilai_buku_sd_2020,
nilai_buku as nilai_buku_sd_2021


 from
view_penyusutan_108_gb_2021_r2_a4


order by register;
```

# Kesembilan

```sql
DROP view if exists view_beban_penyusutan_108_gb_2021_r2_a2 CASCADE;

create view view_beban_penyusutan_108_gb_2021_r2_a2 as


select register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,

kode_barang_108,
min(tahun_awal) as tahun_awal,

sum(nilai_perolehan_sd_2020) as nilai_perolehan_sd_2020,
sum(nilai_perolehan_sd_2021) - sum(nilai_perolehan_sd_2020) as penambahan_nilai_di_2021,
sum(nilai_perolehan_sd_2021) as nilai_perolehan_sd_2021,

sum(nilai_perolehan_sd_2020) - sum(nilai_buku_sd_2020) as nilai_penyusutan_sd_2020,

sum(nilai_buku_sd_2020) as nilai_buku_sd_2020,

sum(nilai_buku_sd_2020) +
(sum(nilai_perolehan_sd_2021) - sum(nilai_perolehan_sd_2020)) -
sum(nilai_buku_sd_2021) as beban_penyusutan_2021,

sum(nilai_perolehan_sd_2021) - sum(nilai_buku_sd_2021) as nilai_penyusutan_sd_2021,
sum(nilai_buku_sd_2021) as nilai_buku_sd_2021


 from
view_beban_penyusutan_108_gb_2021_r2_a1

GROUP BY
register,
nama_skpd,
id_skpd,
nama_lokasi_bidang,
id_lokasi_bidang,
nama_kabupaten,
id_kabupaten,
nama_provinsi,
id_provinsi,
id_mutasi_berkurang,
mutasi_berkurang,
keadaan_barang,
nama_barang,
kode_barang_108


order by register;

GRANT ALL PRIVILEGES ON view_beban_penyusutan_108_gb_2021_r2_a2 TO user_laporan;
REVOKE INSERT, UPDATE, DELETE ON view_beban_penyusutan_108_gb_2021_r2_a2 FROM user_laporan;
```

Sekian tulisan ini, semoga bermanfaat.

# Alhamdulillah
