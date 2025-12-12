---
layout: post
title:  "Keamanan Sever Linux"
date:   2025-12-07 04:26:56 +0800
categories: server
---

# Bismillah,

Tulisan ini adalah catatan saya sekitar lebih dari 3 tahun yang lalu. Saya baru sekarang
bisa memposting nya ke blog saya ini.

Sebelumnya saya pernah menulis [Langkah Penting Setelah Instalasi OpenBSD](https://www.muntaza.id/openbsd/ssh/2018/12/09/public-key-only-ssh-openbsd.html)
dan [Instalasi SPSE v4.3 pada CentOS 7](https://www.muntaza.id/centos7/2019/06/02/instalasi_spse_v4.html). Kedua tulisan tersebut sebagai referensi pada tulisan saya kali ini.

IP Public disamarkan, sehingga terlihat xxx.yyy pada bagian depan IP Public tersebut.
Sever yang di gunakan adalah AlmaLinux 8, versi terbaru pada saat itu, sekitar bulan September 2022.

# Upgrade

Sesudah proses instalasi, tentu saja upgrade sistem, ini contoh proses upgrade nya. Versi sebelum di upgrade adalah 8.4 kemudian setelah di upgrade menjadi 8.6.

```text
$ ssh root@xxx.yyy.183.103
root@xxx.yyy.183.103's password:
Last login: Thu Sep 29 05:29:47 2022 from xx.yy.58.112
[root@postgres ~]#

[root@postgres ~]# cat /etc/redhat-release
AlmaLinux release 8.4 (Electric Cheetah)

[root@postgres ~]# uname -a
Linux postgres 4.18.0-305.3.1.el8_4.x86_64 #1 SMP Wed Jun 2 03:19:21 EDT 2021 x86_64 x86_64 x86_64 GNU/Linux

[root@postgres ~]# dnf update
Install   10 Packages
Upgrade  236 Packages

Total download size: 421 M
Is this ok [y/N]:y

Complete!
[root@postgres ~]# cat /etc/redhat-release
AlmaLinux release 8.6 (Sky Tiger)
[root@postgres ~]# uname -a
Linux postgres 4.18.0-305.3.1.el8_4.x86_64 #1 SMP Wed Jun 2 03:19:21 EDT 2021 x86_64 x86_64 x86_64 GNU/Linux
[root@postgres ~]#
```

# SSH

Akses ke server dengan ssh yang hanya menggunakan publickey authentication. 
Buat ssh private-public key dari Local Computer. Waktu itu saya menggunakan aplikasi MINGW64.


```text
$ ssh-keygen.exe
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/Mtp/.ssh/id_rsa):
/c/Users/Mtp/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/Mtp/.ssh/id_rsa.
Your public key has been saved in /c/Users/Mtp/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:G3zzV/shJvQPVro+HdYdxMx9ZNC44oyRXPYVD4EYP/4 User+Mtp@User
The key's randomart image is:
+---[RSA 3072]----+
|          .o .BB=|
|          ..+ .B*|
|         . +o..oo|
|       .  +...o. |
|        S o*.. .=|
|         +oo+.o++|
|        .  ..BEo.|
|            +o=.o|
|            .o...|
+----[SHA256]-----+

User+Mtp@User MINGW64 /
$
```

Agar bisa login ke server, tentu di perlukan user di sisi server, berikut contoh
pembuatan user _muntaza_ di server, masuk kan user tersebut ke group wheel agar bisa
melakukan _sudo_.


```text
[root@postgres ~]# useradd muntaza
[root@postgres ~]# passwd muntaza
Changing password for user muntaza.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
[root@postgres ~]# cat /etc/group | grep wheel
wheel:x:10:
[root@postgres ~]# usermod muntaza -G muntaza,wheel
[root@postgres ~]# cat /etc/group | grep wheel
wheel:x:10:muntaza
[root@postgres ~]# su - muntaza
[muntaza@postgres ~]$ sudo su
[sudo] password for muntaza:
[root@postgres muntaza]# exit
exit
[muntaza@postgres ~]$
```

Buat direktori .ssh di server
```text
[muntaza@postgres ~]$ mkdir .ssh
[muntaza@postgres ~]$ chmod go-rwx .ssh
[muntaza@postgres ~]$ ls -ld .ssh/
drwx------. 2 muntaza muntaza 6 Sep 29 05:58 .ssh/
[muntaza@postgres ~]$
```

Copy Public key dari local
```text
$ scp ~/.ssh/id_rsa.pub muntaza@xxx.yyy.183.103:/home/muntaza/.ssh/authorized_keys
```

Test koneksi dari local
```text
$ ssh muntaza@xxx.yyy.183.103
Last login: Thu Sep 29 05:56:30 2022
[muntaza@postgres ~]$
```

Atur agar koneksi ssh hanya bisa dengan publickey authentication. Disini di perlihatkan setting apa saja pada file sshd_config yang perlu di sesuaikan serta ujicoba file sshd_config dengan perintah _sshd -t_ sebelum sshd (server ssh) di restart.

```text
[muntaza@postgres ssh]$ sudo cp sshd_config sshd_config_old
[sudo] password for muntaza:
[muntaza@postgres ssh]$ sudo vi sshd_config

PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
GSSAPIAuthentication no

[muntaza@postgres ssh]$ sudo diff sshd_config sshd_config_old
82c82
< GSSAPIAuthentication no
---
> GSSAPIAuthentication yes
144,145c144,145
< PasswordAuthentication no
< PermitRootLogin no
---
> PasswordAuthentication yes
> PermitRootLogin yes

[muntaza@postgres ssh]$ sudo sshd -t
[muntaza@postgres ssh]$ echo $?
0
[muntaza@postgres ssh]$
[muntaza@postgres ssh]$ sudo systemctl restart sshd
[muntaza@postgres ssh]$ exit
logout
Connection to xxx.yyy.183.103 closed.
```

Contoh test koneksi dari Local Computer dengan user muntaza dan berhasil, kemudian contoh koneksi dengan user latihan yang tidak terdaftar serta root maka tidak berhasil, karena koneksi hanya bisa dengan publickey authentication.


```text
User+Mtp@User MINGW64 ~
$ ssh muntaza@xxx.yyy.183.103
Last login: Thu Sep 29 06:04:00 2022 from xx.yy.58.112
[muntaza@postgres ~]$ exit
logout
Connection to xxx.yyy.183.103 closed.

User+Mtp@User MINGW64 ~
$ ssh latihan@xxx.yyy.183.103
latihan@xxx.yyy.183.103: Permission denied (publickey).

User+Mtp@User MINGW64 ~
$ ssh root@xxx.yyy.183.103
root@xxx.yyy.183.103: Permission denied (publickey).

User+Mtp@User MINGW64 ~
$
```

# Firewall

Sumber penulisan ada di [sini](https://www.muntaza.id/nftables/2020/01/30/nftables-keempat.html). Saya download dulu
configurasi nftables dengan git dari repository github saya:

```text
[muntaza@postgres ~]$ sudo dnf install git
[muntaza@postgres ~]$ git clone https://github.com/muntaza/Firewall
Cloning into 'Firewall'...
remote: Enumerating objects: 214, done.
remote: Counting objects: 100% (40/40), done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 214 (delta 14), reused 31 (delta 8), pack-reused 174
Receiving objects: 100% (214/214), 100.91 KiB | 2.52 MiB/s, done.
Resolving deltas: 100% (107/107), done.
[muntaza@postgres ~]$
```

Masuk ke folder nftables
```text
[muntaza@postgres ~]$ cd Firewall/nftables
```

Sebelum menjalankan nftables, saya cek dulu apakah ada software firewall lain yang tersedia. Terlihat bahwa tidak ada firewall lain di server ini:

```text
[muntaza@postgres nftables]$ sudo systemctl status nftables
Unit nftables.service could not be found.
[muntaza@postgres nftables]$ sudo systemctl status iptables
Unit iptables.service could not be found.
[muntaza@postgres nftables]$ sudo systemctl status firewalld
Unit firewalld.service could not be found.
```

Baik, bahkan nftables pun belum tersedia, kemudian saya install nftables:


```text
[muntaza@postgres nftables]$ sudo dnf install -y nftables
Complete!
```

Aktifkan nftables, tentu dengan konfigurasi default.

```text
[muntaza@postgres nftables]$ sudo systemctl status nftables
? nftables.service - Netfilter Tables
   Loaded: loaded (/usr/lib/systemd/system/nftables.service; disabled; vendor preset: disable>
   Active: inactive (dead)
     Docs: man:nft(8)
[muntaza@postgres nftables]$

[muntaza@postgres nftables]$ sudo systemctl enable nftables
Created symlink /etc/systemd/system/multi-user.target.wants/nftables.service ? /usr/lib/systemd/system/nftables.service.
[muntaza@postgres nftables]$ sudo systemctl start nftables
[muntaza@postgres nftables]$ sudo systemctl status nftables
? nftables.service - Netfilter Tables
   Loaded: loaded (/usr/lib/systemd/system/nftables.service; enabled; vendor preset: disabled)
   Active: active (exited) since Thu 2022-09-29 07:04:05 UTC; 4s ago
     Docs: man:nft(8)
  Process: 21461 ExecStart=/sbin/nft -f /etc/sysconfig/nftables.conf (code=exited, status=0/S>
 Main PID: 21461 (code=exited, status=0/SUCCESS)

Sep 29 07:04:05 postgres systemd[1]: Starting Netfilter Tables...
Sep 29 07:04:05 postgres systemd[1]: Started Netfilter Tables.
[muntaza@postgres nftables]$
```

Rubah konfigurasi nftables [level 4](https://www.muntaza.id/nftables/2020/01/30/nftables-keempat.html)

```text
[muntaza@postgres nftables]$ ls
ip6_indonesia.conf  ip_output.conf         nftables_level_1.conf  nftables_level_4.conf
ip6_output.conf     nftables.conf          nftables_level_2.conf  README.md
ip_indonesia.conf   nftables_level_0.conf  nftables_level_3.conf
[muntaza@postgres nftables]$ sudo cp *.conf /etc
[muntaza@postgres nftables]$ sudo cp /etc/nftables_level_4.conf /etc/sysconfig/nftables.conf
[muntaza@postgres nftables]$ sudo nft list ruleset
[muntaza@postgres nftables]$ sudo systemctl restart nftables
```

Cek isi konfigurasi yang aktif saat ini:

```text
[muntaza@postgres nftables]$ sudo nft list ruleset | tail -20
        chain INPUT {
                type filter hook input priority filter; policy drop;
                ct state established,related accept
                iifname "lo" accept
                ip6 saddr @ip6_indonesia tcp dport { 22, 80, 443 } ct state new accept
                drop
        }

        chain FORWARD {
                type filter hook forward priority filter; policy drop;
        }

        chain OUTPUT {
                type filter hook output priority filter; policy drop;
                ct state established,related accept
                oifname "lo" accept
                ip6 daddr @ip6_output accept
                drop
        }
}
[muntaza@postgres nftables]$
```

Test ping keluar:

```text
[muntaza@postgres nftables]$ ping www.google.com
PING www.google.com(si-in-f147.1e100.net (2404:6800:4003:c04::93)) 56 data bytes
^C
--- www.google.com ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4075ms

[muntaza@postgres nftables]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=13.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=13.1 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 13.067/13.166/13.265/0.099 ms
```

# Chronyd

Izinkan NTP Client untuk koneksi keluar menuju ke NTP server. NTP Client di AlmaLinux ini adalah Chronyd. 
Daftar NTP server wilayah Indonesia ada di [sini](https://www.pool.ntp.org/zone/id). Setting nftables level 4 hanya mengizinkan
daftar IP public yang terdaftar yang bisa di akses dari server. Oleh karena itu, kita cek dan kita rekap dulu daftar IP public
tersebut:

```text
[muntaza@postgres ~]$ host 0.id.pool.ntp.org
0.id.pool.ntp.org has address 119.110.74.102
0.id.pool.ntp.org has address 162.159.200.1
0.id.pool.ntp.org has address 203.160.128.59
0.id.pool.ntp.org has address 14.102.153.110
[muntaza@postgres ~]$ host 0.id.pool.ntp.org
0.id.pool.ntp.org has address 162.159.200.1
0.id.pool.ntp.org has address 14.102.153.110
0.id.pool.ntp.org has address 203.160.128.59
0.id.pool.ntp.org has address 119.110.74.102
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$ host 0.id.pool.ntp.org >> file
[muntaza@postgres ~]$
[muntaza@postgres ~]$ cat file | awk {'print $4'} | sort | uniq
103.28.56.14
119.110.74.102
14.102.153.110
162.159.200.1
202.65.114.202
203.160.128.59
36.91.114.86
[muntaza@postgres ~]$
```

Tampilan setting Chronyd:

```text
[muntaza@postgres nftables]$ head /etc/chrony.conf
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
#pool 2.cloudlinux.pool.ntp.org iburst
pool 0.id.pool.ntp.org iburst

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
[muntaza@postgres nftables]$
```

Jalankan Chronyd dan cek status nya sebelum daftar IP public server NTP di tambahkan pada setting nftables:

```text
[muntaza@postgres nftables]$ sudo systemctl restart chronyd
[muntaza@postgres nftables]$ sudo systemctl status chronyd
Sep 29 07:23:52 postgres systemd[1]: chronyd.service: Succeeded.
Sep 29 07:23:52 postgres systemd[1]: Stopped NTP client/server.
Sep 29 07:23:52 postgres systemd[1]: Starting NTP client/server...
Sep 29 07:23:52 postgres chronyd[21625]: chronyd version 4.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +S>
Sep 29 07:23:52 postgres chronyd[21625]: Frequency 29.874 +/- 0.083 ppm read from /var/lib/chrony/drift
Sep 29 07:23:52 postgres chronyd[21625]: Using right/UTC timezone to obtain leap second data
Sep 29 07:23:52 postgres systemd[1]: Started NTP client/server.
```

Chronyd tidak dapat melakukan koneksi keluar. Baik, sekarang saya tambahkan daftar IP public tersebut ke file ip_output.conf yang merupakan white list atau daftar IP public yang di izinkan di akses oleh server.


```text
[muntaza@postgres nftables]$ cat /etc/ip_output.conf
        set ip_output {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { 8.8.4.4, 8.8.8.8,
                             128.31.0.63,
                                103.28.56.14,
                                119.110.74.102,
                                14.102.153.110,
                                162.159.200.1,
                                202.65.114.202,
                                203.160.128.59,
                                36.91.114.86,
                             128.61.240.73, 128.101.240.215,
                             149.20.4.14, 151.101.10.133,
                             200.17.202.197, 212.211.132.250,
                             217.196.149.233 }
        }
[muntaza@postgres nftables]$
```

Kemudian saya restart nftables, restart Chronyd dan cek status Chronyd:

```text
[muntaza@postgres nftables]$ sudo systemctl restart nftables
[muntaza@postgres nftables]$ sudo systemctl restart chronyd
[muntaza@postgres nftables]$ sudo systemctl status chronyd
? chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2022-09-29 07:31:45 UTC; 18s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 21702 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exited, status=0/SUCCESS)
  Process: 21711 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 21706 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 21709 (chronyd)
    Tasks: 1 (limit: 5959)
   Memory: 936.0K
   CGroup: /system.slice/chronyd.service
           +-21709 /usr/sbin/chronyd

Sep 29 07:31:45 postgres systemd[1]: chronyd.service: Succeeded.
Sep 29 07:31:45 postgres systemd[1]: Stopped NTP client/server.
Sep 29 07:31:45 postgres systemd[1]: Starting NTP client/server...
Sep 29 07:31:45 postgres chronyd[21709]: chronyd version 4.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +S>
Sep 29 07:31:45 postgres chronyd[21709]: Frequency 29.874 +/- 0.087 ppm read from /var/lib/chrony/drift
Sep 29 07:31:45 postgres chronyd[21709]: Using right/UTC timezone to obtain leap second data
Sep 29 07:31:45 postgres systemd[1]: Started NTP client/server.
Sep 29 07:31:50 postgres chronyd[21709]: Selected source 14.102.153.110 (0.id.pool.ntp.org)
Sep 29 07:31:50 postgres chronyd[21709]: System clock TAI offset set to 37 seconds
```

Terlihat bahwa Chronyd sudah dapat koneksi keluar sesuai IP public yang di definisi kan. Jangan malas untuk repot di awal, yaitu selalu menambah list IP public yang dapat di akses server, karena manfaat nya sangat luar biasa, yaitu server tidak dapat koneksi ke sembarang IP public di internet. Saya jelaskan hal tersebut pada tulisan terkait [nftables](https://www.muntaza.id/nftables/2020/01/30/nftables-keempat.html).

# CHATTR

keterangan bisa dilihat pada [man page](https://man7.org/linux/man-pages/man1/chattr.1.html) nya. Fungsi chattr ini menambah _sedikit_ keamanan pada file yang di setting. Dibawah ini contoh penggunaan nya:


```text
[muntaza@postgres nftables]$ sudo lsattr -ld /etc/ssh
[sudo] password for muntaza:
/etc/ssh                     ---
[muntaza@postgres nftables]$ sudo chattr -R +i /etc/ssh
[muntaza@postgres nftables]$ sudo lsattr -ld /etc/ssh
/etc/ssh                     Immutable
[muntaza@postgres nftables]$ sudo lsattr -l /etc/ssh
/etc/ssh/moduli              Immutable
/etc/ssh/ssh_config          Immutable
/etc/ssh/ssh_config.d        Immutable
/etc/ssh/ssh_host_ed25519_key Immutable
/etc/ssh/ssh_host_ed25519_key.pub Immutable
/etc/ssh/ssh_host_ecdsa_key  Immutable
/etc/ssh/ssh_host_ecdsa_key.pub Immutable
/etc/ssh/ssh_host_rsa_key    Immutable
/etc/ssh/ssh_host_rsa_key.pub Immutable
/etc/ssh/sshd_config_old     Immutable
/etc/ssh/sshd_config         Immutable
[muntaza@postgres nftables]$
```


# AIDE

AIDE ini berfungsi untuk mendeteksi perubahan pada server, perubahan konfigurasi walau menambah satu tanda titik pun akan
terdeteksi, insyaAllah.

Agar dapat melakukan instalasi software AIDE, maka nftables perlu di turunkan ke level 2 lebih dahulu.

```text
[muntaza@postgres nftables]$ sudo nft -f /etc/nftables_level_2.conf
[muntaza@postgres nftables]$ sudo dnf install -y aide
Complete!
```

Setelah AIDE terinstall, saya kembalikan nftables ke level 4

```text
[muntaza@postgres nftables]$ sudo systemctl restart nftables
```

Konfigurasi awal AIDE 

```text
[muntaza@postgres ~]$ sudo su
[sudo] password for muntaza:
[root@postgres muntaza]# aide --init
Start timestamp: 2022-09-29 08:19:41 +0000 (AIDE 0.16)
AIDE initialized database at /var/lib/aide/aide.db.new.gz

Number of entries:      40748

---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.new.gz
  MD5      : rxdmMXiAxD1yJxm7YaVFlQ==
  SHA1     : rpKYb/1/NRJEbCTayjCESY6nYnQ=
  RMD160   : wgoRkHAjPp9X3y2mm0UhyzR1PVA=
  TIGER    : F9arTaU0aWaDY6LDQHPZRJW7tuyzbAmX
  SHA256   : MUL3xlX5VMv/uYffnKAqoupmgi0zdH6r
             4knlZnrCK/I=
  SHA512   : QIucVUApuA4erZmXw/yDg73MfMPeAXw5
             St5Iyr4nNltbY5i6XzidDvsosd+fdywP
             CXBRw5DoMka9II0bDYtfiQ==


End timestamp: 2022-09-29 08:20:07 +0000 (run time: 0m 26s)

[root@postgres muntaza]# exit
exit
```

Saya copy file database AIDE ke home folder user muntaza.

```text
[muntaza@postgres ~]$ sudo cp /var/lib/aide/aide.db.new.gz .
[muntaza@postgres ~]$ ls
aide.db.new.gz  file  Firewall
[muntaza@postgres ~]$ ls -l
total 2324
-rw-------. 1 root    root    2374497 Sep 29 08:22 aide.db.new.gz
-rw-rw-r--. 1 muntaza muntaza    1590 Sep 29 07:20 file
drwxrwxr-x. 9 muntaza muntaza     141 Sep 29 06:57 Firewall
[muntaza@postgres ~]$ sudo chown muntaza aide.db.new.gz
[muntaza@postgres ~]$ ls -l
total 2324
-rw-------. 1 muntaza root    2374497 Sep 29 08:22 aide.db.new.gz
-rw-rw-r--. 1 muntaza muntaza    1590 Sep 29 07:20 file
drwxrwxr-x. 9 muntaza muntaza     141 Sep 29 06:57 Firewall
[muntaza@postgres ~]$
```


Dari Local Computer, saya download file database AIDE untuk arsip.

```text
$ scp muntaza@xxx.yyy.183.103:~/aide.db.new.gz .
```

Percobaan pertama, saat tidak ada perubahan apapun, saya melakukan pengecekan:

```text
[muntaza@postgres ~]$ sudo aide --check
Start timestamp: 2022-09-29 08:27:57 +0000 (AIDE 0.16)
AIDE found NO differences between database and filesystem. Looks okay!!

Number of entries:      40748

---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.gz
  MD5      : rxdmMXiAxD1yJxm7YaVFlQ==
  SHA1     : rpKYb/1/NRJEbCTayjCESY6nYnQ=
  RMD160   : wgoRkHAjPp9X3y2mm0UhyzR1PVA=
  TIGER    : F9arTaU0aWaDY6LDQHPZRJW7tuyzbAmX
  SHA256   : MUL3xlX5VMv/uYffnKAqoupmgi0zdH6r
             4knlZnrCK/I=
  SHA512   : QIucVUApuA4erZmXw/yDg73MfMPeAXw5
             St5Iyr4nNltbY5i6XzidDvsosd+fdywP
             CXBRw5DoMka9II0bDYtfiQ==


End timestamp: 2022-09-29 08:28:26 +0000 (run time: 0m 29s)
[muntaza@postgres ~]$
```

Terlihat bahwa AIDE menyampaikan bahwa tidak ada perubahan apapun di sistem. Sekarang saya mau melakukan setting localtime, 
kebetulan sebelumnya saya lupa melakukan nya.

```text
[muntaza@postgres ~]$ date
Fri Sep 30 07:21:57 UTC 2022
[muntaza@postgres ~]$ ls -l /etc/localtime
lrwxrwxrwx. 1 root root 25 Jun  9  2021 /etc/localtime -> ../usr/share/zoneinfo/UTC
[muntaza@postgres ~]$ sudo rm /etc/localtime
[muntaza@postgres ~]$ sudo ln -s /usr/share/zoneinfo/Asia/Makassar /etc/localtime
[muntaza@postgres ~]$ ls -l /etc/localtime
lrwxrwxrwx. 1 root root 33 Sep 30 15:22 /etc/localtime -> /usr/share/zoneinfo/Asia/Makassar
[muntaza@postgres ~]$ date
Fri Sep 30 15:22:54 WITA 2022
[muntaza@postgres ~]$
```

Saya juga mengedit Crontab, yaitu aplikasi penjadwalan, untuk melakukan cek sistem dengan AIDE setiap hari. Hasil pengecekan
akan di simpan di folder home user muntaza.


```text
[muntaza@postgres ~]$ which aide
/usr/sbin/aide
[muntaza@postgres ~]$
[muntaza@postgres ~]$ date -u
Fri Sep 30 07:47:55 UTC 2022
[muntaza@postgres ~]$
[muntaza@postgres ~]$ sudo crontab -l
# Jalankan AIDE setiap hari sekali jam 7:47 UTC
47      7       *       *       *       /usr/sbin/aide --check >> /home/muntaza/aide
[muntaza@postgres ~]$
```

Setelah Crontab berjalan, saya bisa cek hasilnya.

```text
[muntaza@postgres ~]$ cat /home/muntaza/aide
Start timestamp: 2022-09-30 15:47:01 +0800 (AIDE 0.16)
AIDE found differences between database and filesystem!!

Summary:
  Total number of entries:      40749
  Added entries:                1
  Removed entries:              0
  Changed entries:              2

---------------------------------------------------
Added entries:
---------------------------------------------------

f++++++++++++++++: /var/spool/cron/root

---------------------------------------------------
Changed entries:
---------------------------------------------------

l   ...    .  .S : /etc/localtime
f           C    : /var/spool/anacron/cron.daily

---------------------------------------------------
Detailed information about changes:
---------------------------------------------------

Link: /etc/localtime
  SELinux  : system_u:object_r:locale_t:s0    | unconfined_u:object_r:locale_t:s
                                              | 0

File: /var/spool/anacron/cron.daily
  SHA512   : j5idCL3Umns6UpCNelY/KUHnpyt0ir6s | mMb+OOMGPlh58/SmB+EkRxw9+iPjBGZB
             u5oToEMTRtlXqDYpSv7D/NRqBCDi6dAo | U5YrjtLXcxNvNhNGTHCr30afX16jXtb/
             dxZSKk2uEp+uL5L/un8Z6Q==         | RDdyzqau0tFLZpsiabivaQ==


---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.gz
  MD5      : rxdmMXiAxD1yJxm7YaVFlQ==
  SHA1     : rpKYb/1/NRJEbCTayjCESY6nYnQ=
  RMD160   : wgoRkHAjPp9X3y2mm0UhyzR1PVA=
  TIGER    : F9arTaU0aWaDY6LDQHPZRJW7tuyzbAmX
  SHA256   : MUL3xlX5VMv/uYffnKAqoupmgi0zdH6r
             4knlZnrCK/I=
  SHA512   : QIucVUApuA4erZmXw/yDg73MfMPeAXw5
             St5Iyr4nNltbY5i6XzidDvsosd+fdywP
             CXBRw5DoMka9II0bDYtfiQ==


End timestamp: 2022-09-30 15:47:28 +0800 (run time: 0m 27s)
[muntaza@postgres ~]$
```

Terlihat telah terjadi perubahan pada sistem, yaitu file _localtime_ dan file _cron.daily_. Itulah manfaat AIDE. Kemudian, dibawah ini saya contoh kan rebuild database AIDE.

```text
[muntaza@postgres ~]$ sudo aide --init
Start timestamp: 2022-09-30 15:49:53 +0800 (AIDE 0.16)
AIDE initialized database at /var/lib/aide/aide.db.new.gz

Number of entries:      40749

---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.new.gz
  MD5      : QDCBMBaulanXTZfj+2s7vg==
  SHA1     : LhVT1lMQt+n/isbh7NvMhEWQ2xM=
  RMD160   : A5M5T8qI6FMt2RL+1RErMlSuzkE=
  TIGER    : kYlye3WDInLpNKHKqM4188rfCaTeOXLZ
  SHA256   : esyRabKxE6RdKIKriQqMYIHaKXrehpG6
             nZwCMgQbLxI=
  SHA512   : InmcmRJhsrNyAsFl6yCcx0TNNSBZ/M7v
             dOPZ/d96z0/oWgHjkuBMMQURf3s3I0Nf
             wkxAz+6NTT9eWJlQlDzZwg==


End timestamp: 2022-09-30 15:50:21 +0800 (run time: 0m 28s)
[muntaza@postgres ~]$ sudo cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
[muntaza@postgres ~]$
```

Saya lakukan cek ulang sistem:

```text
[muntaza@postgres ~]$ sudo /usr/sbin/aide --check
Start timestamp: 2022-09-30 15:51:21 +0800 (AIDE 0.16)
AIDE found NO differences between database and filesystem. Looks okay!!

Number of entries:      40749

---------------------------------------------------
The attributes of the (uncompressed) database(s):
---------------------------------------------------

/var/lib/aide/aide.db.gz
  MD5      : QDCBMBaulanXTZfj+2s7vg==
  SHA1     : LhVT1lMQt+n/isbh7NvMhEWQ2xM=
  RMD160   : A5M5T8qI6FMt2RL+1RErMlSuzkE=
  TIGER    : kYlye3WDInLpNKHKqM4188rfCaTeOXLZ
  SHA256   : esyRabKxE6RdKIKriQqMYIHaKXrehpG6
             nZwCMgQbLxI=
  SHA512   : InmcmRJhsrNyAsFl6yCcx0TNNSBZ/M7v
             dOPZ/d96z0/oWgHjkuBMMQURf3s3I0Nf
             wkxAz+6NTT9eWJlQlDzZwg==


End timestamp: 2022-09-30 15:51:48 +0800 (run time: 0m 27s)
[muntaza@postgres ~]$
```

Terlihat bahwa database yang baru sudah menampung perubahan file _localtime_ dan file _cron.daily_. Baik, kemudian saya download
ulang database AIDE terbaru ke Local Computer.

```text
$ scp muntaza@xxx.yyy.183.103:~/aide*.gz .
```

Demikian contoh penggunaan AIDE.

# LOG

Penting bagi admin untuk memantau kondisi server dari file-file log.
Setelah server berjalan beberapa hari, ternyata ada percobaan serangan brute force ke server ssh. Namun karena ssh hanya menerima publickey authentication, maka serangan ini dapat digagalkan. Ini contoh hasil pengecekan dari file _secure_ di folder log:


```text
Oct  9 18:38:00 postgres sshd[29754]: Invalid user wlh from 180.250.169.98 port 51876
Oct  9 18:38:00 postgres sshd[29767]: Invalid user tom from 180.250.169.98 port 52042
Oct  9 18:38:00 postgres sshd[29759]: Invalid user dmdba from 180.250.169.98 port 51958
Oct  9 18:38:00 postgres sshd[29764]: Invalid user andrek from 180.250.169.98 port 51960
Oct  9 18:38:00 postgres sshd[29758]: Invalid user ly from 180.250.169.98 port 51878
Oct  9 18:38:00 postgres sshd[29755]: Invalid user carlos from 180.250.169.98 port 51884
Oct  9 18:38:00 postgres sshd[29765]: Invalid user ansible from 180.250.169.98 port 51996
Oct  9 18:38:00 postgres sshd[29771]: Invalid user ansadmin from 180.250.169.98 port 52012
Oct  9 18:38:00 postgres sshd[29762]: Invalid user vagrant from 180.250.169.98 port 51968
Oct  9 18:38:00 postgres sshd[29756]: Invalid user zimbra from 180.250.169.98 port 51932
Oct  9 18:38:00 postgres sshd[29757]: Connection closed by authenticating user root 180.250.169.98 port 51898 [preauth]
Oct  9 18:38:00 postgres sshd[29759]: Connection closed by invalid user dmdba 180.250.169.98 port 51958 [preauth]
Oct  9 18:38:00 postgres sshd[29767]: Connection closed by invalid user tom 180.250.169.98 port 52042 [preauth]
Oct  9 18:38:00 postgres sshd[29754]: Connection closed by invalid user wlh 180.250.169.98 port 51876 [preauth]
Oct  9 18:38:00 postgres sshd[29758]: Connection closed by invalid user ly 180.250.169.98 port 51878 [preauth]
Oct  9 18:38:00 postgres sshd[29764]: Connection closed by invalid user andrek 180.250.169.98 port 51960 [preauth]
Oct  9 18:38:00 postgres sshd[29769]: Connection closed by authenticating user root 180.250.169.98 port 52020 [preauth]
Oct  9 18:38:00 postgres sshd[29765]: Connection closed by invalid user ansible 180.250.169.98 port 51996 [preauth]
Oct  9 18:38:00 postgres sshd[29771]: Connection closed by invalid user ansadmin 180.250.169.98 port 52012 [preauth]
Oct  9 18:38:00 postgres sshd[29755]: Connection closed by invalid user carlos 180.250.169.98 port 51884 [preauth]
Oct  9 18:38:00 postgres sshd[29762]: Connection closed by invalid user vagrant 180.250.169.98 port 51968 [preauth]
Oct  9 18:38:00 postgres sshd[29756]: Connection closed by invalid user zimbra 180.250.169.98 port 51932 [preauth]
Oct  9 18:38:00 postgres sshd[29772]: Invalid user account1 from 180.250.169.98 port 52054
Oct  9 18:38:00 postgres sshd[29776]: Invalid user testuser2 from 180.250.169.98 port 52098
Oct  9 18:38:00 postgres sshd[29775]: Invalid user bharat from 180.250.169.98 port 52080
Oct  9 18:38:00 postgres sshd[29768]: Invalid user subbu from 180.250.169.98 port 51974
Oct  9 18:38:00 postgres sshd[29774]: Invalid user spotlight from 180.250.169.98 port 52044
Oct  9 18:38:00 postgres sshd[29778]: Invalid user server from 180.250.169.98 port 52118
Oct  9 18:38:00 postgres sshd[29773]: Invalid user admin from 180.250.169.98 port 52006
Oct  9 18:38:00 postgres sshd[29777]: Invalid user git from 180.250.169.98 port 52104
Oct  9 18:38:00 postgres sshd[29776]: Connection closed by invalid user testuser2 180.250.169.98 port 52098 [preauth]
Oct  9 18:38:00 postgres sshd[29768]: Connection closed by invalid user subbu 180.250.169.98 port 51974 [preauth]
Oct  9 18:38:00 postgres sshd[29775]: Connection closed by invalid user bharat 180.250.169.98 port 52080 [preauth]
Oct  9 18:38:00 postgres sshd[29772]: Connection closed by invalid user account1 180.250.169.98 port 52054 [preauth]
Oct  9 18:38:00 postgres sshd[29801]: Invalid user zjw from 180.250.169.98 port 52184
Oct  9 18:38:00 postgres sshd[29796]: Invalid user ly from 180.250.169.98 port 52126
Oct  9 18:38:00 postgres sshd[29798]: Invalid user es from 180.250.169.98 port 52150
Oct  9 18:38:00 postgres sshd[29797]: Invalid user zimbra from 180.250.169.98 port 52142
Oct  9 18:38:00 postgres sshd[29800]: Connection closed by authenticating user root 180.250.169.98 port 52168 [preauth]
Oct  9 18:38:00 postgres sshd[29774]: Connection closed by invalid user spotlight 180.250.169.98 port 52044 [preauth]
Oct  9 18:38:00 postgres sshd[29773]: Connection closed by invalid user admin 180.250.169.98 port 52006 [preauth]
Oct  9 18:38:00 postgres sshd[29777]: Connection closed by invalid user git 180.250.169.98 port 52104 [preauth]
Oct  9 18:38:00 postgres sshd[29796]: Connection closed by invalid user ly 180.250.169.98 port 52126 [preauth]
Oct  9 18:38:00 postgres sshd[29801]: Connection closed by invalid user zjw 180.250.169.98 port 52184 [preauth]
Oct  9 18:38:00 postgres sshd[29797]: Connection closed by invalid user zimbra 180.250.169.98 port 52142 [preauth]
Oct  9 18:38:00 postgres sshd[29778]: Connection closed by invalid user server 180.250.169.98 port 52118 [preauth]
Oct  9 18:38:00 postgres sshd[29798]: Connection closed by invalid user es 180.250.169.98 port 52150 [preauth]
```

# Penutup

Ketika catatan ini dibuat sekitar 3 tahun lalu, saya merencanakan membuat Mail Server untuk mengirim hasil crontab ke email admin, sehingga
admin akan dapat mendeteksi kalau ada masalah dengan cepat, namun hal itu tidak sempat saya lakukan.

Demikian tulisan ini, saya edit dari sebuat catatan, menambah keterangan yang dianggap perlu. Semoga bermanfaat bagi admin server linux. Aamiin

# Alhamdulillah
