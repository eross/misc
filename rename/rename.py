import re
import os
mypath="."
from os import listdir
from os.path import isfile, join
onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]
for i in onlyfiles:
	r=re.match('^(\d\d)( .*)',i)
	if r:
		print "rename %s to %s" % (i, '0'+r.group(1)+r.group(2))
		os.rename(i,'0'+r.group(1)+r.group(2))

