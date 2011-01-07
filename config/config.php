<?php
session_start();
error_reporting(E_ALL);
ini_set('display_errors', 'On');
ini_set('display_startup_errors', 'On');

$pathSet = ':';
if(strstr(@$_SERVER[SERVER_SIGNATURE], "Win32") !== FALSE){
	$pathSet = ';';
}

if($_SERVER['HTTP_HOST'] == 'dev'){ //INTERNAL HOME STAGEING
	define('SITE_ROOT','http://'.$_SERVER['HTTP_HOST'].'/ps_admin/');
	define('DIR_ROOT',$_SERVER['DOCUMENT_ROOT'].'/ps_admin/');
	define('TEMPLATE_ROOT',$_SERVER['DOCUMENT_ROOT'].'/ps_admin/templates');
	define('DB_USER','root');
	define('DB_PASS','password');
	define('DB_HOST','localhost');
	define('DB_DBASE','people_scope_main');
	define('DB_TYPE','mysql');
	define('DEBUG', true);
	define('ERROR_LEVEL', 'dev');

}else{
	define('SITE_ROOT','http://'.$_SERVER['HTTP_HOST'].'/people_scope/');
	define('DIR_ROOT',$_SERVER['DOCUMENT_ROOT'].'/people_scope/');
	define('TEMPLATE_ROOT',$_SERVER['DOCUMENT_ROOT'].'/people_scope/templates');
	define('DB_USER','root');
	define('DB_PASS','password');
	define('DB_HOST','localhost');
	define('DB_DBASE','Forevernew_rec');
	define('DB_TYPE','mysql');
	define('DEBUG', true);
	define('ERROR_LEVEL', 'dev');
}


define('CLASS_ROOT', DIR_ROOT.'class/base');
define('ASSETS_ROOT', DIR_ROOT.'assets');
define('CONFIG_ROOT', DIR_ROOT.'config');

set_include_path(get_include_path().PATH_SEPARATOR. DIR_ROOT.'assets/PEAR/');
set_include_path(get_include_path().PATH_SEPARATOR.$_SERVER['DOCUMENT_ROOT'].'/people_scope/classes/base/');

require_once($_SERVER['DOCUMENT_ROOT'].'/ps_admin/config/standard.inc.php');
require_once('constants.php');

if(isset($_REQUEST['js'])){
	echo "const SITE_ROOT = '".SITE_ROOT."';";
	echo "const DIR_ROOT = '".DIR_ROOT."';";
	echo "const TEMPLATE_ROOT = '".TEMPLATE_ROOT."';";
	echo "const DEBUG = '".DEBUG."';";
}

?>
