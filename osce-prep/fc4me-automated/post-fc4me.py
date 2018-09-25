import requests
import base64
import hashlib
from bs4 import BeautifulSoup
from capstone import *

emailaddress = raw_input("Enter Official Email Address:> ")
siteobj = requests.get("http://fc4.me")
posturl = 'http://fc4.me/fc4me.php'
html_doc = siteobj.text

soup = BeautifulSoup(html_doc, 'html.parser')

def acquireSecureString(soup):
	print "Acquiring Security String - Stage - 1 CTP Challenge Started"
	oscestr = "tryharder"
	data = str((soup.find_all('input', {'type':'image'})))
	m = data[43:]
	date = m.split(";")[0][:-1]
	print "[+] Today's Date is [[%s]] or srvstr from FC4.me Server" % date
	secstr1 = oscestr + date
	secstr = hashlib.md5(secstr1.encode()).hexdigest()
	return secstr

def getBase64Str():
	payload = {
	    'email': emailaddress,
	    'securitystring': securityString
	}
	r = requests.post(posturl, data=payload)
	phtml_doc = r.text
	nsoup = BeautifulSoup(phtml_doc, 'html.parser')
	raw_base64 =  str(nsoup.findAll("blockquote")[0].renderContents())
	base64 = raw_base64.replace("<br/>","")	
	return base64

def decodeBase64(base64encoded):
	return str(base64.standard_b64decode(base64encoded))

def acquireRegistrationCode(raw_shellcode):
	return str(raw_shellcode.split("|")[0])
		
def generate32BitAssembly(raw_shellcode):
	xcode = str(raw_shellcode.split(":")[3][1:])
	md = Cs(CS_ARCH_X86, CS_MODE_64)
	print "/----------------------Starting to Dump X86-32 Bit Assembly Code-----------------------/"
	for i in md.disasm(xcode, 0x10000):
		print("0x%x:\t%s\t%s" % (i.address, i.mnemonic, i.op_str))
	print "/****************************Dump Finished****************************/"

securityString = acquireSecureString(soup)
print "[+] Your Security String for CTP Challenge 1 is [[%s]]" % securityString
encoded = getBase64Str()
raw_shellcode = decodeBase64(encoded)
print "[+] Registration code for CTP is [[%s]]" % (acquireRegistrationCode(raw_shellcode))
generate32BitAssembly(raw_shellcode)
