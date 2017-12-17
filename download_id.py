from selenium import webdriver


#browser = webdriver.Chrome('/Users/rachelungar/Documents/SeniorPt1/Lab/chromedriver') #replace with .Firefox(), or with the browser of your choice
#num="672238970"
browser = webdriver.PhantomJS('/Users/rachelungar/Documents/SeniorPt1/Lab/phantomjs-2.1.1-macosx/bin/phantomjs'); #must have PhantomJS installed: http://phantomjs.org/download.html
url = "https://www.ncbi.nlm.nih.gov/nuccore/"
#browser.get(url) #navigate to the page
#htmlSource=browser.page_source
#print(htmlSource)
extension="_output.txt"

with open("tax.txt") as f:
	for line in f:
		new_url=url+line
		browser.get(new_url)
		htmlSource=browser.page_source
		nf=open(line+extension,"w")
		nf.write(htmlSource)
		nf.close()
		#print(new_url)
