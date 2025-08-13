#!/bin/bash
set -e

# exit immediately if any command returns a non-zero/error status
# run in lightweight shell 

#nginx cert if there is no file, then run certification generation script
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	/ssl.sh
fi

#start webserv, global, in the foreground (off) keeps the container running 
exec nginx -g "daemon off;"