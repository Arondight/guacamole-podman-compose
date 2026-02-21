#!/bin/sh
#
# check if podman is running
if ! (podman ps >/dev/null 2>&1)
then
	echo "podman not running, will exit here!"
	exit
fi
echo "Preparing folder init and creating ./init/initdb.sql"
mkdir ./init >/dev/null 2>&1
mkdir -p ./nginx/ssl >/dev/null 2>&1
chmod -R +x ./init
# latest
#podman run --rm 'guacamole/guacamole' /opt/guacamole/bin/initdb.sh --postgresql > ./init/initdb.sql
# pinned version
podman run --rm 'guacamole/guacamole:1.6.0' /opt/guacamole/bin/initdb.sh --postgresql > ./init/initdb.sql
echo "done"
echo "Preparing folder record and set permissions"
mkdir ./record >/dev/null 2>&1
chmod -R 777 ./record
echo "done"
echo "Creating SSL certificates"
openssl req -nodes -newkey rsa:2048 -new -x509 -keyout nginx/ssl/self-ssl.key -out nginx/ssl/self.cert -subj '/C=DE/ST=BY/L=Hintertupfing/O=Dorfwirt/OU=Theke/CN=home.arondight.me/emailAddress=mail@arondight.me'
echo "You can use your own certificates by placing the private key in nginx/ssl/self-ssl.key and the cert in nginx/ssl/self.cert"
echo "done"
