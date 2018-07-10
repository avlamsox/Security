#!/usr/bin/python
import os
import subprocess
import sys

filename = sys.argv[1] + ".c"
exec_name = sys.argv[1]

def compile_shellcode():
	print exec_name
	p = subprocess.Popen(["gcc -g -fno-stack-protector -zexecstack ",filename + " -o " + exec_name],stdout=subprocess.PIPE)
	out = p.stdout.read()
	print >> f, out
	p.wait()

compile_shellcode()
