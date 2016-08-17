FROM jenkins:latest

USER root

# enviroment setup to Jenkins works fine
RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list \
 && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2 \ 
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com  EEA14886 \
 && apt-get update && apt-get install -y \
   oracle-java8-installer \
   oracle-java8-set-default \
   maven \
   wkhtmltopdf \
   nodejs \
    npm \
    firefox \
    xvfb \
 && rm -rf /var/lib/apt/lists \ 
 && mkdir /local_home \ 
 && chown -R jenkins /local_home \ 
 && Xvfb :10 -ac& \ 
 && npm install -g gulp-cli \ 
 && npm install -g gulp \ 
 && ln -s /usr/bin/nodejs /usr/bin/node \ 
 && npm cache clean -f
 && npm install -g n
 && n stable

USER jenkins
