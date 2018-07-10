#!/usr/bin/python
import sys
arg = sys.argv[1]
removedhex = repr(arg).translate(None,r'\\x')
lenofshellcode = len(removedhex)

print lenofshellcode
