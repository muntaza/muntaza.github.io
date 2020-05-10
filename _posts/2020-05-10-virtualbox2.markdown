---
layout: post
title:  "VirtualBox dengan Command Line"
date:   2020-05-10 11:36:56 +0800
categories: virtualbox
---

# Bismillah,

Penggunaan VirtualBox tidak hanya terbatas pada tampilan GUI semata, namun mampu juga
berjalan pada system yang hanya menggunakan Command line. Sehingga memungkinkan untuk
mengcopy file hardisk VirtualBox dan menjalankannya di server lain dalam kondisi sudah ready.

# Start VirtualBox

Ini adalah script untuk memulai VirtualBox, berjalan di background:

```text
#!/bin/bash

#sudo sh ~/bin/ip_tap.sh
VBoxManage startvm CentOS_8_base --type headless
```

Pastikan bahwa interface internet nya sudah di setting.

# Save State VirtualBox

Ini script untuk menyimpan state VirtualBox, yang mana kita bisa menjalankan mesin virtual dengan lebih cepat karena tidak melalui proses booting lagi:

```text
#!/bin/bash

#paling cepat login lagi ...:)

VBoxManage controlvm CentOS_8_base savestate
```

# Memulai mesin virtual

```text
$ sh start_vm_CentOS.sh
Waiting for VM "CentOS_8_base" to power on...
VM "CentOS_8_base" has been successfully started.
```

Setelah server berjalan, kita tunggu sekitar 1 menit, karena proses booting, lalu kita coba login ssh dari terminal:

![virtualbox_cli0](/assets/virtualbox_cli/virtualbox_cli0.png)

# Save State mesin virtual

Setelah exit dari ssh, kita stop mesin virtual dengan menyimpan kondisi nya (save state), sehingga bisa di sambung kembali (resume) nantinya.

```text
$ sh save_state_vm_CentOS.sh
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

Nah, posisi saat ini sudah tersimpan, sehingga tidak bisa di ssh lagi. Kemudian, saat akan memulai kembali, jalankan perintah start lagi, maka kita bisa ssh lebih cepat:

```text
$ sh start_vm_CentOS.sh
Waiting for VM "CentOS_8_base" to power on...
VM "CentOS_8_base" has been successfully started.
```

# Penutup

Nah, begitulah gambarannya terkait menjalankan VirtualBox dari Command line, adapun penjelasan perintah VBoxManage bisa di lihat dengan perintah man:

```text
$ man VBoxManage
```

Semoga tulisan ini bermanfaat. Aamiin.

# Alhamdulillah
