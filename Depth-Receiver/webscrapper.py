import requests
from bs4 import BeautifulSoup

url_path = ('https://sea.wave.oregonstate.edu/LWF')
html_text = requests.get(url_path).text
soup= BeautifulSoup(html_text, 'lxml')

soupArray = soup.prettify().split('\n');


line = soupArray[237]

start = 0
end = 0

for index, char in enumerate(reversed(line)):
    if char == ',':
        start = int(index)
        print(start)
        break


for index, char in enumerate(reversed(line)):
    if char in '0123456789':
        end = int(index)
        print(end)
        break

startInt = len(line) - start
endInt = len(line) - end

print(startInt)
print(endInt)

print(line[startInt : endInt])