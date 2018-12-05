---
author: muntaza
comments: true
date: 2014-12-06 06:30:59+00:00
layout: post
link: https://muntaza.wordpress.com/2014/12/06/auto-shutdown-openbsd-5-6-when-battery-is-critical-with-python/
slug: auto-shutdown-openbsd-5-6-when-battery-is-critical-with-python
title: Auto Shutdown OpenBSD 5.6 when Battery is critical with Python
wordpress_id: 435
categories:
- OpenBSD
- Python
tags:
- Openbsd
---

Bismillah,

Today, I will try to write in english, sorry for my bad english, he..he...

this is my script, I run it with cron every 3 minute, that script is check capasity of battery, if it less than 15%, exec /sbin/halt -p

[code language="python"]
#!/usr/local/bin/python

import os
from subprocess import Popen
from subprocess import PIPE
from subprocess import call

total = os.popen('sysctl hw.sensors.acpibat0.watthour0 | cut -b 31-35')
sisa = os.popen('sysctl hw.sensors.acpibat0.watthour3 | cut -b 31-35')

persen = round(100 * (float(sisa.read(5)) / float(total.read(5))), 2)
print 'sisa baterai ', persen, '%'

p1 = Popen(["sysctl", "hw.sensors.acpibat0"], stdout=PIPE)
p2 = Popen(["grep", "discharging"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
output = p2.communicate()[0]

if output and (persen < 15):
    print "SHUTDOWN 15%"
    call(["/sbin/halt", "-p"])

if persen < 5:
    print "SHUTDOWN 5%"
    call(["/sbin/halt", "-p"])
[/code]


add to crontab:
[sourcecode languange="sh" wraplines="false"]
*/3   *   *   *   *    /home/muntaza/bin/cek_shutdown.py
[/sourcecode]

I also add to my /etc/rc.local, to shutdown my laptop at boot time, if it not connect to AC Adaptor and less than 15% of capasity battery

[sourcecode languange="sh" wraplines="false"]
/home/muntaza/bin/cek_shutdown.py
[/sourcecode]

In my mine, using python for is more fun than shell script, he..he..



I rewrite my script, and use python 3:
[code language="python"]
#!/usr/local/bin/python3.3

from subprocess import Popen, PIPE, call

p1 = Popen(["sysctl", "hw.sensors.acpibat0.watthour0"], stdout=PIPE)
p2 = Popen(["cut", "-b", "31-35"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()
full_capacity = p2.communicate()[0]

p1 = Popen(["sysctl", "hw.sensors.acpibat0.watthour3"], stdout=PIPE)
p2 = Popen(["cut", "-b", "31-35"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()
remaining_capacity = p2.communicate()[0]

p1 = Popen(["sysctl", "hw.sensors.acpibat0"], stdout=PIPE)
p2 = Popen(["grep", "discharging"], stdin=p1.stdout, stdout=PIPE)
p1.stdout.close()
discharging = p2.communicate()[0]

percent = round(100 * (float(remaining_capacity) / float(full_capacity)), 2)
print('battery lifetime', percent, '%')

if discharging and (percent < 15):
    print ("SHUTDOWN 15%")
    call(["/sbin/halt", "-p"])

if percent < 5:
    print ("SHUTDOWN 5%")
    call(["/sbin/halt", "-p"])
[/code]

And this is script use apm to cek battery:
[code language="bash"]
#!/bin/ksh

charger=`apm -a`
battery=`apm -l`

echo -n "battery lifetime "; echo -n $battery; echo " %"

if [[ $battery -le 15 && $charger == 0 ]]; then
    echo "Shutdown 15%"
    /sbin/halt -p
elif [ $battery -le 5 ]; then
    echo "Shutdown 5%"
    /sbin/halt -p
fi
[/code]

Walhamdulillah
