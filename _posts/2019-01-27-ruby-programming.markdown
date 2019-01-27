---
layout: post
title:  "Ruby Programming"
date:   2019-01-27 11:26:56 +0800
categories: ruby programming
---



# Bismillah,

Ini adalah kesan yang saya ingin sampaikan setelah mempelajari Bahasa
Pemprogramman Ruby, di aplikasi Sololearn yang ada di HP Android saya.

saya membahas 2 contoh program saja, yang memperlihatkan kebelihan ruby
ini di bandingkan bahasa yang lain, saya akan kasih komentar pada program
ini semampu saya.

OK, ini program yang pertama:

{% highlight ruby %}

#!/usr/bin/ruby

def factorial(x)
    (1..x).inject(:*) || 1
end

def sq(*p)
    p.each do
	|x| puts "#{x} kuadrat = #{x*x}"
    end
end

a = 7
puts "factorial dari #{a} adalah #{factorial(a)}"

puts "-----------------"

sq(3,4,5,6)
sq(9,7)

{% endhighlight %}

Ini contoh pemanfaatan method, atau dalam bahasa lain disebut fungsi.
pada method factorial, setelah di definisikan maka bisa di panggil
dengan perintah:

{% highlight ruby %}
factorial(4)
{% endhighlight %}

dengan ini, maka kode yang di definisikan di method tadi di eksekusi.
Hanya saja, disini hanya ada satu argumen, yaitu 4, apabila di panggil

{% highlight ruby %}
factorial(4,5)
{% endhighlight %}

maka akan error, karena jumlah argumen lebih dari yang di definisikan.

method factorial ini menghitung perkalian dari 1 sampai angka argumennya
misalnya factorial(6) menghitung:
{% highlight ruby %}
1 x 2 x 3 x 4 x 5 = 120
{% endhighlight %}
disini terlihat bahwa Ruby ini menyimpan fitur yang sangat menarik, yaitu
kode yang ditulis dengan singkat namun menghasilkan hasil yang kalau dengan
bahasa lain akan cukup panjang, he....he...


Pada method sq, kita lihat bahwa argumen yang di panggil bisa berapa saja,
di sini di contohkan memanggil

{% highlight ruby %}
sq(3,4,5,6)
sq(9,7)
{% endhighlight %}

hal ini di sebabkan oleh pendefinisian argumen dengan
{% highlight ruby %}
sq(*p)
{% endhighlight %}

Ini, menurut saya, fitur Ruby juga, karena di bahasa lain, jumlah argumen
biasanya harus di definisikan jumlahnya, misal
sq(a, b, c)
{% endhighlight %}

sehingga hanya bisa menerima sebanyak argumen yang di definikan



Ini program kedua:


{% highlight ruby %}

#!/usr/bin/ruby

module Mampu_berenang
    def berenang
	"Bisa Berenang"
    end
end

module Mampu_berjalan
    def berjalan
	"Bisa Berjalan"
    end
end

class Binatang
    attr_accessor :nama, :warna

    def initialize(nama, warna)
	@nama = nama
	@warna = warna
    end

    def get_info
	puts "#{@nama} berwarna #{@warna}"
    end
end

class Kucing < Binatang
    include Mampu_berjalan

    def suara
	"Meow"
    end
end

k = Kucing.new("Si Uning", "Kuning Putih")
k.get_info
print "#{k.nama} berbunyi #{k.suara}\n"

k.warna = "Cokelat"
k.get_info
print "#{k.nama} #{k.berjalan}\n"

puts "---------------------------"

class Bebek < Binatang
    include Mampu_berjalan
    include Mampu_berenang
end

b = Bebek.new("Si itik", "Abu-abu")
b.get_info
print "#{b.nama} #{b.berjalan} dan #{b.berenang}\n"

{% endhighlight %}

di sini kita lihat, bahwa class di definisikan lalu object
mengikuti definisi class yang mendasarinya. Class bisa
di turunkan, misal class Binatang, lalu di buat class Kucing
yang memiliki sifat class Binatang dan memiliki ciri nya sendiri.

di sini juga terlihat, bahwa class Bebek bisa menggunakan
add-on berupa module Mampu_berenang, Mampu_berjalan.

Cara initialize object dari class nya, dengan perintah


{% highlight ruby %}
k = Kucing.new("Si Uning", "Kuning Putih")
{% endhighlight %}

cara merubah variable pada object, dengan perintah

{% highlight ruby %}
k.warna = "Cokelat"
{% endhighlight %}

Terlihat bahwa ruby sangat ketat sekali dengan sifat Pemprogramman
Berorientasi Objek, dan inilah paradigma bahasa Ruby.

Semoga tulisan dari saya yang masih awam ini bisa bermanfaat, terutama
untuk saya sendiri, walaupun bahasa dan penulisannya masih sangat banyak
kekurangannya.



