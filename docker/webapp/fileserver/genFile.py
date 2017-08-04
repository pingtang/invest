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

if __name__ == "__main__":
	main()
