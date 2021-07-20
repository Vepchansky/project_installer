#!/bin/bash

if [ -e /etc/nginx/sites-enabled/cre_site_nginx.conf ]; then

echo "yes"
str=$(ls -l /etc/nginx/sites-enabled/cre_site_nginx.conf)
echo ${str##*->}

fi
