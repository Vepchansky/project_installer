#!/bin/bash

SET_DIR=$1/settings

echo " Для выхода вводите \"n\" \n"

read -p "Введите имя домена, которое нужно сменить: " domen1
read -p "Введите имя домена, на которое нужно поменять: " domen2
read -p "Введите название проекта: " proj

if [[ "$domen1" =~ ^[nN]$ ]] || [[ "$domen2" =~ ^[nN]$ ]] || [[ "$proj" =~ ^[nN]$ ]]; then
       echo " Выход "
       exit
else
str=$(ls -l /etc/nginx/sites-enabled/cre_site_nginx.conf)
cat ${str##*->} | sed -e "s/${domen1}/${domen2}/g" > domen.txt
cat domen.txt > ${str##*->}
rm domen.txt
cat $SET_DIR/dev_o.py | sed "s/name_host/$domen2/" > /opt/projects/$proj/$proj/$proj/settings/dev.py
cat $SET_DIR/prod_o.py | sed "s/local_host_name/$domen2/" > /opt/projects/$proj/$proj/$proj/settings/prod.py
fi

