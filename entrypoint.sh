#!/bin/bash
set -eux

if [ ! -e /var/www/html/index.php ];  then
	echo "[FileRun fresh install]"
	unzip /filerun.zip -d /var/www/html/
	cp /autoconfig.php /var/www/html/system/data/
	addgroup --gid ${APACHE_RUN_USER_ID} ${APACHE_RUN_USER}
	adduser --system --uid ${APACHE_RUN_USER_ID} --gid ${APACHE_RUN_GROUP_ID} ${APACHE_RUN_GROUP}
	chown ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /user-files
	mysql_host="${FR_DB_HOST:-mysql}"
	mysql_port="${FR_DB_PORT:-3306}"
	/wait-for-it.sh $mysql_host:$mysql_port -t 120 -- /import-db.sh

fi

exec "$@"
