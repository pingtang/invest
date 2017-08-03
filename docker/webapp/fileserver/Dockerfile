FROM node:argon
MAINTAINER ptang  <ptang@ptang.com>

# Add the nodeuser and nodegroup
RUN groupadd -g 501 ptang 
RUN useradd -u 501 -g ptang -m ptang 

# Install dependencies
RUN npm install http-server -g

# Create fileshare directory and set permissions
RUN mkdir /fileshare
RUN chown ptang: /fileshare

# Set the environment user to nzrtcbld
USER ptang 

# Set Working directory
WORKDIR /fileshare

EXPOSE 3001
CMD [ "http-server", "-p", "3001" ]
