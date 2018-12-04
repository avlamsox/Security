#!/usr/bin/python
import hashlib
import sys

filename = sys.argv[1]

algo_list = []
algo_list = hashlib.algorithms_available

def common(hasher, filename):
	with open(filename, 'rb') as afile:
		buf = afile.read()
		hasher.update(buf)
	return hasher.hexdigest()
	
for algos in algo_list:
	hasher = hashlib.new(algos)
	print "Hash of [%s] Algorithm is [%s]" % (algos, common(hasher, filename))
