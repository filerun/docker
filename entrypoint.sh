#!/bin/bash
set -eux

if [ ! -e /var/www/html/index.php ];  then
	echo "[FileRun fresh install]"
	unzip /filerun.zip -d /var/www/html/
	cp /autoconfig.php /var/www/html/system/data/
	chown -R www-data:www-data /var/www/html
	chown -R www-data:www-data /user-files
	mysql_host="${FR_DB_HOST:-mysql}"
    mysql_port="${FR_DB_PORT:-3306}"
	/wait-for-it.sh $mysql_host:$mysql_port -t 120 -- /import-db.sh

fi

exec "$@"
