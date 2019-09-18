---
layout: post
title:  "Kalkulus dengan Bahasa C"
date:   2012-04-23 12:26:56 +0800
categories: kalkulus
---

# Bismillah,

Sambil belajar Kalkulus, seorang mahasiswa jurusan IT belajar juga Pemprograman, nah agar keduanya bisa berjalan beriringan, maka kita praktek kan ilmu yang kita pelajari yaitu Bahasa C untuk menyelesaikan soal dari Mata kuliah Kalkulus. Namun, kepada adik-adit mahasiswa IT, tetap hitung soal yang diberikan dosen mata kuliah Kalkulus secara manual ya... itu melatih kejujuran kalian,..... he...he...

Nah, ini adalah program dalam Bahasa C yang di tujukan untuk mencari turunan dari suatu fungsi dan anti turunannya. Berikut ini source dari program untuk mencari turunan:

{% highlight c %}
/* Copyright 2012 @ Muhammad Muntaza bin Hatta *
 * Lisensi: GPL v3                             *
 * Program mencari Turunan suatu Fungsi        *
 * web: www.muntaza.id                  *
 * email: muhammad@muntaza.id                 */


#include <stdio.h>

int main() {
        float k, n;
        printf("Program untuk menghitung Turunan Fungsi f(x) => f\'(x)\n");
        printf("Masukkan konstanta: ");
        scanf("%f", &k);
        printf("Masukkan pangkat: ");
        scanf("%f", &n);

        printf("f(x) = %.2f x^%.2f\n", k, n);
        printf("f\'(x) = %.2f . %.2f x^(%.2f - 1)\n", k, n, n);
        printf("f\'(x) = %.2f x^%.2f\n", k * n, n - 1);
}

{% endhighlight %}

Dan ini adalah source code untuk mencari anti turunan suatu fungsi:

{% highlight c %}
/* Copyright 2012 @ Muhammad Muntaza bin Hatta *
 * Lisensi: GPL v3                             *
 * Program mencari Anti Turunan suatu Fungsi   *
 * web: www.muntaza.id                  *
 * email: muhammad@muntaza.id                 */


#include <stdio.h>

int main() {
        float k, n;
        printf("Program untuk menghitung Anti Turunan f\'(x) => f(x)\n");
        printf("Masukkan konstanta: ");
        scanf("%f", &k);
        printf("Masukkan pangkat: ");
        scanf("%f", &n);

        printf("f\'(x) = %.2f x^%.2f\n", k, n);
        printf("f(x) = ((%.2f / (%.2f + 1)) . (x^(%.2f + 1))) + C \n", k, n, n);
        printf("f(x) = ((%.2f / (%.2f)) . (x^%.2f))  + C\n", k, n + 1, n + 1);
        printf("f(x) = (%.2f . (x^%.2f)) + C  \n", k / (n + 1), n + 1);
}

{% endhighlight %}

Pada kedua program ini, konstanta Harus di isi, bila fungsi itu adalah f(x)=X^3, berarti konstantanya bernilai 1.

Semoga Allah Rabbuna Jalla Wa ‘Ala Mengkaruniakan kepada saya rezeki yang saya harapkan. Aamiin

ditulis oleh: Al faqir ilaa maghfirati rabbihi Abu Muhammad Muhammad Muntaza bin Hatta

# Alhamdulillah
