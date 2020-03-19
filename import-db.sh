mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT -e"create database if not exists "$FR_DB_NAME";"
mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT $FR_DB_NAME < /filerun.setup.sql
mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT $FR_DB_NAME -e"update df_users set username = '"$FR_ADMIN_NAME"',name = '"$FR_ADMIN_NAME"' where id = 1;update df_settings set val = 'chinese' where var = 'ui_default_language';"
