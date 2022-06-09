---
layout: post
title:  "Text Processing pada Unix-like System"
date:   2022-06-02 11:26:56 +0800
categories: linux
---

# Bismillah,

Pada catatan di bawah ini, saya coba tampilkan sedikit contoh Text Processing
dengan Command Line. Adapun untuk penjelasan panjang nya, silahkan merujuk
ke [sumber ini](https://learnbyexample.gitbooks.io/linux-command-line/content/Text_Processing.html).

Pada contoh ini, kita memiliki sebuah file dengan nama latihan. Untuk menampilkan isi file, kita 
menggunakan perintah cat.

{% highlight text %}
$ cat latihan 
ini latihan
itu percobaan
ini coba
ini latihan
itu percobaan
ini coba
ini latihan
ini coba
itu percobaan
ini latihan
ini coba
ini latihan
ini coba
itu percobaan
ini latihan
ini coba
ini latihan
itu percobaan
ini coba
ini latihan
ini coba
ini latihan
ini coba
itu percobaan
{% endhighlight %}

Saya melakukan pengurutan berdasarkan kalimat dengan perintah sort. Agar output dari
perintah cat menjadi input bagi sort, kita menggunkan simbol | (pipe).

```text
$ cat latihan | sort
ini coba
ini coba
ini coba
ini coba
ini coba
ini coba
ini coba
ini coba
ini coba
ini latihan
ini latihan
ini latihan
ini latihan
ini latihan
ini latihan
ini latihan
ini latihan
ini latihan
itu percobaan
itu percobaan
itu percobaan
itu percobaan
itu percobaan
itu percobaan
```

Kita akan tampilkan hanya kalimat yang unik saja, maka digunakanlah perintah uniq.

```text
$ cat latihan | sort | uniq
ini coba
ini latihan
itu percobaan
```

Baik, kemudian, saya mau mengambil kata _kedua_ pada tiap kalimat, maka kita gunakan
perintah awk.

```text
$ cat latihan | sort | uniq | awk '{print $2}'
coba
latihan
percobaan
```

Kemudian, saya ingin menambahkan kalimat "sampai berhasil" pada masing-masing kalimat. Kita 
gunakan perintah sed.

```text
$ cat latihan | sort | uniq | awk '{print $2}' | sed 's/$/ sampai berhasil/g'
coba sampai berhasil
latihan sampai berhasil
percobaan sampai berhasil
```

Sampai disini dulu penyampaian dari saya, semoga bermanfaat.

# Alhamdulillah
