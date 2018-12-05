---
author: muntaza
comments: true
date: 2012-04-23 06:43:46+00:00
layout: post
link: https://muntaza.wordpress.com/2012/04/23/mudah-belajar-kalkulus-dengan-programming-bahasa-c/
slug: mudah-belajar-kalkulus-dengan-programming-bahasa-c
title: Mudah Belajar Kalkulus dengan Programming Bahasa C
wordpress_id: 367
categories:
- kisah muhammad muntaza
- programming
- Windows XP
tags:
- C
---

Bismillah

ini adalah program dalam Bahasa C yang di tujukan untuk mencari turunan dari suatu fungsi dan anti turunannya. Berikut ini source dari program untuk mencari turunan

[sourcecode languange="C" wraplines="false"]
/* Copyright 2012 @ Muhammad Muntaza bin Hatta *
 * Lisensi: GPL v3                             *
 * Program mencari Turunan suatu Fungsi        *
 * web: muntaza.wordpress.com                  *
 * email: muntaza@binhatta.com                 */


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

[/sourcecode]

Dibawah ini adalah source code untuk mencari anti turunan suatu fungsi
[sourcecode languange="C" wraplines="false"]
/* Copyright 2012 @ Muhammad Muntaza bin Hatta *
 * Lisensi: GPL v3                             *
 * Program mencari Anti Turunan suatu Fungsi   *
 * web: muntaza.wordpress.com                  *
 * email: muntaza@binhatta.com                 */


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

[/sourcecode]

Pada kedua program ini, konstanta Harus di isi, bila fungsi itu adalah f(x)=X^3, berarti konstantanya bernilai 1.

Berikut ini screenshoot dari program yang dijalankan:
[![](http://muntaza.files.wordpress.com/2012/04/turunan.jpg)](http://muntaza.files.wordpress.com/2012/04/turunan.jpg)

Walhamdulillah. Semoga Allah Rabbuna Jalla Wa ‘Ala Memudahkan saya untuk tinggal di Banjarbaru

ditulis oleh: Al faqir ilaa maghfirati rabbihi Abu Husnul Khatimah Muhammad Muntaza bin Hatta
