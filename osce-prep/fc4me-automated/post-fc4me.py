import requests
import base64
from bs4 import BeautifulSoup
from capstone import *

siteobj = requests.get("http://fc4.me")
posturl = 'http://fc4.me/fc4me.php'
html_doc = siteobj.text

soup = BeautifulSoup(html_doc, 'html.parser')

def getSecurityString(soup):
	data = str((soup.find_all('input', {'type':'image'})))
	m = data[43:]
	date = m.split(";")[0][:-1]
	print date
	return date
getSecurityString(soup)

#print (soup.find_all('script', {'type':'src'}))

payload = {
    'email': 'abhijit.lamsoge@harman.com',
    'securitystring': '663fb72b68bb5edb2cda0feb40c463e4'
}

def getBase64Str():
	r = requests.post(posturl, data=payload)
	phtml_doc = r.text
	nsoup = BeautifulSoup(phtml_doc, 'html.parser')
	raw_base64 =  str(nsoup.findAll("blockquote")[0].renderContents())
	base64 = raw_base64.replace("<br/>","")	
	return base64

def decodeBase64(base64encoded):
	return str(base64.standard_b64decode(base64encoded))
	
def generate32BitAssembly(raw_shellcode):
	xcode = str(raw_shellcode.split(":")[3][1:])
	print xcode
	md = Cs(CS_ARCH_X86, CS_MODE_64)
	for i in md.disasm(xcode, 0x10000):
		print("0x%x:\t%s\t%s" % (i.address, i.mnemonic, i.op_str))

encoded = getBase64Str()
raw_shellcode = decodeBase64(encoded)
generate32BitAssembly(raw_shellcode)
