FROM alpine:3.20
#image as the base for your container

# install nginx, no extra saved index files
RUN apk add --no-cache nginx

# copy ALL static files and config
COPY ./tools/ /var/www/html/
COPY ./conf/default.conf /etc/nginx/http.d/default.conf

# expose port
EXPOSE 80

# start webserv, global, in the foreground (off) keeps the container running 
CMD ["nginx", "-g", "daemon off;"]
