#!/bin/bash

if [ -e /etc/nginx/sites-enabled/cre_site_nginx.conf ]; then
echo "yes"
str=$(ls -l /etc/nginx/sites-enabled/cre_site_nginx.conf)
cat $3/settings/test_nginx.conf | sed -e "s/name_host/$2/; s/project_name/$1/g" >> ${str##*->}
else
cat $3/settings/test_nginx.conf | sed -e "s/name_host/$2/; s/project_name/$1/g" > /opt/projects/$1/$1/deployment/${1}_nginx.conf
ln -s /opt/projects/$1/$1/deployment/${1}_nginx.conf /etc/nginx/sites-enabled/.
fi
