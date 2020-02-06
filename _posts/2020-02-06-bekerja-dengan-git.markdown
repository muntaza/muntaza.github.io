---
layout: post
title:  "Bekerja dengan Git"
date:   2020-02-06 12:26:56 +0800
categories: git
---

# Bismillah,

Catatan saya terkait git, sebagai pengingat di kemudian hari.

```text
```

```text
git clone
```

Clone repository

```text
git branch -a
```

lihat branch apa saja yang ada

```text
git checkout -b working
```

Buat branch working

```text
git branch -a
```

lihat branch apa yang aktif

```text
git push --set-upstream origin working
```

Upload branch working ke Github.com, perintah ini hanya sekali saja.


```text
git add .
git commit .
git add .
git commit . -m "Bekerja dengan Git"
```

Edit code dan commit.

```text
git branch -a
```
lihat branch apa yang aktif

```text
git push
```

Push ke branch working

```text
 2186  git checkout master
```

Pindah ke branch master

```text
 2187  git branch -a
```

lihat branch apa yang aktif

```text
 2188  git diff master working
```

Cek diff antar branch

# Merge squash

Pada Pilihan ini, branch working akan kita hapus setelah merge.

```text
 2209  git merge --squash working
```

Merge squash

```text
 2210  git commit .
```

Commit Merge squash, jangan gunakan __-m__ disini, agar bisa mengedit
pesan saat commit.

```text
 2211  git push
```

Push ke master

```text
 2212  git push -d origin working
```

Delete branch working di Github.com

```text
 2214  git branch -D working
```

Delete branch working di local

```text
 2215  git branch -a
```

lihat branch apa yang aktif





# Alhamdulillah
