if mysqlshow --host=$FR_DB_HOST --port=$FR_DB_PORT --user=$FR_DB_USER --password=$FR_DB_PASS $FR_DB_NAME; then
    echo "database exist!"
else
    echo "CREATE DATABASE $FR_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql --host=$FR_DB_HOST --port=$FR_DB_PORT --user=$FR_DB_USER --password=$FR_DB_PASS
fi

mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT $FR_DB_NAME < /filerun.setup.sql
