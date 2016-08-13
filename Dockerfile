FROM jenkins:latest

USER root

RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2

RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    firefox \
    xvfb \
&& rm -rf /var/lib/apt/lists

RUN Xvfb :10 -ac&
RUN npm install -g gulp-cli
RUN npm install -g gulp
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

USER jenkins
