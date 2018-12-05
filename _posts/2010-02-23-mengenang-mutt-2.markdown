---
author: muntaza
comments: true
date: 2010-02-23 09:22:36+00:00
layout: post
link: https://muntaza.wordpress.com/2010/02/23/mengenang-mutt-2/
slug: mengenang-mutt-2
title: Mengenang Mutt 2
wordpress_id: 136
---

[sourcecode language="bash"]
ditulis oleh: Muhammad Muntaza bin Hatta, tanggal 29 safar 1431 H

Tulisan dibawah ini adalah kenangan masa muda saya yang suka menggunankan Mutt
sebagai email clien he..he..

dan disaat sudah agak tua ehm... kayaknya cukup thunderbird ajah. Kecuali ada
kesempatan dan waktu untuk belajar lagi.. he..he..

Mutt adalah email clien berbasis text. ketik mutt pada sheel untuk melihat
tampilannya...

bash-3.1$ mutt

==============================================================================
q:Quit  d:Del  u:Undel  s:Save  m:Mail  r:Reply  g:Group  ?:Help





---Mutt: /var/spool/mail/muntaza [Msgs:0]---(threads/date)------(all)---
==============================================================================


di menu utama, tekan m untuk menulis email, lalu tampil "To: " isi
dengan email tujuan misalnya fauzan@localhost, lalu "Subject: " isi
dengan test, lalu tampil editor dengan vi. Tulis pesan, save dengan ":x"

tampilan akhir nya macam ini di compi saya:

==============================================================================
y:Send  q:Abort  t:To  c:CC  s:Subj  a:Attach file  d:Descrip  ?:Help
From: Muahammad Muntaza bin Hatta <muntaza@pisang>
To: fauzan@localhost
Cc:
Bcc:
Subject: test
Reply-To:
Fcc: ~/.mutt/send-email
PGP: Sign
sign as: 0x0D20F23B

-- Attachments
-> - I     1 /tmp/mutt-pisang-6592-1         [text/plain, 7bit, us-ascii, 0.1K]




-- Mutt: Compose  [Approx. msg size: 0.1K   Atts: 1]----------------------
==============================================================================


tekan "y" untuk send mail.

saya login sebagai user fauzan, cek mail di mutt

==============================================================================
i:Exit  -:PrevPg  <Space>:NextPg v:View Attachm.  d:Del  r:Reply  j:Next ?:Help
Date: Sun, 14 Feb 2010 10:36:32 +0000
From: Muahammad Muntaza bin Hatta <muntaza@pisang.rumah.ku>
To: fauzan@pisang.rumah.ku
Subject: test
User-Agent: Mutt/1.4.2.3i

[-- PGP output follows (current time: Sun 14 Feb 2010 10:42:45 AM UTC) --]
gpg: Signature made Sun 14 Feb 2010 10:36:31 AM UTC using DSA key ID 0D20F23B
gpg: Good signature from "Muhammad Muntaza <m.muntaza@gmail.com>"
[-- End of PGP output --]

[-- The following data is signed --]

ini test

[-- End of signed data --]



- S - 4/5: Muahammad Muntaza bi   test                                 -- (all)
PGP signature successfully verified.
==============================================================================

sebagai user fauzan, kemudian reply email tadi, lalu pindah tab ke user muntaza
dan cek email di mutt, tampilannya macam ini:

==============================================================================
i:Exit  -:PrevPg  <Space>:NextPg v:View Attachm.  d:Del  r:Reply  j:Next ?:Help
->    1     Feb 14 Ahmad Fauzan 'A (   4) Re: test
---Mutt: /var/spool/mail/muntaza [Msgs:1 1.0K]---(threads/date)-------(all)---
Date: Sun, 14 Feb 2010 10:57:49 +0000
From: "Ahmad Fauzan 'Azhima" <fauzan@pisang.rumah.ku>
To: Muahammad Muntaza bin Hatta <muntaza@pisang.rumah.ku>
Subject: Re: test
In-Reply-To: <20100214103631.GA6592@pisang>
User-Agent: Mutt/1.4.2.3i

On Sun, Feb 14, 2010 at 10:36:32AM +0000, Muahammad Muntaza bin Hatta wrote:
> ini test
balasan




-   - 1/1: Ahmad Fauzan 'Azhima   Re: test                       -- (all)
==============================================================================


sekian, Walhamdu Lillah

[/sourcecode]
