#!/bin/bash


websettings() {
mkdir /opt/projects/$1/$1/deployment
cp /opt/deployment/uwsgi_params /opt/projects/$1/$1/deployment/.
cat /opt/deployment/clear_uwsgi.ini | sed "s/clear/$1/g" > /opt/projects/$1/$1/deployment/${1}_uwsgi.ini
if [ ! -e /etc/uwsgi/vassals ]; then
mkdir /etc/uwsgi/vassals
fi
ln -s /opt/projects/$1/$1/deployment/${1}_uwsgi.ini /etc/uwsgi/vassals/.
return
}

BASE_DIR=$(pwd)

echo " Для выхода вводите \"n\" \n"

read -p " Введите название проекта: " proj
read -p " Введите имя домена: " domen

if [[ "$proj" =~ ^[nN]$ ]] || [[ "$domen" =~ ^[nN]$ ]]; then
       echo " Выход "
       exit
else

cd /opt

if [ ! -e projects ]
then
mkdir projects
fi

cd /opt/projects
virtualenv $proj
cd /opt/projects/$proj
source bin/activate
python -m pip install --upgrade pip
pip install coderedcms
pip install wagtail_lazyimages
pip install psycopg2

coderedcms start $proj
cd $proj
mkdir media
cp $BASE_DIR/yesanswer .
python manage.py startapp modwebpage
cd modwebpage
cp $BASE_DIR/clear/clear/modwebpage/models.py .
cp $BASE_DIR/clear/clear/modwebpage/blocks.py .
cp -r $BASE_DIR/clear/clear/modwebpage/templates .
cd ..
cat $BASE_DIR/database | sed "s/namedb/$proj/" > $BASE_DIR/databaseProd
su - postgres -c "psql -f $BASE_DIR/databaseProd"
rm $BASE_DIR/databaseProd
$BASE_DIR/settings/sedtext $proj $domen $BASE_DIR
python manage.py makemigrations
python manage.py migrate
pip install -r requirements.txt
cp $BASE_DIR/clear/clear/website/templates/coderedcms/pages/base.html /opt/projects/$proj/$proj/website/templates/coderedcms/pages/.
cp $BASE_DIR/clear/clear/website/static/website/css/genstyle.css /opt/projects/$proj/$proj/website/static/website/css/.
cp $BASE_DIR/clear/clear/website/static/website/css/scroll_style.css /opt/projects/$proj/$proj/website/static/website/css/.
cp $BASE_DIR/clear/clear/website/static/website/css/choise_style.css /opt/projects/$proj/$proj/website/static/website/css/.
cp -r $BASE_DIR/clear/lib/python3.8/site-packages/coderedcms/templates /opt/projects/$proj/lib/python3.8/site-packages/coderedcms/.
/opt/projects/$proj/$proj/yesanswer
websettings $proj
$BASE_DIR/settings/nginx.sh $proj $domen $BASE_DIR

systemctl start emperor.uwsgi.service
systemctl restart nginx.service
fi

