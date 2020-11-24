if mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT $FR_DB_NAME -e "select \`val\` from df_settings where \`var\`='currentVersion'"; then
  echo "Using existing database!"
else
  echo "Creating fresh FileRun database!"
  mysql --user=$FR_DB_USER --password=$FR_DB_PASS --host=$FR_DB_HOST --port=$FR_DB_PORT $FR_DB_NAME < /filerun.setup.sql
fi