---
author: muntaza
comments: true
date: 2010-04-26 00:04:51+00:00
layout: post
link: https://muntaza.wordpress.com/2010/04/26/belajar-firewall-dengan-pf-bagian-i/
slug: belajar-firewall-dengan-pf-bagian-i
title: Belajar FIREWALL dengan PF bagian I
wordpress_id: 180
categories:
- kisah muhammad muntaza
- linux
- OpenBSD
---

[sourcecode lenguage="bash"]
# $Id: latihan_pf,v 1.14 2010/04/25 07:24:21 muntaza Exp $
[/sourcecode]

Belajar FIREWALL dengan PF bagian I

Bismillah,
Pada kesempatan ini saya akan menulis tentang firewall, dan contoh penerapannya dari yang sederhana. semoga bermanfaat untuk saya pribadi khususnya, dan pengguna komputer pada umumnya. Saya sendiri menulis ini, agar  bila suatu hari saya lupa, saya bisa belajar lagi dari tulisan saya sendiri...


daftar isi
1. Apa itu Firewall
2. Firewall dengan satu mesin
3. Firewall sebagai router


1. APA ITU FIREWALL

Firewall adalah software pengaman jaringan lapis pertama yang berfungsi untuk mengizinkan atau memblok akses dari suatu alamat IP ke alamat IP tertentu. Fungsi yang sangat dasar sekali dan site tidak cukup dengan mengandalkan firewall saja, tapi perlu software tambahan lain. Firewall memberi keamaan 50% dari serangan, jadi lebih baik pakai firewall daripada tanpa firewall.

Dalam tulisan ini, saya menggunakan  PF sebagai contoh penggunaan. Rules Firewall yang saya tulis bukan untuk di "copy paste", jangan pernah meng "copy-paste" perintah apapun sebagai root dari tulisan manapun tanpa anda mengerti maksudnya.


2. FIREWALL DENGAN SATU MESIN

[sourcecode lenguage="bash"]
 [ Mesinku ] ste0 -------- ( Internet )
[/sourcecode] 

gambar diatas menunjukan sebuah mesin dengan interface ste0 terhubung langsung ke internet. 

Mesin ini mempunyai aturan, akses dari mesin ke internet diizinkan, sedang akses dari internet dilarang total.

[sourcecode lenguage="bash"]
-------/etc/pf.conf
block in
block out
pass out keep state

[/sourcecode] 

Rules filter pada PF dibaca dari atas ke bawah, dan rule terakhir yang menang. Makna rules diatas perbaris:

block in ----- blok akses masuk dari semua alamat IP
block out ---- blok akses keluar dari semua alamat IP
pass out keep state ---- izinkan akses keluar dari mesin ini dan izinkan balasannya masuk kembali (dengan kata kunci "keep state")

inilah aturan paling sederhana, sehingga Mesinku dapat browsing, mendownload, tapi semua mesin di internet tidak dapat masuk ke Mesinku.

sebagaimana diatas, rules filter PF dibaca dari atas kebawah, dan rule terakhir menang, maka jangan terbalik menulisnya, misalnya:

[sourcecode lenguage="bash"]
pass out keep state
block in
block out
[/sourcecode] 

baris pertama izinkan akses keluar dan izinkan balasannya masuk, tapi PF terus membaca rules berikutnya, yaitu baris kedua dan ketiga. Ketika PF membaca baris ketiga, yaitu "block out" yang bermakna, larang akses ke luar, maka PF melarang akses keluar, jadi baris pertama tidak berlaku lagi.

Jadi perhatikan dengan baik rules yang anda tulis, sesuaikan dengan aturan rule mana yang menang.

penyempurnaan rules pertama

[sourcecode lenguage="bash"]
-----/etc/pf.conf
set skip on lo

block in
block out
pass out keep state
[/sourcecode]

makna rules "set skip on lo" yaitu, aturan firewall tidak berlaku pada interface lo (interface khusus untuk internal networking di Mesinku)

proses blok dan pass bisa ditulis lebih spesifik pada interface tertentu, tujuan tertentu dan port tertentu, pada contoh ini adalah ste0

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
pass out on ste0 from any to any port 22 keep state
[/sourcecode]

kata kunci "any" bermakna semua IP
pass out pertama bermakna izinkan akses keluar dari Mesinku ke internet menuju port 80 di tujuan.
pass out kedua bermakna izinkan akses keluar dari Mesinku ke internet menuju port 22 di tujuan.

2.A Macro

Macro adalah penggunaan variable yang akan digunakan pada baris rules, untuk memudahkan penulisan. contoh dua baris dibawah ini:

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
pass out on ste0 from any to any port 22 keep state
[/sourcecode]

menjadi:

[sourcecode lenguage="bash"]
ext_if="ste0"
pass out on $ext_if from any to any port 80 keep state
pass out on $ext_if from any to any port 22 keep state
[/sourcecode]

pada saat pf membaca kata kunci diawali "$" ia akan mencari isi yang sesuai dengan macro yang di definisikan, misalnya contoh diatas, 

[sourcecode lenguage="bash"]
ext_if="ste0"
pass out on $ext_if from any to any port 80 keep state
[/sourcecode]

akan dibaca :

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
[/sourcecode]

hal ini memudahkan bila terjadi pergantian interface dari ste0 ke vr0 misalnya maka hanya perlu merubah -ext_if="ste0"- menjadi -ext_if="vr0"- 


2.B List

list adalah barisan yang akan di pecah satu-satu. Agak sulit saya menjelaskan dengan kata-kata, tapi dengan contoh semoga paham. misalnya

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
pass out on ste0 from any to any port 22 keep state
[/sourcecode]

maka bila digabung dengan list menjadi:

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port { 22 80 } keep state
[/sourcecode]

terlihat bahwa dua baris menjadi satu baris, tapi saat pf membaca rules diatas, akan di dijabarkan kembali menjadi dua baris yaitu

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
pass out on ste0 from any to any port 22 keep state
[/sourcecode]

2.C List pada Macro

macro yang mengandung list

misalnya

[sourcecode lenguage="bash"]
port_out="{ 22 80 }"
pass out on ste0 from any to any port $port_out keep state
[/sourcecode]

akan dijabarkan menjadi:

[sourcecode lenguage="bash"]
pass out on ste0 from any to any port 80 keep state
pass out on ste0 from any to any port 22 keep state
[/sourcecode]

terlihat bahwa untuk menambahkan port yang ingin kita akses, tinggal menambahkannya di macro port_out.

sekarang dengan pengetahuan kita tentang list, macro, kita update file firewall kita

[sourcecode lenguage="bash"]
-----/etc/pf.conf
#macro
ext_if="ste0"
port_out="{ 22 80 443 }"

#option
set skip on lo

#firewall
block in
block out
pass out on $ext_if from any to any port $port_out keep state
[/sourcecode]

saat PF membaca rules diatas, akan dijabarkan olehnya menjadi
1. skip on lo
2. block in from any to any
3. block out from any to any
4. pass out on ste0 from any to any port 22 keep state
5. pass out on ste0 from any to any port 80 keep state
6. pass out on ste0 from any to any port 443 keep state

artinya:
1. abaikan aturan pada lo
2. blok akses masuk dari luar
3. blok akses keluar dari dalam
4. izinkan akses dari dalam keluar ke port 22 dan izinkan balasannya masuk
5. izinkan akses dari dalam keluar ke port 80 dan izinkan balasannya masuk
6. izinkan akses dari dalam keluar ke port 443 dan izinkan balasannya masuk

rules ini telah cukup aman untuk sebuah mesin sendirian yang terkoneksi langsung ke internet dimana prinsip yang dipakai:
1. larang akses dari luar masuk ke dalam
2. izinkan akses dari dalam keluar


3. FIREWALL SEBAGAI ROUTER

[sourcecode lenguage="bash"]
    [PC_2]   [PC_1]
       |       |                             
LAN  --+---+---+--- vr0 [RouterKu] ste0 ---- (Internet)
           |                         
        [PC_3]    
[/sourcecode]

Gambar diatas adalah contoh implementasi dari PF sebagai software di router yang akan memberikan jalan bagi PC di LAN untuk konek ke internet dengan NAT dan router juga memberi keamanan lapis pertama berbasis firewall.

3.A NAT

NAT adalah suatu aturan yang membolehkan PC didalam LAN yang menggunakan IP private mengakses internet dengan meminjam IP public router. IP private yang tersedia adalah:
	10.0.0.0/8
	172.16.0.0/12 
	192.168.0.0/16
IP private tidak bisa mengakses internet secara langsung, tapi dengan NAT maka IP PC pada LAN di terjemahkan ke IP public router.

contoh penggunaannya 

[sourcecode lenguage="bash"]
ext_if="ste0"
nat on $ext_if from !($ext_if) -> ($ext_if:0)
[/sourcecode]
                       
yang artinya, lakukan nat pada ste0 dari selain alamat IP ste0 ke IP public yang ada di ste0. alamat IP selain alamat IP ste0 yaitu alamat IP di LAN

agar paket data dapat berpindah dari vr0 ke ste0, maka perlu di tambahkan baris ini di 

[sourcecode lenguage="bash"]
/etc/sysctl.conf :
net.inet.ip.forwarding=1
[/sourcecode]

lalu restart mesin RouterKu.

kita akan merubah aturan firewall pada file /etc/pf.conf agar PC di LAN dapat akses internet dengan prinsip:
1. semua PC pada LAN dapat mengakses internet
2. RouterKu dapat mengakses internet
3. Orang Lain di internet tidak dapat mengakses ke LAN dan RouterKu

Agar memudahkan setting, maka pada kali ini, saya akan memblok dari satu arah saja, yaitu dari luar masuk ke dalam. semua paket ketika telah berada di dalam dapat keluar. Tentu hal ini agak kurang nyaman, tapi pada kesempatan lain akan saya tulis Insya ALLAH tentang blok total dengan PF dan izinkan hanya pada yang perlu satu-satu.

[sourcecode lenguage="bash"]
-----/etc/pf.conf
#macro
int_if="vr0"
ext_if="ste0"
localnet="192.168.0.0/24"

#option
set skip on lo

#nat
nat on $ext_if from !($ext_if) -> ($ext_if:0)

#firewall
block in

pass out keep state
pass in on $int_if from $localnet to any
[/sourcecode]

baris:
[sourcecode lenguage="bash"]
nat on $ext_if from !($ext_if) -&gt; ($ext_if:0)
[/sourcecode]
bermakna seperti diatas yaitu lakukan nat agar PC di LAN dapat akses ke internet.

baris :
[sourcecode lenguage="bash"]
pass out keep state
[/sourcecode]

dijabarkan menjadi baris:
[sourcecode lenguage="bash"]
pass out on $ext_if from any to any keep state
pass out on $int_if from any to any keep state
[/sourcecode]

penulisan "pass out" tanpa "on interface" berarti pada semua interface.

maknanya:
izinkan paket yang sudah ada di router untuk keluar dari router.

baris:
[sourcecode lenguage="bash"]
pass in on $int_if from $localnet to any
[/sourcecode]

dibaca oleh PF menjadi:
[sourcecode lenguage="bash"]
pass in on vr0 from 192.168.0.0/24 to any
[/sourcecode]

bermakna:
izinkan paket masuk di interface vr0 dari IP LAN 192.168.0.0/24 ke Internet


