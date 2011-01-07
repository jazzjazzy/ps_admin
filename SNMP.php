<!-- /*******************************************************************
 * Mikrotik SNMP signal reader by Perica Nikolic
 * Contact npero2@gmail.com
 * This copyright notice MUST stay intact for use.
 *
 * This is free software; you can redistribute it and/or modify.
 * This script is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 * or FITNESS FOR A PARTICULAR PURPOSE.
 ********************************************************************/
 -->
<?php
require('config/config.php');

// Date in the past
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");

// always modified
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
 
// HTTP/1.1
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);

// HTTP/1.0
header("Pragma: no-cache");
?>
<html>
<head>
	<META HTTP-EQUIV="REFRESH" CONTENT="10">
	<link href="stil.css" type="text/css" rel="stylesheet" />	
</head>
<body>
<?php


$ip="10.1.1.3";    //Change IP to your host names, address
$mask_mac=FALSE;        //Use to mask MAC adress (true / false );



$tx_bytes_snmp = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.4.2.1");  

//pp($tx_bytes_snmp);

foreach ($tx_bytes_snmp as $indexOID => $rssi){
	if($rssi == '"mysqld"'){
		$server['mysql'] = $rssi;
	}
}

$tx_bytes_snmp2 = snmpwalk("$ip", "public", "1.3.6.1.2.1.1.1"); 
$server['server'] = $tx_bytes_snmp2[0];

$tx_bytes_snmp2 = snmpwalk("$ip", "public", "1.3.6.1.2.1.1.3"); 
$server['uptime'] = $tx_bytes_snmp2[0];

$tx_bytes_snmp2 = snmpwalk("$ip", "public", "1.3.6.1.2.1.1.4"); 
$server['??'] = $tx_bytes_snmp2[0];

pp($server);

$tx_bytes_snmp = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.2.3.1.1");  

echo "<table>";
$tx_bytes_snmp3 = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.2.3.1.3");  
echo "<tr>";
foreach($tx_bytes_snmp AS $key=>$value){
	echo "<td>".$tx_bytes_snmp3[".1.3.6.1.2.1.25.2.3.1.3.".$value]."</td>";
}
echo "</tr>";
$tx_bytes_snmp3 = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.2.3.1.4");  
echo "<tr>";
foreach($tx_bytes_snmp AS $key=>$value){
	echo "<td>".$tx_bytes_snmp3[".1.3.6.1.2.1.25.2.3.1.4.".$value]."</td>";
}
echo "</tr>";
$tx_bytes_snmp3 = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.2.3.1.5");  
echo "<tr>";
foreach($tx_bytes_snmp AS $key=>$value){
	echo "<td>".$tx_bytes_snmp3[".1.3.6.1.2.1.25.2.3.1.5.".$value]."</td>";
}
echo "</tr>";
$tx_bytes_snmp3 = snmpwalkoid("$ip", "public", "1.3.6.1.2.1.25.2.3.1.6");  
echo "<tr>";
foreach($tx_bytes_snmp AS $key=>$value){
	echo "<td>".$tx_bytes_snmp3[".1.3.6.1.2.1.25.2.3.1.6.".$value]."</td>";
}
echo "</table>";



$tx_bytes_snmp = snmpwalkoid("10.1.1.1", "public", "SNMPv2-MIBS::system");  
pp($tx_bytes_snmp);
