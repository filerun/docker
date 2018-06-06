<?php
$config['db'] = [
	'server' => (getenv('FR_DB_HOST') ?: 'db') .';port='. (getenv('FR_DB_PORT') ?: 3306),
	'database' => getenv('FR_DB_NAME') ?: 'filerun',
	'username' => getenv('FR_DB_USER') ?: 'filerun',
	'password' => getenv('FR_DB_PASS') ?: 'filerun',
	'sync_timezone' => false
];