#!/usr/bin/python
import string
import os
import pwd

def main ():
        userid = os.getuid()
        username = os.getlogin()
        print userid, username
	data = {"username": username, "userid": userid}

        filepath = os.path.realpath(__file__)
        filedir =  os.path.dirname(os.path.abspath(filepath))

        with open(filedir+'/Dockerfile.templ', 'r') as content_file:
    		template = content_file.read()
	print template.format(**data)
        f = open(filedir+'/Dockerfile', 'w')
        f.write(template.format(**data))

        tickerlist = []
        with open(filedir+'/tickerlist', 'r') as file:
            for ticker in file:
                ticker = ticker.strip()
                tickerlist.append(ticker)
        for symbol in tickerlist:
        	webScraperCmd = "cd /invest/archive && curl -O -J 'http://financials.morningstar.com/ajax/ReportProcess4CSV.html?t="+symbol+"&reportType=is&period=3&dataType=A&order=asc&columnYear=5&number=3'"
                print webScraperCmd
                os.system(webScraperCmd)

if __name__ == "__main__":
	main()
