#!/usr/bin/python
import os
import subprocess
import sys

dir_path = sys.argv[1] + "/"
directory_arr = []
for filename in os.listdir(dir_path):
	print filename
	directory_arr.append(filename)

def run_flawfinder(directory_arr):
	for path in directory_arr:
		print dir_path + path
		p = subprocess.Popen(["flawfinder",dir_path + path],stdout=subprocess.PIPE)
		filename = path + '-static-analysis'
		out = p.stdout.read()
		f = open(filename, 'w')
		print >> f, out
		p.wait()

run_flawfinder(directory_arr)
