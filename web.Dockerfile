#FROM php:8.0-apache
#RUN apt update
#WORKDIR /var/www/html
#RUN apt install unixodbc-dev -y
#COPY index.php index.php
#RUN pecl install sqlsrv
#RUN pecl install pdo_sqlsrv
#EXPOSE 80

FROM php:8.0-apache
RUN apt update 
RUN apt install wget -y 
RUN apt install unixodbc-dev unixodbc -y
RUN pecl install sqlsrv pdo_sqlsrv
RUN echo 'extension=pdo_sqlsrv.so' >> /usr/local/etc/php/php.ini
RUN echo 'extension=sqlsrv.so' >> /usr/local/etc/php/php.ini
RUN wget https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql17/msodbcsql17_17.4.2.1-1_amd64.deb
RUN ACCEPT_EULA=Y dpkg -i msodbcsql17_17.4.2.1-1_amd64.deb
RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen



COPY . /var/www/html/
