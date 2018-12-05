---
author: muntaza
comments: true
date: 2009-07-07 02:57:35+00:00
layout: post
link: https://muntaza.wordpress.com/2009/07/07/pengalaman-install-slackware-12-2/
slug: pengalaman-install-slackware-12-2
title: Pengalaman Install Slackware 12.2
wordpress_id: 77
categories:
- linux
---




Dibuat ringkas sebagai catatan pribadi, siapa tau lupa nantinya he.. he.., sebagai referensi juga bagi pengguna linux lain, bukan tutorial...............!




-







Menurutku Slackware untuk pengguna linux 6 bulan keatas, bukan untuk pemula yang baru pakai linux dibawah 6 bulan.




-







Beli DVD Slackware 12.2 di toko penjual DVD linux di Internet, pada instalasi kali ini aku pakai DVD-2 bonus Infolinux bulan April 2009.




-







Tahapan Instalasi:




-




siapkan partisi (minimal 5,6GB), aku pilih /dev/sda10, format dengan ext3, pilih kelompok paket, aku memilih semua kecuali dukungan bahasa internasional, install dengan pilihan "full"










selesai install, aku skip instal lilo, karena aku punya grub pada Mandriva 2009.0 ku he..he..










-




exit dari menu setup, lalu aku mesti buat initrd nih, caranya:




# chroot /mnt /bin/bash




# cd /boot




# cat README.initrd | grep mkinitrd | grep ext3




mkinitrd -c -k 2.6.27.4-smp -m mbcache:jbd:ext3 -f ext3 -r /dev/hdb3










-




nah, itu dia perintah yang harus aku pakai untuk membuat initrd:







# ls /lib/modules/




2.6.27.7 2.6.27.7-smp




# mkinitrd -c -k 2.6.27.7-smp -m mbcache:jbd:ext3 -f ext3 -r /dev/sda10










-




cek initrd tadi:







# cd initrd-tree/




# cd lib/modules/2.6.27.7-smp/




# ls -R | grep ko




mbcache.ko




ext3.ko




jbd.ko







okeh, dah beres kayaknya...




-










# rm vmlinuz




# ln -s vmlinuz-generic-smp-2.6.27.7-smp vmlinuz










selesai sudah urusan instalasi slackware 12.2 nya, kini urusan boot loadernya lagi. Mandriva ada pada /dev/sda6




-







# mkdir /mnt/sda6




# mount /dev/sda6 /mnt/sda6/




# cd /mnt/sda6/boot/grub/










edit file menu.lst, ku tambahkan 3 baris berikut:







title slackware




kernel (hd0,9)/boot/vmlinuz




initrd (hd0,9)/boot/initrd.gz







-




yah... reboot







# reboot










------------------------------------------------------------------------




Booting... lagi. login sebagai root







# adduser muntaza







isi disesuaikan, kecuali pada additional Unit group, kutambahkan "wheel"







# visudo







%wheel ALL=(ALL) ALL




(hapus tanda komentar "#", agar group wheel dapat menggunakan sudo)













-




Mengkonfigurasi X







# cd




# Xorg -configure




# cp xorg.conf.new /etc/X11/




# cd /etc/X11/




# mv xorg.conf xorg.conf_old




# mv xorg.conf.new xorg.conf




# exit










-




login lagi sebagai user muntaza, lalu masuk ke kde







$ startx







Alhamdulillah bisa masuk KDE, ku cek pemakaian memory dengan top, hasilnya:




Mem: 1025156k total, 481700k used, 543456k free, 88108k buffers







------------------------------------------------------------------------













Wallahu Ta'ala A'lam




