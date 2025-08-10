FROM alpine:3.20

RUN apk add --no-cache nginx

COPY ./tools/index.html /var/www/html/index.html
COPY ./conf/default.conf /etc/nginx/http.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
