<?php
$overwriteDefaultSettings = [
	'thumbnails_vips' => '1',
	'thumbnails_vips_path' => 'vipsthumbnail',

	'thumbnails_imagemagick' => '1',
	'thumbnails_imagemagick_path' => 'magick',

	'thumbnails_ffmpeg' => '1',
	'thumbnails_ffmpeg_path' => 'ffmpeg',

	'thumbnails_libreoffice' => '1',
	'thumbnails_libreoffice_path' => '/opt/libreoffice7.1/program/soffice',

	'thumbnails_stl' => '1',
	'thumbnails_stl_path' => 'stl-thumb',
	'thumbnails_pngquant_path' => 'pngquant',

	'download_accelerator' => 'xsendfile',

	'ui_logo_url' => '?page=logo&version=2021.12.07'
];
$queries[] = "UPDATE `df_file_handlers` SET `handler`='libreoffice_viewer', `weblink_handler`='libreoffice_viewer' WHERE `type` in ('office', 'ooffice')";
$queries[] = "UPDATE `df_users_permissions` SET `homefolder` = '/user-files' WHERE uid='1'";
