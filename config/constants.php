<?php
//Pagination settings
define('NUM_PER_PAGE', 10);

//SET MAIL SENDING TYPE mail, smtp, sendmail
define('MAILTYPE', 'mail');

//system type template settings
define('TEMPLATE_BLANK', 1);

//Utils Setting
if(!DEBUG || ERROR_LEVEL=='production'){
	define('TURN_ON_PP',false); //Toggle display of pp() function;
}else{
	define('TURN_ON_PP',true); //Toggle display of pp() function
}

define('SEO_LINK',false);
define('DEFAULT_YEAR',date('Y'));

?>