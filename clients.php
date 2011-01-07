<?php
require_once 'config/config.php';
require_once DIR_ROOT.'/classes/clients.class.php';

/*$admin->isLoggedIn();*/

$action = (!isset($_REQUEST['action']))? '' : $_REQUEST['action'];
$year = ((!isset($_REQUEST['year']))? DEFAULT_YEAR : $_REQUEST['year']);

$clients = new clients($year);

switch($action){
	case 'edit' : 
			$id = (!isset($_REQUEST['id']))? NULL : $_REQUEST['id'];
			$clients->editClientsDetails($id);
	break;
	case 'delete' : 
			$id = (!isset($_REQUEST['id']))? NULL : $_REQUEST['id'];
			$clients->deleteClientsDetails($id);
	break;
	case 'create' : 
			getSubMenu('create');
			$clients->createClientsDetails();
	break;

	case 'show' :
			 
			$id = (!isset($_REQUEST['id']))? NULL : $_REQUEST['id'];
			$clients->showClientsDetails($id);
	break;
	case 'show-print' :
			$id = (!isset($_REQUEST['id']))? NULL : $_REQUEST['id'];
			$clients->showClientsPrintDetails($id);
	break;
	
	case 'update' : 
			$id = (!isset($_REQUEST['id']))? NULL : $_REQUEST['id'];
			$clients->updateClientsDetails($id);
	break;
	
	case 'save' : 
			getSubMenu('create');
			$clients->saveClientsDetails();
	break;

	default :
			getSubMenu('list');
			echo $clients->getClientsList();
	break;
}


function getSubMenu($action){
	global $clients;
	/*if($clients->admin->checkAdminLevel(1)){
				$create_css = ($action == 'create')? 'tab-button-select' : 'tab-button'; 
				$staff->template->assign('Menu', '<!--<a href="staff.php?action=show-print" class="tab-button">print Bulk Profile</a>
							<a href="staff.php?action=show-print&id=1" class="tab-button">Fin Bulk Profile</a> 
							<a href="staff.php?action=show-print&id=2" class="tab-button">FAA Bulk Profile</a>
							<a href="staff.php?action=show-print&id=3" class="tab-button">MAAIS Bulk Profile</a>-->
							<a href="staff.php?action=create" class="'.$create_css.'">Add Staff</a>
							<a href="external.php" class="tab-button">List Externals</a>
							<br class="clear"/><div id="tab-button-divider">');
	}*/
}