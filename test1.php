<?php
require_once 'config/config.php';
require_once DIR_ROOT.'/classes/clients.class.php';

$clients = new clients();
$clients->createClientDatabase(50);
