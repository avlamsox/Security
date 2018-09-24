import requests
from bs4 import BeautifulSoup

siteobj = requests.get("http://fc4.me")
html_doc = siteobj.text

soup = BeautifulSoup(html_doc, 'html.parser')

def getSecurityString(soup):
	data = str((soup.find_all('input', {'type':'image'})))
	m = data[43:]
	date = m.split(";")[0][:-1]
	print date
	return date
getSecurityString(soup)
print (soup.find_all('script', {'type':'src'}))
