#!/bin/bash

# check script parameters
if [ ! $# -eq 1 ]; then
	echo "Usage: $0 WebServerName" >&2
	echo '"WebServerName" must be like "apache2" or "nginx" or another web-browser' >&2

    exit 1
fi

WEB_SERVER=${1} 

# объявим перехват сигнала SIGINT
trap 'echo "Ping exit (Ctrl+c)"; exit 1;' 2

# проверим привилегии пользователя
user_id=$(id -u)
[[ $user_id -ne 0 ]] && { echo "SUDO must be used to start script"; exit 1; }


WEB_SERVER_PORT=$(sudo lsof -i -P -n |grep $WEB_SERVER |grep LISTEN | awk '{print $9}'|uniq |awk 'BEGIN {FS=":"}{print $2}'|sed -n '1p')

INDEX_FILE_PATH=""
case $WEB_SERVER in
    "apache2")
        INDEX_FILE_PATH="/var/www/html/index.html"
        ;;
    "nginx")
        INDEX_FILE_PATH="/usr/share/nginx/html/index.html"
        ;;
esac

if [[ $WEB_SERVER_PORT!="" && $WEB_SERVER_PORT =~ ^[0-9]+$ && $WEB_SERVER_PORT -ge 1 && $WEB_SERVER_PORT -le 65536 && -f $INDEX_FILE_PATH ]]; then
    echo $WEB_SERVER $WEB_SERVER_PORT $INDEX_FILE_PATH
    exit 0
else
    echo $WEB_SERVER $WEB_SERVER_PORT $INDEX_FILE_PATH >&2
    exit 1
fi



#apache2:/etc/apache2/sites-available/000-default.conf  "DocumentRoot /var/www/html"
