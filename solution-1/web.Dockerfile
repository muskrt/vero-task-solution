FROM ubuntu:jammy
RUN apt update 

ENV DEBIAN_FRONTEND noninteractive
RUN apt install   wget  locales php php-dev php-pear g++ make build-essential apache2  --no-install-recommends  -y 
RUN apt install unixodbc unixodbc-dev  curl odbcinst systemd -y

RUN wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz --no-check-certificate
RUN tar -zxf openssl-1.1.1g.tar.gz && cd openssl-1.1.1g && ./config && make install
RUN ln -s /usr/local/bin/openssl /usr/bin/openssl
RUN ldconfig
RUN apt install openssl -y 
ADD https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql17/msodbcsql17_17.4.2.1-1_amd64.deb .
RUN ACCEPT_EULA=Y dpkg -i msodbcsql17_17.4.2.1-1_amd64.deb



RUN wget -P /etc/ssl/certs/ http://curl.haxx.se/ca/cacert.pem  --no-check-certificate &&  chmod 744 /etc/ssl/certs/cacert.pem
RUN pecl channel-update pecl.php.net 
RUN wget http://pecl.php.net/get/sqlsrv-5.11.0.tgz ; pear install sqlsrv-5.11.0.tgz

RUN wget http://pecl.php.net/get/pdo_sqlsrv-5.11.0.tgz ;  pear install pdo_sqlsrv-5.11.0.tgz

 
RUN echo 'extension=pdo_sqlsrv.so' >> /etc/php/8.1/mods-available/pdo_sqlsrv.ini ; echo 'extension=sqlsrv.so' >> /etc/php/8.1/mods-available/sqlsrv.ini
RUN phpenmod -v 8.1 sqlsrv pdo_sqlsrv

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN rm -rf msodbcsql17_17.4.2.1-1_amd64.deb openssl-1.1.1g.tar.gz sqlsrv-5.11.0.tgz pdo_sqlsrv-5.11.0.tgz; apt-get clean ; apt-get autoclean ; apt-get autoremove ; rm -rf /var/lib/apt/lists/*
RUN mkdir /var/www/php && chown -R $USER:$USER /var/www/php
COPY php.conf /etc/apache2/sites-available/php.conf
RUN a2ensite php
RUN a2dissite 000-default
COPY index.php /var/www/php/
RUN echo '#!/bin/bash\nservice apache2 start\nsystemctl enable apache2\nsystemctl restart apache2\nwhile true; do sleep 1; done' > start_apache.sh ; chmod +x start_apache.sh
CMD ./start_apache.sh


