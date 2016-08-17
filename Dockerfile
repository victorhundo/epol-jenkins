FROM jenkins:latest

# Enviroment setup to Jenkins works fine
USER root

# Add packages 
RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list 
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list 
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list 
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3EE67F3D0FF405B2
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com  EEA14886

# Setup to silent install of oracle-java8
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Install dependencies tools 
RUN apt-get update && apt-get install -y \
   oracle-java8-installer \
   oracle-java8-set-default \
   maven \
   wkhtmltopdf \
   nodejs \
   npm \
   firefox \
   xvfb
RUN npm install -g gulp-cli
RUN npm install -g gulp
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

RUN rm -rf /var/lib/apt/lists
RUN mkdir -f /local_home 
RUN chown -R jenkins /local_home
RUN Xvfb :10 -ac&
RUN echo "export JBOSS_HOME=/local_home/epol/wildfly-10.0.0.Final" >> ~/.bashrc
USER jenkins
