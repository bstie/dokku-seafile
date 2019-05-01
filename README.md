# Deploy Seafile to dokku via Dockerfile Deployment

## Prerequisites

- Server with dokku installed
- Set up DNS Record (seafile.example.com for instance)

All `dokku` commands are meant to be run on the dokku host.  
The `git` commands are desired to run on the client.

Replace all occurences of **example.com** with your actual domain in each shell command, in the `app.json` and in `backup.sh` (if you want to use it).

## Create the app

```bash
# create the app
dokku apps:create example.com
# set password (not tried yet)
dokku config:set example.com SEAFILE_ADMIN_PASSWORD=<password>
```

## Add persistence

```bash
# create the folder that will contain the seafile data
mkdir /opt/seafile-data
# set dokku as owner
chown dokku:dokku /opt/seafile-data
# add volume to run args
dokku docker-options:add example.com run "-v /opt/seafile-data:/shared"
```

## First deployment

```bash
# add dokku remote
git remote add dokku dokku@dokku.example.com:example.com
# deploy
git push dokku master
```

## Add SSL

```bash
# set the email address for the certificate
dokku config:set --no-restart example.com DOKKU_LETSENCRYPT_EMAIL=yourmail@example.com
# generate the certificate
dokku letsencrypt example.com
```

## Backup (see also: https://manual.seafile.com/deploy_pro/deploy_with_docker.html)

SSH into the server and run the following commands or use `backup-seafile.sh` (edit the script and replace **example.com** with your domain).

```bash
# create a backup directory
mkdir backup backup/databases backup/data
# backup databases
dokku enter example.com web mysqldump -uroot --opt ccnet_db > ./backup/databases/ccnet_db.sql
dokku enter example.com web mysqldump -uroot --opt seafile_db > ./backup/databases/seafile_db.sql
dokku enter example.com web mysqldump -uroot --opt seahub_db > ./backup/databases/seahub_db.sql
# backup data
rsync -az /opt/seafile-data ./backup/data/
```

## Fix Nginx Config to allow uploading files bigger than 1M

```bash
echo 'client_max_body_size 0;' > /home/dokku/example.com/nginx.conf.d/upload.conf
chown dokku:dokku /home/dokku/example.com/nginx.conf.d/upload.conf
service nginx reload
```
