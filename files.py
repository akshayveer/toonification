from os import listdir
from os.path import isfile, join
mypath="Te/"
onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]
ouputFile=open('myFunction.m','w');
for i in onlyfiles:
	a,b=i.split(".")
	ouputFile.write('toonification(\'Te/'+i+'\',\'myImages/'+a+'canny.png\')\n')
	# ouputFile.write('prewitt_bilateral(\'Te/'+i+'\',\'outputImages/'+a+'prewitt.png\')\n')
	# ouputFile.write('sobel_bilateral(\'Te/'+i+'\',\'outputImages/'+a+'sobel.png\')\n')
	# ouputFile.write('log_bilateral(\'Te/'+i+'\',\'outputImages/'+a+'log.png\')\n')

