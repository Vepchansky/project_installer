#!/bin/bash

BASE_DIR=$(pwd)

echo " Для выхода вводите \"n\" \n"

read -p " Введите название проекта, который хотите удалить: " proj
if [[ "$proj" =~ ^[nN]$ ]]; then
       echo " Выход "
       exit
else
	if [ $proj ]; then
		str=$(ls -l /etc/nginx/sites-enabled/*_nginx.conf)
		if [ -e /opt/projects/$proj ]; then
			rm -r /opt/projects/$proj
			rm /etc/uwsgi/vassals/${proj}_uwsgi.ini
		fi
		sed -i "/${proj}1/, /${proj}2/d" ${str##*->} 
		cat $BASE_DIR/databaseD | sed "s/namedb/$proj/" > $BASE_DIR/databaseDrop
		su - postgres -c "psql -f $BASE_DIR/databaseDrop"
		rm databaseDrop
		systemctl restart nginx.service
	fi
fi

