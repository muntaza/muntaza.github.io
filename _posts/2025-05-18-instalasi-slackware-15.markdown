---
layout: post
title:  "Instalasi Slackware 15.0"
date:   2025-05-18 01:26:56 +0800
categories: slackware
---

# Bismillah,

Setelah tulisan saya sebelum nya tentang [Slackware 15](http://muntaza.github.io/linux/2022/05/07/slackware-15-0.html) yang mana
saya ketika itu belum sempat menginstall nya berhubung kesibukan saya saat itu. Kemudian, saya berkesempatan menginstall
Slackware 15.0, namun belum sempat menuliskan blog catatan tentang proses instalsi tersebut. Nah, pada kesempatan ini, saya 
menampilkan apa yang sempat saya catat, semoga catatan ini bermanfaat.

Adapun terkait slackware, saya pribadi sebenarnya sudah menggunakan nya sejak versi 10.0 yaitu sekitar
[20 tahun](https://www.mail-archive.com/tanya-jawab@linux.or.id/msg24560.html) yang lalu, 
namun kemudian sekitar tahun 2016 saya berpindah ke linux mint.

# Verifikasi 

Baik, kembali instalasi Slackware, sebagaimana biasa hal pertama yang dilakukan setelah download iso adalah
melakukan verifikasi hasil download.

```text
$ gpg --keyserver-options auto-key-retrieve --verify slackware64-15.0-install-dvd.iso.asc 
gpg: assuming signed data in 'slackware64-15.0-install-dvd.iso'
gpg: Signature made Fri 04 Feb 2022 03:48:57 AM WITA
gpg:                using DSA key 6A4463C040102233
gpg: Good signature from "Slackware Linux Project <security@slackware.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: EC56 49DA 401E 22AB FA67  36EF 6A44 63C0 4010 2233
```

Kemudian, dilakukan proses copy ke USB, pastikan tidak salah memilih posisi USB, karena kesalahan 
dalam hal ini bisa menyebabkan seluruh data di hardisk hilang total. Pada kondisi saya, hardisk berada
di /dev/sda dan flash disk berada di /dev/sdb. Ini contoh perintah *dd* untuk meng copy file iso
ke flash disk:

```text
# dd if=slackware64-15.0-install-dvd.iso of=/dev/sdb status=progress
3779744256 bytes (3,8 GB, 3,5 GiB) copied, 604 s, 6,3 MB/s 
7383872+0 records in
7383872+0 records out
3780542464 bytes (3,8 GB, 3,5 GiB) copied, 604,334 s, 6,3 MB/s
```

# Instalasi ...

Selanjutnya proses instalasi. Saya memilih kernel hugesmp.s dengan cara mengetik hugesmp.s pada
boot menu. Proses partisi menggunakan cfdisk. Buat partisi minimal untuk:
1. /
2. swap

dan lebih baik kalau ada partisi khusus untuk /home dan /tmp. Dalam pemilihan kelompok paket, saya 
memilih semuanya kecuali KDE. Saya memohon maaf karena belum bisa menampilkan foto-foto proses instalasi
ini.

# Login

Login dengan akun root, konfigurasi *suda*, kemudian buat akun user biasa, lalu login dengan akun user biasa tersebut.
Agar masuk ke desktop *xfce*, konfigurasi file .xinitrc seperti berikut:

```text
$ echo "exec startxfce4" > .xinitrc
```

kemudian masuk ke menu desktop xfce dengan mengetik:

```text
$ startx 
```

# Wireless

Selanjutnya mengconfigurasi wireless, yaitu untuk menampilkan icon jaringan:

```text
$ sudo chmod +x /etc/rc.d/rc.networkmanager
$ sudo /etc/rc.d/rc.networkmanager start 
```

# Slackpkg

Agar proses ungrade paket utama mudah, gunakan slackpkg, langkahnya sebagai berikut:
1. Setting mirror  
    ```text
    $ sudo vi /etc/slackpkg/mirrors
    ```
    Pastikan hanya satu mirror yang di pilih, cek mirror terpilih dengan cara:
    ```text
    $ cat /etc/slackpkg/mirrors | grep -v \#
    ```

2. Update data paket      
    ```text
    $ sudo /usr/sbin/slackpkg check-updates
    ```

3. Update salah satu paket    
    Pada contoh ini, saya melakukan update paket firefox
    ```text
    $ sudo /usr/sbin/slackpkg install mozilla-firefox
    ```

Demikian contoh penggunaan slackpkg, silahkan baca manual nya untuk lebih lanjut dengan cara
```text
man slackpkg
```

# Slackbuilds

Saya menginstall paket tambahan dengan slackbuilds, beberapa diantara adalah:
1. LibreOffice 
2. Dropbox
3. Pass

pada contoh di bawah ini, saya hanya menampilkan proses instalsi dropbox dengan script dari slackbuilds, yaitu:
1. Download script nya dan download paket dropbox nya
    ```text
    bash-5.1$ wget -c https://slackbuilds.org/slackbuilds/15.0/network/dropbox.tar.gz
    bash-5.1$ tar -xzvf dropbox.tar.gz
    bash-5.1$ cd dropbox
    bash-5.1$ 
    bash-5.1$ ls
    README	   dropbox.SlackBuild  dropbox.info  folders   slack-desc
    doinst.sh  dropbox.desktop     dropbox.png   policies
    bash-5.1$ 
    bash-5.1$ wget -c https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x86_64-223.4.4909.tar.gz
    ```

2. Jalankan script slackbuilds nya
    ```text
    bash-5.1$ sudo sh dropbox.SlackBuild
    ```

3. Install paket yang di hasilkan
    ```text
    bash-5.1$ sudo /sbin/installpkg /tmp/dropbox-223.4.4909-x86_64-1_SBo.tgz
    ```

Demikian contoh penggunaan slackbuilds untuk instalasi paket-paket yang tidak tersedia pada distribusi Slackware 15.0 ini.

# Firewall

Tentu tidak lupa setting firewall [sederhana](http://muntaza.github.io/nftables/2019/12/15/nftables-01.html) dengan nftables. 
Contoh script nftables sebagai berikut:

```text
#!/usr/sbin/nft -f

flush ruleset

define lo_if  = "lo"

table ip filter {
	chain INPUT {
		type filter hook input priority 0; policy drop;
		ct state established,related accept
		iifname $lo_if accept
		drop
	}

	chain FORWARD {
		type filter hook forward priority 0; policy drop;
		drop
	}

	chain OUTPUT {
		type filter hook output priority 0; policy accept;
	}
}
```

Aktifkan dengan cara mengedit file /etc/rc.d/rc.local

# Penutup

Demikian apa yang bisa saya tuliskan sebagai catatan proses instalasi slackware 15.0, semoga bisa bermanfaat.

# Alhamdulillah
