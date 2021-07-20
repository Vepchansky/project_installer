#!/bin/bash


read -p "Введите название проекта(для выхода 'n'): " proj

if [[ "$proj" != "n" ]] && [ -e /opt/projects/$proj ] && [ $proj ]; then

	read -p "Введите домен: " domen

	if [[ "$domen" != "n" ]] && [ $domen ]; then

		cd /opt/projects/$proj/$proj/$proj/settings
		sed -i "s#\(ALLOWED_HOSTS = \[[0-9A-Za-z\.\*\'\-]*\)#\1, '$domen'#" dev.py
		cd /opt
		str=$(ls -l /etc/nginx/sites-enabled/*nginx.conf)
		
		if [[ "$(cat ${str##*->})" =~ .*"$domen".* ]]; then

			echo "В nginx такой домен существует"	
			sed -i "/${domen}1/, /${domen}2/d" ${str##*->}
			cat $1/settings/test_nginx.conf | sed -e "s/name_host/$domen/; s/project_name/$proj/g" > test1_nginx.conf
			cat test1_nginx.conf >> ${str##*->}
			rm test1_nginx.conf

		else 

			cat $1/settings/test_nginx.conf | sed -e "s/name_host/$domen/; s/project_name/$proj/g" > test1_nginx.conf
			cat test1_nginx.conf >> ${str##*->}
			rm test1_nginx.conf

		fi
	else
		exit
	fi
else
	echo "
	Выход (возможно проект не существует)
	"
	exit
fi
