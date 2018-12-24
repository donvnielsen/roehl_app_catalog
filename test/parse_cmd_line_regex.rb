require 'pp'

regex = /^(?:"([^"]+(?="))|([^\s]+))["]{0,1} *(.+)?$/

pp regex.match('"c:\this\program to run.exe" -a -b')
pp regex.match('"c:/this/program to run.exe" -a -b')
pp regex.match('c:\this\program.exe -a -b')
pp regex.match('c:/this/program.exe -a -b')
pp regex.match('c:\this\program.exe ')
pp regex.match('c:/this/program.exe ')
pp regex.match('c:\this\program.exe')
pp regex.match('c:/this/program.exe')