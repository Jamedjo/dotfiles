#!/usr/bin/env python
import sys
normalt = "-n" in sys.argv[1:] or "--normalt" in sys.argv[1:]

for i in range(10 if normalt else 2):
    for j in range(30, 38):
        for k in range(40, 48):
            if normalt:
                print ("%d;%d;%d: \33[%d;%d;%dm Hello, World! \33[m " %
                    (i, j, k, i, j, k, ))
            else:
                print "\33[%d;%d;%dm%d;%d;%d\33[m " % (i, j, k, i, j, k),
        print 
