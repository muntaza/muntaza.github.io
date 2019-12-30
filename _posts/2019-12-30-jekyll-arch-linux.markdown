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

Sekian, semoga bermanfaat.

# Alhamdulillah
