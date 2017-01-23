#!/bin/bash
set -eux

if [ ! -e /var/www/html/index.php ];  then
	echo "[FileRun fresh install]"
	unzip /filerun.zip -d /var/www/html/
	cp /autoconfig.php /var/www/html/system/data/
	chown -R www-data:www-data /var/www/html
	mkdir -p /user-files/superuser
	chown -R www-data:www-data /user-files
	/wait-for-it.sh db:3306 -t 120 -- /import-db.sh

fi

exec "$@"
