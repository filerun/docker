#!/bin/bash
set -eux

# Check if user exists
if ! id -u ${APACHE_RUN_USER} > /dev/null 2>&1; then
	echo "The user ${APACHE_RUN_USER} does not exist, creating..."
	groupadd -f -g ${APACHE_RUN_GROUP_ID} ${APACHE_RUN_GROUP}
	useradd -u ${APACHE_RUN_USER_ID} -g ${APACHE_RUN_GROUP} ${APACHE_RUN_USER}
fi

# Install FileRun on first run
if [ ! -e /var/www/html/index.php ];  then
	echo "[Downloading latest FileRun version]"
	url=$(echo -n 'aHR0cHM6Ly9maWxlcnVuLmNvbS9kb3dubG9hZC1ub3ctZG9ja2Vy' | base64 --decode)
  curl -o /filerun.zip -L $url
	unzip -q /filerun.zip -d /var/www/html/
	cp /filerun/overwrite_install_settings.temp.php /var/www/html/system/data/temp/
	cp /filerun/.htaccess /var/www/html/
	rm -f /filerun.zip
	chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/html
	chown ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /user-files
	echo "Open this server in your browser to complete the FileRun installation."
fi

exec "$@"
