---
layout: post
title:  "Bekerja dengan Git"
date:   2020-02-06 12:26:56 +0800
categories: git
---

# Bismillah,

Catatan saya terkait git, sebagai pengingat di kemudian hari.


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
vim _posts/2020-02-06-bekerja-dengan-git.markdown
git add .
git commit .
vim _posts/2020-02-06-bekerja-dengan-git.markdown
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
git checkout master
```

Pindah ke branch master

```text
git branch -a
```

lihat branch apa yang aktif

```text
git diff master working
```

Cek diff antar branch

# Merge squash

Pada Pilihan ini, branch working akan kita hapus setelah merge. Semua commit-commit
di satukan hanya menjadi satu commit saja.

```text
git merge --squash working
```

Merge squash

```text
git commit .
```

Commit Merge squash, jangan gunakan __-m__ disini, agar bisa mengedit
pesan saat commit.

```text
git push
```

Push ke master

```text
git push -d origin working
```

Delete branch working di Github.com

```text
git branch -D working
```

Delete branch working di local

```text
git branch -a
```

lihat branch apa yang aktif.


# Merge

Pada pilihan ini, commit-commit di working branch
di gabungkan dengan master branch, tanpa perlu menghapus working branch
setelah merge.

```text
git checkout -b working
```
Buat branch working

```text
git branch -a
```

lihat branch apa yang aktif.

```text
git push --set-upstream origin working
```

Upload branch working ke Github.com



```text
vim _posts/2020-02-06-bekerja-dengan-git.markdown
git commit .
git push
vim _posts/2020-02-06-bekerja-dengan-git.markdown
git commit . -m "Bekerja dengan Git"
```

Edit code dan commit.

```text
git push
```

Push ke branch working

```text
git checkout master
```

Pindah ke branch master.

```text
git diff master working
```

Cek diff antar branch master dan branch working.

```text
git merge working
```

Merge, semua commit dari branch working di gabungkan
ke branch master.

```text
git push
```

Push ke branch master di Github.com

```text
git checkout working
```

Selanjutnya, pindah lagi ke branch working, karena semua pekerjaan
dilakukan di branch working.

# Penutup

Saat pertama belajar git, lebih mudah hanya bekerja di branch master
saja, namun, sekarang saya mencoba belajar proses pembuatan branch
ini dan catatan ini adalah hasil proses belajar tersebut.
Semoga bermanfaat

# Alhamdulillah


# Daftar Pustaka

-   [Git: Workflow Basic](https://github.com/endymuhardin/belajarGit/blob/master/workflow-basic.md)
-   [Basic Git commands](https://www.atlassian.com/git/tutorials/svn-to-git-prepping-your-team-migration#basic-git-commands)
-   [git - the simple guide](http://rogerdudler.github.io/git-guide/)
-   [Git: Hello World](https://guides.github.com/activities/hello-world/)
