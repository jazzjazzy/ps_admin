<?php
/*require_once DIR_ROOT.'/classes/db.php';
 require_once DIR_ROOT.'/classes/error.class.php';
 require_once DIR_ROOT.'/classes/table.class.php';
 require_once DIR_ROOT.'/classes/template.class.php';
 require_once DIR_ROOT.'/classes/staff.class.php';
 require_once DIR_ROOT.'/classes/fund.class.php';
 */
require_once DIR_ROOT.'/classes/servers.class.php';
require_once DIR_ROOT.'/classes/users.class.php';
require_once DIR_ROOT.'/classes/accounts.class.php';
require_once DIR_ROOT.'/classes/databases.class.php';
class clients {

	private $db_connect;
	private $db;
	public $table;
	public $template;

	private $servers;
	private $users;
	private $accounts;
	private $databases;
	
	private $fields =array('client_id', 'business_name', 'ABN', 'address', 'address_2', 'address_3', 'phone', 'fax', 'create_date', 'modify_date', 'delete_date', 'user_name', 'user_password');
	private $fields_required = array('business_name');
	private $fields_validation_type = array ('client_id'=>'INT', 'business_name'=>'TEXT', 'ABN'=>'TEXT', 'address'=>'TEXT', 'address_2'=>'TEXT', 'address_3'=>'TEXT', 'phone'=>'TEXT', 'fax'=>'TEXT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT', 'user_name'=>'TEXT', 'user_password'=>'TEXT');

	private $fields_create =array('client_id', 'business_name', 'ABN', 'address', 'address_2', 'address_3', 'phone', 'fax', 'create_date', 'modify_date', 'delete_date', 'user_name', 'user_password');
	private $fields_required_create = array('business_name', 'user_name', 'user_password');
	private $fields_validation_type_create = array ('client_id'=>'INT', 'business_name'=>'TEXT', 'ABN'=>'TEXT', 'address'=>'TEXT', 'address_2'=>'TEXT', 'address_3'=>'TEXT', 'phone'=>'TEXT', 'fax'=>'TEXT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT', 'user_name'=>'TEXT', 'user_password'=>'TEXT');
	
	function __construct(){
		$this->db = new db();

		try {
			$this->db_connect = $this->db->dbh;
		} catch (CustomException $e) {
			$e->logError();
		}

		$this->table = new table();
		$this->template = new template();
		$this->servers = new servers();
		$this->users = new users();
		$this->accounts = new accounts();
		$this->databases = new databases();

	}

	Private function lists($orderby=NULL, $direction='ASC', $filter=NULL){

		$sql = "SELECT client_id,
					business_name,
					ABN,
					address,
					suburb,
					state,
					postcode,
					phone,
					fax,
					account_name,
					DATE_FORMAT(clients.create_date, '%d/%m/%Y') AS create_date,
					DATE_FORMAT(clients.modify_date, '%d/%m/%Y') AS modify_date,
					DATE_FORMAT(clients.delete_date, '%d/%m/%Y') AS delete_date
				FROM clients 
					LEFT JOIN accounts ON clients.account_id = accounts.account_id
				WHERE (clients.delete_date ='00-00-0000 00:00:00' OR clients.delete_date IS NULL)";

		if(is_array($filter)){
			foreach($filter AS $key=>$value){
				if ($value != 'NULL'  && !empty($value)){
					$sql .=  " AND ". $value;
				}
			}
		}

		if($orderby){
			$sql .= " ORDER BY ". $orderby." ".$direction;
		}

		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}

		return $result;
	}

	Private function create($source){
		try{

			$this->db_connect->beginTransaction();
			//insert Client information
			foreach($source['clients'] AS $key=>$val){
				$field[] = $key;
				$value[] = ":".$key;
			}
			$sql = "INSERT INTO clients (".implode(', ',$field).") VALUES (".implode(', ',$value).");";

			foreach($source['clients'] AS $key=>$val){
				$exec[":".$key] = $val;
			}
			
			try{
				$client_id = $this->db->insert($sql, $exec); 
			}catch(CustomException $e){
				throw new CustomException($e->queryError($sql));
			}
			
			$databaseName="client_".$client_id;
			
			//insert initial User information
			foreach($source['users'] AS $key=>$val){
					$field2[] = $key;
					$value2[] = ":".$key;
			}
			$sql = "INSERT INTO users (".implode(', ',$field2).") VALUES (".implode(', ',$value2).");";
			
			foreach($source['users'] AS $key=>$val){
				$exec2[":".$key] = $val;
			}
			try{
				$user_id = $this->db->insert($sql, $exec2); 
			}catch(CustomException $e){
				throw new CustomException($e->queryError($sql));
			}
			
			//insert the connection initial user to the to the client
			$sql = "INSERT INTO clients_users (client_id, user_id) VALUES ($client_id, $user_id);";
			
			try{
				$this->db->insert($sql); 
			}catch(CustomException $e){
				throw new CustomException($e->queryError($sql));
			}
			
			$this->databases->addClientsConnectionString($source['databases']['database_id'], $client_id);
			
		}

		catch (CustomException $e) {
			$e->queryError($sql);
			$this->db_connect->rollBack();
			return false;
		}
		
		$this->createClientDatabase($client_id);
		
		return $client_id;
			
	}

	Private function read($id){

		$sql = "SELECT clients.client_id,
					business_name,
					ABN,
					address,
					suburb,
					state,
					postcode,
					phone,
					fax,
					account_name,
					clients.account_id,
					DATE_FORMAT(clients.create_date, '%d/%m/%Y %h:%i:%s') AS create_date,
					DATE_FORMAT(clients.modify_date, '%d/%m/%Y %h:%i:%s') AS modify_date,
					DATE_FORMAT(clients.delete_date, '%d/%m/%Y %h:%i:%s') AS delete_date
				FROM clients 
					LEFT JOIN accounts ON clients.account_id = accounts.account_id 
				WHERE clients.client_id = ". $id;

		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}
			
		return $result[0];

			
	}

	Private function update($source, $id){
		try{
			$this->db_connect->beginTransaction();

			foreach($source['clients'] AS $key=>$val){
				$field[] = $key." = :".$key;
			}

			$sql = "UPDATE clients SET ".implode(', ',$field)." WHERE client_id =". $id;

			$stmt = $this->db_connect->prepare($sql);

			foreach($source['clients'] AS $key=>$val){
				$exec[":".$key] = $val;
			}
			$stmt->execute($exec);


			if ($stmt->errorCode() != 00000 )
			{
				$this->error->set_error($stmt->errorInfo(), $sql);
				$this->error->get_error();
				$this->db_connect->rollBack();
			}
			 

			//$id = $this->db_connect->lastInsertId();
			$source['clients']['client_id'] = $id;

		}

		catch (Exception $e) {
			$this->error->set_error($stmt->errorInfo(), $sql);
			$this->error->get_error();
			$this->db_connect->rollBack();
		}
			
		header('Location:clients.php?action=show&id='.$id);
			
	}

	Private function remove($id){
			if(empty($id)){
				return false;
			}
			$sql = "UPDATE clients SET delete_date=NOW() WHERE client_id =". $id;
			echo $sql;
			try{
				$result = $this->db->insert($sql);
			}catch(CustomException $e){
				echo $e->queryError($sql);
			}
			return true;
	}
	


	/******************* END CRUD METHOD*************************/

	public function getClientsList($type='TABLE',$orderby=NULL, $direction='ASC', $filter=NULL){

		$result = $this->lists($orderby, $direction, $filter);

		$this->table->removeColumn(array('client_id', 'create_date', 'modify_date', 'delete_date', 'phone', 'fax', 'address'));
		
		switch(strtoupper($type)){

			case 'AJAX' : $this->table->setRowsOnly();
			$this->table->setIdentifier('client_id');
			$this->table->setIdentifierPage('clients');
			echo $this->table->genterateDisplayTable($result);

			BREAK;
			case 'TABLE' :
			DEFAULT :
				$this->table->setHeader(array(
						'client_id'=>'Client Id',
						'business_name'=>'Name',
						'ABN'=>'ABN',
						'suburb'=>'Suburb',
						'state'=>'State',
						'postcode'=>'Post Code',
						'account_name'=>'Account'));

				$this->table->setFilter(array(
						'client_id'=>'TEXT',
						'business_name'=>'TEXT',
						'suburb'=>'TEXT',
						'state'=>'COMPILED',
						'postcode'=>'TEXT',
						'account_name'=>'COMPILED'));

				$this->table->setIdentifier('client_id');

				$this->template->content(box($this->table->genterateDisplayTable($result),'Client List', 'Show List of current active clients for People Scope, You can filter this list by using the filter fields under each heading or change the sort order by clickng on the heading'));

				$this->template->display();
		}
	}

	Public function showClientsDetails($id, $return=false){
		$staffMember = $this->read($id);

		$this->template->page('clients.tpl.html');

		$this->templateClientsLayout($staffMember);
		
		$servers = $this->servers->getServerByClientId($id);
		$users = $this->users->getUsersByClientId($id);
		$account = $this->accounts->getAccountTypeByClientId($id);	
		
		$accountHtml = "<table style=\"float:left\">";
		$accountHtml .= "<tr><td>Type</td><td>".$account['account_name']."</td></tr>";
		$accountHtml .= "<tr><td>Cost</td><td>$ ".$account['account_cost']."</td></tr>";
		$accountHtml .= "<tr><td>Advertising</td><td>".$account['account_advertising_numbers']."</td></tr>";
		$accountHtml .= "</table>";
		
		$serverHtml = '';
		foreach($servers AS $colval){
			$serverHtml .= "<table style=\"float:left\">";
			$serverHtml .= "<tr><th colspan=\"2\">".$colval['connection_details']."</th></tr>";
			$serverHtml .= "<tr><td>Host</td><td>".$colval['server_host']."</td></tr>";
			$serverHtml .= "<tr><td>Port</td><td>".$colval['server_port']."</td></tr>";
			$serverHtml .= "<tr><td>Database</td><td>".$colval['server_database']."</td></tr>";
			$serverHtml .= "<tr><td>Type</td><td>".$colval['server_type']."</td></tr>";
			$serverHtml .= "</table>";
		}
		
		$usersHtml = '';
		
		$this->table->setHeader(array(
				'username'=>'User Name',
				'name'=>'Name',
				'email'=>'Email',
				'create_date'=>'Created',
				'last_login'=>'Last Login'
				));

		$this->table->setFilter(array(
				'username'=>'TEXT',
				'name'=>'TEXT',
				'email'=>'TEXT',
				'create_date'=>'TEXT',
				'last_login'=>'TEXT'));

		$this->table->removeColumn(array('admin_id','password', 'level', 'created_by', 'modified_date', 'modified_by', 'delete_date', 'deleted_by'));

		$this->table->setIdentifier('admin_id');
		$this->table->setIdentifierPage('users.php');
		$usersHtml = $this->table->genterateDisplayTable($users);

		@$this->template->assign('account_name', $staffMember['account_name']);
		@$this->template->assign('account',box($accountHtml, 'Account Type', 'This Show the current account type that this client is currently using'));
		@$this->template->assign('server', $serverHtml);
		@$this->template->assign('user', $usersHtml);
		
		
		//if($this->checkAdminLevel(1)){
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"location.href='clients.php?action=edit&id=".$id."'\">Edit</div><div class=\"button\" onclick=\"location.href='clients.php?action=delete&id=".$id."'\">delete</div>");
		//}

		echo $this->template->fetch();
	}

	Public function editClientsDetails($id){

		$staffMember = $this->read($id);

		$name = 'editclients';

		$this->template->page('clients.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="clients.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');

		$this->templateClientsLayout($staffMember, true);
		
		$servers = $this->servers->getServerByClientId($id);
		$users = $this->users->getUsersByClientId($id);
		$account = $this->accounts->getAccountTypeByClientId($id);	
		
		$accountHtml = "<table style=\"float:left\">";
		$accountHtml .= "<tr><td>Type</td><td>".$account['account_name']."</td></tr>";
		$accountHtml .= "<tr><td>Cost</td><td>$ ".$account['account_cost']."</td></tr>";
		$accountHtml .= "<tr><td>Advertising</td><td>".$account['account_advertising_numbers']."</td></tr>";
		$accountHtml .= "</table>";
		
		$serverHtml = '';
		foreach($servers AS $colval){
			$serverHtml .= "<table style=\"float:left\">";
			$serverHtml .= "<tr><th colspan=\"2\">".$colval['connection_details']."</th></tr>";
			$serverHtml .= "<tr><td>Host</td><td>".$colval['server_host']."</td></tr>";
			$serverHtml .= "<tr><td>Port</td><td>".$colval['server_port']."</td></tr>";
			$serverHtml .= "<tr><td>Database</td><td>".$colval['server_database']."</td></tr>";
			$serverHtml .= "<tr><td>Type</td><td>".$colval['server_type']."</td></tr>";
			$serverHtml .= "</table>";
		}
		
		$usersHtml = '';
		
		$this->table->setHeader(array(
				'username'=>'User Name',
				'name'=>'Name',
				'email'=>'Email',
				'create_date'=>'Created',
				'last_login'=>'Last Login'
				));

		$this->table->setFilter(array(
				'username'=>'TEXT',
				'name'=>'TEXT',
				'email'=>'TEXT',
				'create_date'=>'TEXT',
				'last_login'=>'TEXT'));

		$this->table->removeColumn(array('admin_id','password', 'level', 'created_by', 'modified_date', 'modified_by', 'delete_date', 'deleted_by'));

		$this->table->setIdentifier('admin_id');
		$this->table->setIdentifierPage('users.php');
		$usersHtml = $this->table->genterateDisplayTable($users);
	
		@$this->template->assign('account_name', $this->accounts->getSelectListOfAccounts('account_id', $staffMember['account_id']));
		@$this->template->assign('account',box($accountHtml, 'Account Type', 'This Show the current account type that this client is currently using'));
		@$this->template->assign('server', $serverHtml);
		@$this->template->assign('user', $usersHtml);
			
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='clients.php?action=show&id=".$id."'\">Cancel</div>");

		$this->template->display();
	}


	Public function updateClientsDetails($id){

		if ($this->Validate($_REQUEST)){

			$request = $_REQUEST;
			$table = 'clients';

			$save[$table]['business_name'] = $request['business_name'];
			$save[$table]['ABN'] = $request['ABN'];
			$save[$table]['address'] = $request['address'];
			$save[$table]['suburb'] = $request['suburb'];
			$save[$table]['state'] = $request['state'];
			$save[$table]['postcode'] = $request['postcode'];
			$save[$table]['phone'] = $request['phone'];
			$save[$table]['fax'] = $request['fax'];
			$save[$table]['account_id'] = $request['account_id'];
			$save[$table]['modify_date'] = date('Y-m-d h:i:s');


			$this->update($save, $id );

		}else{

			$staffMember = $this->valid_field;
			$error = $this->validation_error;

			$name = 'editgrant';

			$this->template->page('clients.tpl.html');

			foreach($error AS $key=>$value){
				$this->template->assign('err_'.$key, "<span class=\"error\">".@implode(',', $error[$key])."</spam>");
			}

			$this->template->assign('FORM-HEADER', '<form action="clients.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');

			$this->templateClientsLayout($staffMember, true);
			$this->template->assign('account_name', $this->accounts->getSelectListOfAccounts('account_id'),$staffMember['account_name'] );
			$this->template->assign('database_host', $this->databases->getListOfDatabases(), $staffMember['account_name']);

			//if($this->admin->checkAdminLevel(1)){
				$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='clients.php?action=show&id=".$id."'\">Cancel</div>");
			//}
			$this->template->assign('FORM-FOOTER', '</form>');

			$this->template->display();
		}
	}


	Public function createClientsDetails(){

		$name = 'createAdmin';

		$this->template->page('clients-create.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="clients.php?action=save" method="POST" name="'.$name.'">');

		$this->templateClientsLayout('', true);
		$this->template->assign('account_name', $this->accounts->getSelectListOfAccounts('account_id'));
		$this->template->assign('database_host', $this->databases->getListOfDatabases());
		$this->template->assign('user_name', $this->template->input('text', 'user_name'));
		$this->template->assign('user_password', $this->template->input('password', 'user_password'));
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Save</div><div class=\"button\" onclick=\"location.href='admin.php?action=list'\">Cancel</div>");


		$this->template->display();
	}

	Public function saveClientsDetails(){

		if ($this->Validate($_REQUEST, 'create')){

			$request = $_REQUEST;
			$table = 'clients';

			$save[$table]['business_name'] = $request['business_name'];
			$save[$table]['ABN'] = $request['ABN'];
			$save[$table]['address'] = $request['address'];
			$save[$table]['suburb'] = $request['suburb'];
			$save[$table]['state'] = $request['state'];
			$save[$table]['postcode'] = $request['postcode'];
			$save[$table]['phone'] = $request['phone'];
			$save[$table]['fax'] = $request['fax'];
			$save[$table]['account_id'] = $request['account_id'];
			$save[$table]['create_date'] = date('Y-m-d h:i:s');
			
			$table = 'users';

			$save[$table]['user_name'] = $request['user_name'];
			$save[$table]['user_password'] = $request['user_password'];
			$save[$table]['create_date'] = date('Y-m-d h:i:s');
			
			$table = 'databases';
			$save[$table]['database_id'] = $request['database_id'];
			
			$id = $this->create($save);
			header('Location:clients.php?action=show&id='.$id);
			exit();
			
		}else{

			//$staffMember = $_REQUEST;
			$staffMember = $this->valid_field;

			$error = $this->validation_error;

			$name = 'creategrant';

			$this->template->page('clients-create.tpl.html');

			foreach($error AS $key=>$value){
				$this->template->assign('err_'.$key, "<span class=\"error\">".@implode(',', $error[$key])."</spam>");
			}
			$this->template->assign('FORM-HEADER', '<form action="clients.php?action=save" method="POST" name="'.$name.'">');

			$this->templateClientsLayout($staffMember, true);
			$this->template->assign('account_name', $this->accounts->getSelectListOfAccounts('account_id'));
			$this->template->assign('database_host', $this->databases->getListOfDatabases());
			$this->template->assign('user_name', $this->template->input('text', 'user_name', $staffMember['user_name']));
			$this->template->assign('user_password', $this->template->input('password', 'user_password', $staffMember['user_password']));
		
			
			//if($this->admin->checkAdminLevel(1)){
				$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">save</div><div class=\"button\" onclick=\"location.href='clients.php'\">Cancel</div>");
			//}
			$this->template->assign('FORM-FOOTER', '</form>');

			$this->template->display();
		}
	}

	Public function deleteClientsDetails($id){
		$this->remove($id);
		header('Location: clients.php');
	}
	
	private function templateClientsLayout($staffMember, $input = false, $inputArray=array() ){

		$id = @$staffMember['client_id'];

		$this->template->assign('title', @$staffMember['business_name']);

	
		@$this->template->assign('business_name', ($input)? $this->template->input('text', 'business_name', $staffMember['business_name']):$staffMember['business_name']);
		@$this->template->assign('ABN', ($input)? $this->template->input('text', 'ABN', $staffMember['ABN']):$staffMember['ABN']);
		@$this->template->assign('address', ($input)? $this->template->input('text', 'address', $staffMember['address']):$staffMember['address']);
		@$this->template->assign('suburb', ($input)? $this->template->input('text', 'suburb', $staffMember['suburb']):$staffMember['suburb']);
		@$this->template->assign('state', ($input)? $this->template->input('text', 'state', $staffMember['state']):$staffMember['state']);
		@$this->template->assign('postcode', ($input)? $this->template->input('text', 'postcode', $staffMember['postcode']):$staffMember['postcode']);
		@$this->template->assign('phone', ($input)? $this->template->input('text', 'phone', $staffMember['phone']):$staffMember['phone']);
		@$this->template->assign('fax', ($input)? $this->template->input('text', 'fax', $staffMember['fax']):$staffMember['fax']);
		@$this->template->assign('create_date', $staffMember['create_date']);
		@$this->template->assign('modify_date', $staffMember['modify_date']);
		@$this->template->assign('delete_date', $staffMember['delete_date']);

	}

	public function Validate($request, $type = NULL){

		
		unset($this->valid_field);
		unset($this->validation_error);
		$isvalid = True;

		if($type == 'create')
		{	
			$validfields = $this->fields_create;
			$requiredfields = $this->fields_required_create;
			$fieldsvalidationtype = $this->fields_validation_type_create;
		}else{
			$validfields = $this->fields;
			$requiredfields = $this->fields_required;
			$fieldsvalidationtype = $this->fields_validation_type;
			
		}
		foreach ($request AS $key=>$value){ //lets strip put unwanted or security violation fields
			if(in_array($key, $validfields)){
				$this->valid_field[$key] = $value; //pure fields
			}
		}

		foreach ($validfields AS $value){ //now lets just add fields as blank if they didn't come though so we can check them, helps with checkboxs
			if(!isset($this->valid_field[$value])){
				$this->valid_field[$value] = '';
			}
		}

		if(count($requiredfields) > 0 ){
			foreach($requiredfields AS $value){ // lets check all the required fields have a value
				if (empty($this->valid_field[$value]) || $this->valid_field[$value] == 'NULL'){
					$this->validation_error[$value][] = 'Field is Required'; //error field
					$isvalid = false;
				}
			}
		}



		//now lets validate
		foreach ($this->valid_field AS $key=>$value){
			$value = trim($value);
			if(!empty($value)){ // don't cheak if empty, alread done in required check

				switch(@$fieldsvalidationtype[$key]){
					case 'TEXTAREA': if (strlen($value) > 1024) {
						$this->validation_error[$key][] = 'Field longer then 1024 charactors';
						$isvalid = false;
					} break;
					case 'TEXT': if (strlen($value) > 1024) {
						$this->validation_error[$key][] = 'Field longer then 1024 charactors';
						$isvalid = false;
					} break;
					case 'SAP': if ((!is_numeric($value)) || (strlen($value) != 10)) {
						$this->validation_error[$key][] = 'not a valid SAP number';
						$isvalid = false;
					} break;
					case 'DECIMAL': if (!is_numeric($value)) {
						$this->validation_error[$key][] = 'Decimal value expected';
						$isvalid = false;
					} break;
					case 'BOOL': if ((!is_bool($value)) && (strtoupper($value)!="YES") && ($value != 1)) {
						$this->validation_error[$key][] = 'Please check';
						$isvalid = false;
					} break;
					case 'INT': if (!is_numeric($value) && $value != 'NULL' ){
						$this->validation_error[$key][] = 'Numeric value expected';
						$isvalid = false;
					} break;
					case 'DATE': $date = str_replace('/', '-', $value);
					$date = str_replace("\\", '-', $date);
					@list($day, $month, $year) = explode('-', $date);
					if(!checkdate($month,$day, $year)){
						$this->validation_error[$key][] = 'incorrect date format, expecting dd/mm/yyyy';
						$isvalid = false;
					} break;
					case 'YEAR':  if(!checkYear($value)){
						$this->validation_error[$key][] = 'incorrect year format, expecting yyyy';
						$isvalid = false;
					} break;
						
				}
			}
		}

		return $isvalid;

	}
	
	public function createClientDatabase($id){
		
		$sql = 'SELECT * 
				FROM clients_server_connection 
					LEFT JOIN server_connection ON clients_server_connection.connection_id = server_connection.connection_id 
				WHERE clients_server_connection.client_id ='.$id;
		
		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}
		
		$datab = $result[0];

		try {
			$conn = new PDO(strtolower($datab['server_type']).":host=".$datab['server_host'].";port=".$datab['server_port'], 'root', 'password');
		} catch (PDOException $e) {
			echo $e->getMessage();
		}
		
		$conn->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$sql = 'CREATE DATABASE '.$datab['server_database'].';';
		
		try{
			$stmt = $conn->prepare($sql);
			$stmt->execute();
		}catch(CustomException $e){
			echo  $e->getMessage();
		}
		sleep(2);
		try {
			$conn = new PDO(strtolower($datab['server_type']).":dbname=".$datab['server_database'].";host=".$datab['server_host'].";port=".$datab['server_port'], 'root', 'password');
		} catch (PDOException $e) {
			echo $e->getMessage();
		}
		
		$s = file('master-schema.sql');
		$script = implode("\n", $s );
		$scriptArry = explode(';', $script );

		foreach($scriptArry AS $sql){
			try{
				$stmt = $conn->prepare($sql);
				$stmt->execute();
			}catch(CustomException $e){
				echo  $e->getMessage();
			}
		}
		
		$sql = "SELECT users.user_id,
					   user_name,
					   user_password
				 FROM clients_users 
				 	LEFT JOIN users ON clients_users.user_id = users.user_id 
				 WHERE client_id = ".$id;
		
		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}
		
		foreach($result AS $value){
			$sql = "INSERT into users (user_id, username, password, create_date) values('".$value['user_id']."', '".$value['user_name']."', '".$value['user_password']."', NOW())";	
			echo $sql;
			try{
				$stmt = $conn->prepare($sql);
				$stmt->execute();
			}catch(CustomException $e){
				echo  $e->getMessage();
			}
		}

	}
	
}