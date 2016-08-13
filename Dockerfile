FROM jenkins:latest

USER root

RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2

RUN apt-get update 
RUN apt-get install -y nodejs 
RUN apt-get install -y npm 
RUN apt-get install -y firefox 
RUN apt-get install -y xvfb
RUN Xvfb :10 -ac&
RUN npm install -g gulp-cli
RUN npm install -g gulp

USER jenkins
