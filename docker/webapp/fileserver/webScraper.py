#!/usr/bin/python
import string
import os
import pwd

def main ():
        permission_cmd = "May need give proper permission by command: sudo chmod 777 -R /invest/mysql/*"
        print permission_cmd
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

        target_dir = '/invest/archive/'
        clean_old_cvs_cmd = 'rm -rf ' +  target_dir + '*Income*.csv' 
        print clean_old_cvs_cmd
        os.system(clean_old_cvs_cmd)

        tickerlist = []
        with open(filedir+'../sample/tickerlist', 'r') as file:
            for ticker in file:
                ticker = ticker.strip()
                tickerlist.append(ticker)

        for ticker in tickerlist:
        	webScraperCmd = "cd /invest/archive && curl -O -J 'http://financials.morningstar.com/ajax/ReportProcess4CSV.html?t="+ticker+"&reportType=is&period=3&dataType=A&order=asc&columnYear=5&number=3'"
                print webScraperCmd
                os.system(webScraperCmd)

                with open(filedir+'/demo_load.sql.templ', 'r') as content_file:
                    template = content_file.read()

                ticker_data = {"ticker": ticker}
                print template.format(**ticker_data)
                f = open('/invest/mysql/'+ticker+'_demo_load.sql', 'w')
                f.write(template.format(**ticker_data))

if __name__ == "__main__":
	main()
