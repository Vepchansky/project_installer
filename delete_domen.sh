#!/bin/bash


read -p "Введите название проекта(для выхода 'n'): " proj
if [[ "$proj" != "n" ]] && [ -e /opt/projects/$proj ] && [ $proj ]; then
	read -p "Введите домен: " domen
	if [[ "$domen" != "n" ]] && [ $domen ]; then
		cd /opt/projects/$proj/$proj/$proj/settings
		sed -i "s#\(ALLOWED_HOSTS = \[[0-9A-Za-z\.\*\'\-]*\)#\1, '$domen'#" dev.py
		cd /opt
		str=$(ls -l /etc/nginx/sites-enabled/cre_site_nginx.conf)
		sed -i "/${proj}1${domen}1/, /${proj}2${domen}2/d" ${str##*->}
	else
		exit
	fi
else
	echo "
	Выход (возможно проект не существует)
	"
	exit
fi
