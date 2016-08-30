########################################################################
#								       #
# Configuração do container do Jenkins do projeto ePol. 	       #
# Esse Dockerfile tem como dependência o container oficial do Jenkins  #
# na versão latest       					       #
# Autores: Victor Hugo, Bruno Dias 				       #
#								       #
########################################################################

FROM jenkins:latest

USER root

# Substituindo o sources.list do container por falha na geração de build do dockerhub. Troubleshooting: http://forums.debian.net/viewtopic.php?f=5&t=125350
RUN echo "deb http://ftp.br.debian.org/debian/ jessie main non-free contrib" >  /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list

# RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com: 3EE67F3D0FF405B2
# RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com: EEA14886

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 3EE67F3D0FF405B2
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys EEA14886

# Configuração para instalação silenciosa do oracle-java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime

# Instalação das ferramentas necessárias para o projeto
RUN apt-get update && apt-get install -y \
   oracle-java8-installer \
   oracle-java8-set-default \
   maven \
   wkhtmltopdf \
   nodejs \
   npm \
   firefox \
   xvfb \
   xfonts-75dpi \
   sshpass \
&& rm -rf /var/lib/apt/lists/*

RUN wget http://ftp.br.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d1-2_amd64.deb
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN dpkg -i libjpeg8_8d1-2_amd64.deb
RUN dpkg -i wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN rm libjpeg8_8d1-2_amd64.deb
RUN rm wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm cache clean -f
RUN npm install -g n
RUN n stable
RUN npm install -g gulp-cli
RUN npm install -g gulp

# Configuração do ambiente do projeto para execução dos testes

RUN rm -rf /var/lib/apt/lists
RUN mkdir /local_home
RUN chown -R jenkins /local_home
RUN Xvfb :10 -ac&
# Definindo a variável de ambiente JBOSS_HOME
RUN echo "export JBOSS_HOME=/local_home/epol/wildfly-10.0.0.Final" >> ~/.bashrc
RUN export JBOSS_HOME=/local_home/epol/wildfly-10.0.0.Final
# Definindo o timezone do sistema
RUN echo "America/Recife" > /etc/timezone
RUN export TZ=America/Recife

USER jenkins
