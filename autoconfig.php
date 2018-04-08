<?php 
$config['db'] = [
  'type' => getenv('DB_TYPE') ?: 'mysql',
  'server' => getenv('DB_HOST') ?: 'db',
  'database' => getenv('DB_NAME') ?: 'filerun',
  'username' => getenv('DB_USER') ?: 'filerun',
  'password' => getenv('DB_PASS') ?: 'filerun'
];