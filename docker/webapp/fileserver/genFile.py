#!/usr/bin/python
import string
import os
import pwd

def main ():
        userid = os.getuid()
        username = os.getlogin()
        print userid, username
	data = {"username": username, "userid": userid}

        with open('Dockerfile.templ', 'r') as content_file:
    		template = content_file.read()
	print template.format(**data)
        f = open('Dockerfile', 'w')
        f.write(template.format(**data))

if __name__ == "__main__":
	main()
