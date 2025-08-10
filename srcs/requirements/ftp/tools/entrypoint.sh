#!/bin/sh
FTP_PASS=$(cat /run/secrets/ftp_password)
# Only create user if not exists
id ftpuser 2>/dev/null || adduser -D -h /home/ftpuser ftpuser
echo "ftpuser:$FTP_PASS" | chpasswd
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf