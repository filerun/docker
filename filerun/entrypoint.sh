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
  chown ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /user-files
	echo "The next step is to download the latest FileRun installation zip from the FileRun client account and upload its contents inside the 'html' mounted folder."
	echo "Then change ownership of the files like this:"
	echo "chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/html"
	echo "Then open this server in your browser to complete the FileRun installation."
fi

exec "$@"
