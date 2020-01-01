---
layout: post
title:  "Recovery OpenOffice Base file"
date:   2010-01-31 13:26:56 +0800
categories: openoffice
---

# Bismillah,

This is a record of my experience, were damaged at the base openoffice files, called odb. files are created with OpenOffice 3.0 and can not be opened. My solution follows:

{% highlight text %}
muntaza@pisang:~/recover$ ls
contoh.odb*
muntaza@pisang:~/recover$ du -h contoh.odb
1.1M contoh.odb
muntaza@pisang:~/recover$ cp contoh.odb contoh_back_up.odb
muntaza@pisang:~/recover$ ls
contoh.odb* contoh_back_up.odb*
muntaza@pisang:~/recover$ mv contoh.odb contoh.zip
muntaza@pisang:~/recover$ unzip contoh.zip
Archive: contoh.zip
End-of-central-directory signature not found. Either this file is not
a zipfile, or it constitutes one disk of a multi-part archive. In the
latter case the central directory and zipfile comment will be found on
the last disk(s) of this archive.
{% endhighlight %}

note: contoh.zip may be a plain executable, not an archive  
unzip: cannot find zipfile directory in one of contoh.zip or
contoh.zip.zip, and cannot find contoh.zip.ZIP, period.

{% highlight text %}
muntaza@pisang:~/recover$

muntaza@pisang:~/recover$ zip -FF contoh.zip > /dev/null
muntaza@pisang:~/recover$ ls
contoh.zip* contoh_back_up.odb*
muntaza@pisang:~/recover$ mv contoh.zip contoh.odb
muntaza@pisang:~/recover$ du -h contoh.odb
700K contoh.odb
muntaza@pisang:~/recover$
{% endhighlight %}

Explanation:
1. This file is damaged, 1.1MB in size, make back_up this file
2. change the name of the file . odb to .zip
3. test unzip contoh.zip files, it errors (a sign of damaged zip files)
4. fix zip files with the command “zip -FF nama_file.zip”
5. return .zip to .odb

# Alhamdulillah
