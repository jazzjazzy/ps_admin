<?php
require_once '../config/config.php';
require_once DIR_ROOT.'/classes/clients.class.php';

define('FULL_LIKE', true);// do like as %search_term% not search_term%

$action = $_REQUEST['action'];
$orderby = (isset($_REQUEST['orderby']))? $_REQUEST['orderby'] : '';
$dir =(isset($_REQUEST['dir']))? $_REQUEST['dir'] : '';
$year =(!empty($_REQUEST['year']))? $_REQUEST['year'] : DEFAULT_YEAR;

$clients = new clients($year);


$filter=$clients->table->buildWhereArrayFromRequest();

switch($action){
	case 'list':$page="staff.php?action=show" ;
				$filter=$clients->table->buildWhereArrayFromRequest();
				$clients->getClientsList('AJAX', $orderby, $dir, $filter); break;
	
				
	default : echo ("<tr class=\"row\"><td colspan=\"10\">No action given</td></tr>");
}