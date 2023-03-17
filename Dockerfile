FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN apt add php-fpm
EXPOSE 8080 


