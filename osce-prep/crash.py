#!/usr/bin/python
import os
import sys
import subprocess

if not sys.argv[1] and sys.argv[2] and sys.argv[3] :
	print "Usage:- crash.py <execname> <String> <no-of-reps>"
	exit(1)
execname = sys.argv[1]
execpath = (os.getcwd() + "/") + execname
prog_arg = sys.argv[2]
prog_arg_size = int(sys.argv[3])
crash_arg = prog_arg * prog_arg_size

def crash_program(execpath, crash_arg):
	print execpath, crash_arg
	arg = subprocess.Popen([execpath, crash_arg], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	arg.communicate()
	arg.wait()
	if arg.returncode == -11:
		print "Segmentation Fault (code dumped)"
	elif arg.returncode == -4:
		print "Illegal Instructions"
	elif arg.returncode == 0:
		print "Program Exitted Correctly"
	else:
		print "No idea", arg.returncode
crash_program(execpath, crash_arg)
