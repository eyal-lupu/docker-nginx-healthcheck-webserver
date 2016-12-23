FROM nginx:1.11.7
MAINTAINER Eyal Lupu eyall2@gmail.com

COPY filesystem/ /
 
EXPOSE 8888
