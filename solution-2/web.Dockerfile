FROM php:8.0-apache
RUN apt update 
RUN apt install   unixodbc-dev unixodbc locales --no-install-recommends -y 
RUN pecl install sqlsrv pdo_sqlsrv
RUN echo 'extension=pdo_sqlsrv.so' >> /usr/local/etc/php/php.ini ; echo 'extension=sqlsrv.so' >> /usr/local/etc/php/php.ini
ADD https://packages.microsoft.com/debian/9/prod/pool/main/m/msodbcsql17/msodbcsql17_17.4.2.1-1_amd64.deb .
RUN ACCEPT_EULA=Y dpkg -i msodbcsql17_17.4.2.1-1_amd64.deb
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN rm -rf msodbcsql17_17.4.2.1-1_amd64.deb; apt-get clean ; apt-get autoclean ; apt-get autoremove ; rm -rf /var/lib/apt/lists/*

COPY index.php /var/www/html/
