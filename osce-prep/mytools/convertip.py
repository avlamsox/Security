#!/usr/bin/python
import binascii
import socket
import sys

ip = sys.argv[1]
hexedip =  binascii.hexlify(socket.inet_aton(ip))
print hexedip
