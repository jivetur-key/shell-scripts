#!/usr/bin/python
import bs4 as bs
import urllib.request
# Gets a list of packages from the aur and writes them to a file
# Gets the page and saves it as beautiful soup object
def grab_data(c):
    sauce =urllib.request.urlopen('https://aur.archlinux.org/packages/?SB=l&SO=d&O=%d' % c)
    return bs.BeautifulSoup(sauce, 'lxml')
# extracts the table of packages from the page
def form_table(_soup):
    table = _soup.find_all('table')
    return table[0]
# extracts the first column or the names of the packages
def extract_column(_alist, _table):
    for row in _table.find_all('tr'):
        c = 0
        for col in row.find_all('td'):
            if c == 0:
                _alist.append(col.text)
                c += 1
# loops so it will take 20 pages
def init_parser(_alist):
    c = 0
    for i in range(20):
        soup = grab_data(c)
        table = form_table(soup)
        extract_column(_alist, table)
        c += 50
# writes the list to a file
def write_out(_alist):
    f = open('paclist.txt', 'w')
    for item in _alist:
        f.write("%s\n" %item)

def main():
    alist = []
    init_parser(alist)
    write_out(alist)
    return 0

if __name__ == "__main__":
    main()
