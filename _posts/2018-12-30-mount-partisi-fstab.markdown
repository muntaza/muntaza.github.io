---
layout: post
title:  "Mount Partisi Secara Otomatis di Linux"
date:   2018-12-30 12:26:56 +0800
categories: linux fstab
---

# Bismillah,

Pada Linux Mint 19.1 yang saya gunakan, User biasa dapat melakukan mount pada
partisi yang tersedia. Namun, karena saya ingin agar salah satu partisi
telah ter-mount saat booting, maka saya memilih mengedit file /etc/fstab.

File /etc/fstab ini sangat vital bagi system Linux, sehingga kalau terjadi
salah edit, Linux nya bisa jadi gagal booting.

Nah, kita coba mount partisi tersebut dari File Manager dulu, untuk melihat
UUID-nya.

{% highlight bash %}
muntaza@E202SA:~$ mount | grep media
/dev/sda5 on /media/muntaza/67cf12b2-b88f-4726-9f5d-61faa90cb86b type ext4 (rw,nosuid,nodev,relatime,data=ordered,uhelper=udisks2)
muntaza@E202SA:~$
{% endhighlight %}

Terlihat UUID-nya, type partisinya yaitu ext4, dan berada di device /dev/sda5.

OK, kita edit file /etc/fstab, tambahkan 2 baris berikut ini:

{% highlight bash %}
# /dev/sda5
UUID=67cf12b2-b88f-4726-9f5d-61faa90cb86b    /mnt/sda5    ext4     defaults        0       0
{% endhighlight %}


Proses unmount, testing mount /mnt/sda5 terlihat pada perintah di bawah ini:

{% highlight bash %}
muntaza@E202SA:~$ mount| grep media
/dev/sda5 on /media/muntaza/67cf12b2-b88f-4726-9f5d-61faa90cb86b type ext4 (rw,nosuid,nodev,relatime,data=ordered,uhelper=udisks2)
muntaza@E202SA:~$
muntaza@E202SA:~$ sudo umount /dev/sda5
muntaza@E202SA:~$
muntaza@E202SA:~$ sudo mkdir /mnt/sda5
muntaza@E202SA:~$
muntaza@E202SA:~$ cat /etc/fstab | tail -2
# /dev/sda5
UUID=67cf12b2-b88f-4726-9f5d-61faa90cb86b    /mnt/sda5    ext4     defaults        0       0
muntaza@E202SA:~$
muntaza@E202SA:~$ sudo mount /mnt/sda5
muntaza@E202SA:~$
muntaza@E202SA:~$ mount | grep sda5
/dev/sda5 on /mnt/sda5 type ext4 (rw,relatime,data=ordered)
muntaza@E202SA:~$

{% endhighlight %}


Nah, terlihat hasil proses edit file /etc/fstab tidak masalah, dan partisi
/dev/sda5 bisa di mount dengan selamat. Saatnya Reboot.



# Alhamdulillah
