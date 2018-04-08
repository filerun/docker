<?php 
$config['db'] = [
  'type' => getenv('DB_TYPE') ?: 'mysql',
  'server' => sprintf('%s:%s', getenv('DB_HOST') ?: 'db', getenv('DB_PORT') ?: '3306'),
  'database' => getenv('DB_NAME') ?: 'filerun',
  'username' => getenv('DB_USER') ?: 'filerun',
  'password' => getenv('DB_PASS') ?: 'filerun'
];
