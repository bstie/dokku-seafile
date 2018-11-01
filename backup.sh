#!/bin/bash

# create a backup directory
mkdir backup backup/databases backup/data

# backup databases
dokku enter example.com web mysqldump -uroot --opt ccnet_db > ./backup/databases/ccnet_db.sql
dokku enter example.com web mysqldump -uroot --opt seafile_db > ./backup/databases/seafile_db.sql
dokku enter example.com web mysqldump -uroot --opt seahub_db > ./backup/databases/seahub_db.sql

# backup data
rsync -az /opt/seafile-data ./backup/data/
