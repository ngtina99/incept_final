FROM alpine:3.20

RUN apk update && apk add --no-cache vsftpd

# Copy configuration file from conf/ subdirectory
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

# Use entrypoint script to set password from secret at runtime
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21

CMD ["/entrypoint.sh"]