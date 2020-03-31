from binascii import unhexlify
keycode= "fcfdeac0baece8fdfbbdf7beefb9fbf6bdc0bab9f7e8f2fde8f2fc"
hexkeycode = unhexlify(keycode)

password = []

for byte in hexkeycode:
    hbyte = byte.encode('hex')
    #print int(hbyte, 16)
    intbyte = int(hbyte, 16) - 137
    #print chr(intbyte)
    password.append(chr(intbyte))

print ''.join(password)

