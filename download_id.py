from selenium import webdriver


#browser = webdriver.Chrome('/Users/rachelungar/Documents/SeniorPt1/Lab/chromedriver') #replace with .Firefox(), or with the browser of your choice

browser = webdriver.PhantomJS('/Users/rachelungar/Documents/SeniorPt1/Lab/phantomjs-2.1.1-macosx/bin/phantomjs'); #must have PhantomJS installed: http://phantomjs.org/download.html
url = "https://www.ncbi.nlm.nih.gov/nuccore/672238970"
browser.get(url) #navigate to the page
htmlSource=browser.page_source
print(htmlSource)
