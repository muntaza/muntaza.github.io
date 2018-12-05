---
author: muntaza
comments: true
date: 2010-02-23 09:19:35+00:00
layout: post
link: https://muntaza.wordpress.com/2010/02/23/back-up-data-dengan-rsync/
slug: back-up-data-dengan-rsync
title: Back up data dengan rsync
wordpress_id: 133
categories:
- kisah muhammad muntaza
- linux
---

[sourcecode language="bash"]
Catatan tentang back_up file penting dengan rsync, script di tempatkan dibawah direktori ~/bin

bash-3.1$ cd bin/
bash-3.1$ pwd
/home/muntaza/bin

Script Back_up ke flash disk

bash-3.1$ cat rsync_muntaza.sh
#!/bin/bash
echo "-------------------------------start-----------------------"
date
rsync -rltvz --delete /home/muntaza/Muntaza_Linux /media/MUNTAZA2
echo "-------------------------------end-------------------------"

Script Back up ke disk computer

bash-3.1$ cat rsync_to_disk.sh
#!/bin/bash

echo "---------------------------start-----------------------------"
date
rsync -avz --delete /home/muntaza/Muntaza_Linux /home/muntaza/data
echo "-------------------------------------------------------------"

Cron untuk jadwal back up

bash-3.1$ crontab -e
bash-3.1$ crontab -l
6 9-16/2 * * * /home/muntaza/bin/rsync_to_disk.sh >> /home/muntaza/lap.rsync

Laporan hasil back up

bash-3.1$ cat ~/lap.rsync
---------------------------start-----------------------------
Sun Feb 14 09:06:01 UTC 2010
sending incremental file list

sent 88192 bytes  received 744 bytes  59290.67 bytes/sec
total size is 252641954  speedup is 2840.72
-------------------------------------------------------------

Test Manual Back up ke flash

bash-3.1$ ./rsync_muntaza.sh
-------------------------------start-----------------------
Sun Feb 14 09:43:40 UTC 2010
sending incremental file list
Muntaza_Linux/blog/
Muntaza_Linux/blog/back up data dengan rsync
Muntaza_Linux/blog/back up data dengan rsync~

sent 89836 bytes  received 787 bytes  181246.00 bytes/sec
total size is 252650868  speedup is 2787.93
-------------------------------end-------------------------




catatan:
1. untuk back up ke flash, karena menggunakan filesystem fat, jadi tidak mendukung option -goDp, sehingga tidak bisa langsung dengan option -avz, tapi hanya -rltvz
2. untuk back up ke disk, karena disk pakai ext4, maka rsync bisa dengan option -avz
3. option --delete, menghapus file/dir tujuan yang sudah tidak ada di sumber.
4. mengedit cron dengan perintah crontab -e
5. menampilkan daftar cron job dengan crontab -l
6. laporan hasil sync ada di ~/lap.rsync
7. PENTING: rsync diatas tidak menyertakan option --update, maka sumber akan selalu di syn kan dengan tujuan, bila ada perubahan pada file/dir tujuan, akan di delete dan digantikan file lama di sumber.

ditulis tanggal 29 Safar 1431 H, oleh Muhammad Muntaza bin Hatta

sumber:
bash-3.1$ man rsync
bash-3.1$ man crontab

[/sourcecode]
