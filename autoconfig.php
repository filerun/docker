<?php
$config['db'] = [
	'server' => getenv('FR_DB_HOST') .';port='. getenv('FR_DB_PORT'),
	'database' => getenv('FR_DB_NAME'),
	'username' => getenv('FR_DB_USER'),
	'password' => getenv('FR_DB_PASS'),
	'sync_timezone' => false
];