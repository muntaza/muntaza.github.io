---
layout: post
title:  "Judul"
date:   2019-12-09 12:26:56 +0800
categories: ssh
---

# Bismillah,


ini adalah program dalam Bahasa C yang di tujukan untuk mencari turunan dari suatu fungsi dan anti turunannya. Berikut ini source dari program untuk mencari turunan

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

Dibawah ini adalah source code untuk mencari anti turunan suatu fungsi
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
