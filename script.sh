#!/bin/bash
su postgres -c "psql -c 'CREATE USER $1;'"
su postgres -c "psql -c 'CREATE DATABASE '$1' WITH OWNER '$1' ENCODING 'UTF8';'"
su postgres -c "psql -c '\l';"
su postgres -c "psql -c 'DROP DATABASE $1;'"
su postgres -c "psql -c 'DROP USER $1;'"

