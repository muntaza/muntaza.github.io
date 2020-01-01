---
layout: post
title:  "Instalasi Jekyll pada Arch Linux"
date:   2019-12-29 12:26:56 +0800
categories: jekyll
---

# Bismillah,

Catatan singkat instalasi jekyll pada Arch Linux. Pertama kita install dulu ruby
yang akan turut menginstall rubygem.

{% highlight text %}
$ sudo pacman -Syu ruby --needed
{% endhighlight %}

Kemudian, install Jekyll dengan rubygem.

{% highlight text %}
$ gem install jekyll
{% endhighlight %}


OK, jekyll sudah terinstall, lalu disini saya tuliskan daftar referensi untuk
menulis dengan _markdown_ yang digunakan untuk memformat tulisan di jekyll.
1.  [Jekyllrb: Posts](https://jekyllrb.com/docs/posts/)
2.  [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
3.  [Markdown Guide: Basic Syntax](https://www.markdownguide.org/basic-syntax)
4.  [Daring Fireball: Markdown Syntax](https://daringfireball.net/projects/markdown/syntax)

Sekian, semoga bermanfaat.

# Alhamdulillah
