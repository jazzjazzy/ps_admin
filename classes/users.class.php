<?php
/*require_once DIR_ROOT.'/classes/db.php';
 require_once DIR_ROOT.'/classes/error.class.php';
 require_once DIR_ROOT.'/classes/table.class.php';
 require_once DIR_ROOT.'/classes/template.class.php';
 require_once DIR_ROOT.'/classes/staff.class.php';
 require_once DIR_ROOT.'/classes/fund.class.php';
 */
class users {

	private $db_connect;
	private $db;
	public $lastError;
	public $table;
	public $template;
	private $error;
	public $admin;
	private $fields =array('user_id', 'user_name', 'password', 'create_date', 'modify_date', 'delete_date');
	private $fields_required = NULL;
	private $fields_validation_type = array ('user_id'=>'INT', 'user_name'=>'TEXT', 'password'=>'TEXT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT');

	function __construct(){
		$this->db = new db();

		try {
			$this->db_connect = $this->db->dbh;
		} catch (CustomException $e) {
			$e->logError();
		}

		$this->table = new table();
		$this->template = new template();

	}

	Private function lists($orderby=NULL, $direction='ASC', $filter=NULL){

		$sql = "SELECT users.user_id,
					user_name,
					clients.business_name,
					DATE_FORMAT(users.create_date, '%d/%m/%Y') AS create_date,
					DATE_FORMAT(users.modify_date, '%d/%m/%Y') AS modify_date,
					DATE_FORMAT(users.delete_date, '%d/%m/%Y') AS delete_date 
				FROM users 
					LEFT OUTER JOIN clients_users ON users.user_id = clients_users.user_id
					LEFT OUTER JOIN clients ON clients_users.client_id = clients.client_id
				WHERE (users.delete_date ='00-00-0000 00:00:00' OR users.delete_date IS NULL)";

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

			foreach($source['users'] AS $key=>$val){
				$field[] = $key;
				$value[] = ":".$key;
			}

			$sql = "INSERT INTO users (".implode(', ',$field).") VALUES (".implode(', ',$value).");";

			$result = $this->db_connect->prepare($sql);

			foreach($source['users'] AS $key=>$val){
				$exec[":".$key] = $val;
			}
			$result->execute($exec);

			$pid = $this->db_connect->lastInsertId();
		}

		catch (Exception $e) {
			echo $e->getMessage().'<p>Unable to complete transaction!</p>';
			$this->db_connect->rollBack();
		}
			
			
		return $pid;
			
	}

	Private function read($id){

		/*$sql = "SELECT users.user_id,
					user_name,
					clients.business_name,
					DATE_FORMAT(users.create_date, '%d/%m/%Y %h:%i:%s') AS create_date,
					DATE_FORMAT(users.modify_date, '%d/%m/%Y %h:%i:%s') AS modify_date,
					DATE_FORMAT(users.delete_date, '%d/%m/%Y %h:%i:%s') AS delete_date 
				FROM users 
					LEFT OUTER JOIN clients_users ON users.user_id = clients_users.user_id
					LEFT OUTER JOIN clients ON clients_users.client_id = clients.client_id 
				WHERE users.user_id = ". $id ." AND (users.delete_date ='00-00-0000 00:00:00' OR users.delete_date IS NULL)" ;*/
		
		$sql = 'SELECT * 
				FROM clients_users
					LEFT JOIN clients_server_connection ON clients_users.client_id = clients_server_connection.client_id
					LEFT JOIN server_connection ON clients_server_connection.connection_id = server_connection.connection_id 
				WHERE clients_users.user_id ='.$id;
		
		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}

		$datab = $result[0];
		
		try {
			$conn = new PDO(strtolower($datab['server_type']).":dbname=".$datab['server_database'].";host=".$datab['server_host'].";port=".$datab['server_port'], 'root', 'password');
		} catch (PDOException $e) {
			echo $e->getMessage();
		}

		$sql = "SELECT * FROM users WHERE user_id = ".$id;

		try{
			$stmt = $conn->prepare($sql);
			$result = $stmt->execute();
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);

		return $result[0];

	}

	Private function update($source, $id){
		try{
			$this->db_connect->beginTransaction();

			foreach($source['users'] AS $key=>$val){
				$field[] = $key." = :".$key;
			}

			$sql = "UPDATE users SET ".implode(', ',$field)." WHERE user_id =". $id;

			$stmt = $this->db_connect->prepare($sql);

			foreach($source['users'] AS $key=>$val){
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
			$source['users']['user_id'] = $id;

		}

		catch (Exception $e) {
			$this->error->set_error($stmt->errorInfo(), $sql);
			$this->error->get_error();
			$this->db_connect->rollBack();
		}
			
		header('Location:users.php?action=show&id='.$id);
			
	}

	Private function remove($id){
		if(empty($id)){
			return false;
		}

		try{
			$this->db_connect->beginTransaction();

			$sql = "UPDATE server_connection SET delete_date=NOW() WHERE user_id =". $id;

			$stmt = $this->db_connect->prepare($sql);

			$stmt->execute();
		}

		catch (Exception $e) {
			echo $e->getMessage().'<p>Unable to complete transaction!</p>';
			$this->db_connect->rollBack();
			return false;
		}

		return true;
	}


	/******************* END CRUD METHOD*************************/

	public function getUsersList($type='TABLE',$orderby=NULL, $direction='ASC', $filter=NULL){

		$result = $this->lists($orderby, $direction, $filter);

		switch(strtoupper($type)){

			case 'AJAX' : $this->table->setRowsOnly();
			$this->table->removeColumn(array('user_id', 'create_date', 'modify_date', 'delete_date'));
			$this->table->setIdentifier('user_id');
			$this->table->setIdentifierPage('users');
			echo $this->table->genterateDisplayTable($result);

			BREAK;
			case 'TABLE' :
			DEFAULT :
				$this->table->setHeader(array(
						'user_id'=>'User Id',
						'user_name'=>'User Name',
						'business_name'=>'Business Name'));

				$this->table->setFilter(array(
						'user_id'=>'TEXT',
						'user_name'=>'TEXT',
						'business_name'=>'COMPILED'));

				$this->table->removeColumn(array('user_id', 'create_date', 'modify_date', 'delete_date'));

				$this->table->setIdentifier('user_id');

				$this->template->content(Box($this->table->genterateDisplayTable($result), "List of users", 'List of all the user that have login access to People Scope, You can filter this list by using the filter fields under each heading or change the sort order by clickng on the headin'  ));

				$this->template->display();
		}
	}

	Public function showUsersDetails($id, $return=false){
		$staffMember = $this->read($id);

		$this->template->page('users.tpl.html');

		$this->templateUsersLayout($staffMember);

		//if($this->checkAdminLevel(1)){
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"location.href='users.php?action=edit&id=".$id."'\">Edit</div>");
		//}

		echo $this->template->fetch();
	}

	Public function editUsersDetails($id){

		$staffMember = $this->read($id);

		$name = 'editusers';

		$this->template->page('users.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="users.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');

		$this->templateUsersLayout($staffMember, true);

		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='users.php?action=show&id=".$id."'\">Cancel</div>");

		$this->template->display();
	}


	Public function updateUsersDetails($id){

		if ($this->Validate($_REQUEST)){

			$request = $_REQUEST;
			$table = 'users';

			$save[$table]['user_name'] = $request['user_name'];$save[$table]['password'] = $request['password'];
			$save[$table]['modify_date'] = date('Y-m-d h:i:s');

			$this->update($save, $id );

		}else{

			$staffMember = $this->valid_field;
			$error = $this->validation_error;

			$name = 'editgrant';

			$this->template->page('users.tpl.html');

			foreach($validfields AS $value){
				if(isset($error[$value])){
					$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
				}
			}

			$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');

			$this->templateUsersLayout($staffMember, true);

			if($this->admin->checkAdminLevel(1)){
				$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
			}
			$this->template->assign('FORM-FOOTER', '</form>');

			$this->template->display();
		}
	}


	Public function createUsersDetails(){

		$name = 'createAdmin';

		$this->template->page('users.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="users.php?action=save" method="POST" name="'.$name.'">');

		$this->templateUsersLayout('', true);

		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Save</div><div class=\"button\" onclick=\"location.href='admin.php?action=list'\">Cancel</div>");


		$this->template->display();
	}

	Public function saveUsersDetails(){

		if ($this->Validate($_REQUEST)){

			$request = $_REQUEST;
			$table = 'users';

			$save[$table]['user_name'] = $request['user_name'];
			$save[$table]['password'] = $request['password'];
			$save[$table]['create_date'] = date('Y-m-d h:i:s');

			$this->create($save);

		}else{

			$staffMember = $this->valid_field;
			$error = $this->validation_error;

			$name = 'editgrant';

			$this->template->page('users.tpl.html');

			foreach($validfields AS $value){
				if(isset($error[$value])){
					$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
				}
			}

			$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');

			$this->templateUsersLayout($staffMember, true);

			if($this->admin->checkAdminLevel(1)){
				$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
			}
			$this->template->assign('FORM-FOOTER', '</form>');

			$this->template->display();
		}
	}


	private function templateUsersLayout($staffMember, $input = false, $inputArray=array() ){

		$id = @$staffMember['user_id'];

		/*$this->template->assign('title', $staffMember['industry_sap_account_fund']." - ".$staffMember['industry_source_discription']);*/

		/*@$this->template->assign('user_id', ($input)? $this->template->input('text', 'user_id', $staffMember['user_id']):$staffMember['user_id']);
		@$this->template->assign('user_name', ($input)? $this->template->input('text', 'user_name', $staffMember['user_name']):$staffMember['user_name']);
		@$this->template->assign('business_name', ($input)? $this->template->input('text', 'business_name', $staffMember['business_name']):$staffMember['business_name']);
		*/
		@$this->template->assign('user_id', ($input)? $this->template->input('text', 'user_id', $staffMember['user_id']):$staffMember['user_id']); 
        @$this->template->assign('username', ($input)? $this->template->input('text', 'username', $staffMember['username']):$staffMember['username']); 
        @$this->template->assign('password', ($input)? $this->template->input('text', 'password', $staffMember['user_id']):$staffMember['password']);
        @$this->template->assign('name', ($input)? $this->template->input('text', 'name', $staffMember['name']):$staffMember['name']); 
        @$this->template->assign('email', ($input)? $this->template->input('text', 'email', $staffMember['email']):$staffMember['email']); 
        @$this->template->assign('level', ($input)? $this->template->input('text', 'level', $staffMember['level']):$staffMember['level']); 
        @$this->template->assign('create_date', ($input)? $this->template->input('text', 'create_date', $staffMember['create_date']):$staffMember['create_date']); 
        @$this->template->assign('created_by', ($input)? $this->template->input('text', 'created_by', $staffMember['created_by']):$staffMember['created_by']); 
        @$this->template->assign('modified_date', ($input)? $this->template->input('text', 'modified_date', $staffMember['modified_date']):$staffMember['modified_date']); 
        @$this->template->assign('modified_by', ($input)? $this->template->input('text', 'modified_by', $staffMember['modified_by']):$staffMember['modified_by']); 
        @$this->template->assign('delete_date', ($input)? $this->template->input('text', 'delete_date', $staffMember['delete_date']):$staffMember['delete_date']); 
        @$this->template->assign('deleted_by', ($input)? $this->template->input('text', 'deleted_by', $staffMember['deleted_by']):$staffMember['deleted_by']); 
        @$this->template->assign('active', ($input)? $this->template->input('text', 'active', $staffMember['active']):$staffMember['active']);
        @$this->template->assign('last_login', ($input)? $this->template->input('text', 'last_login', $staffMember['last_login']):$staffMember['last_login']); 
		
		@$this->template->assign('create_date', $staffMember['create_date']);
		@$this->template->assign('modify_date', $staffMember['modify_date']);
		@$this->template->assign('delete_date', $staffMember['delete_date']);

		/*if(isset($id)){
		 $this->template->assign('COMMENTS', $this->comment->getCommentBox($id, 'FUND'));
		 }*/

	}

	public function Validate($request){

		unset($this->valid_field);
		unset($this->validation_error);
		$isvalid = True;

		$validfields = $this->fields;
		$requiredfields = $this->fields_required;
		$fieldsvalidationtype = $this->fields_validation_type;

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

	Public function getUsersByClientId($id){

		$sql = "SELECT users.user_id,
					user_name,
					clients.business_name,
					users.create_date,
					users.modify_date,
					users.delete_date,
					clients.client_id
				FROM users 
					LEFT OUTER JOIN clients_users ON users.user_id = clients_users.user_id
					LEFT OUTER JOIN clients ON clients_users.client_id = clients.client_id
				WHERE (users.delete_date ='00-00-0000 00:00:00' OR users.delete_date IS NULL)
				AND clients.client_id =".$id;

			
		try{
			$result = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}

		$sql = 'SELECT *
				FROM clients_server_connection 
					LEFT JOIN server_connection ON clients_server_connection.connection_id = server_connection.connection_id 
				WHERE clients_server_connection.client_id ='.$id;

		try{
			$result2 = $this->db->select($sql);
		}catch(CustomException $e){
			echo $e->queryError($sql);
		}

		$datab = $result2[0];

		try {
			$conn2 = new PDO(strtolower($datab['server_type']).":dbname=".$datab['server_database'].";host=".$datab['server_host'].";port=".$datab['server_port'], 'root', 'password');
		} catch (PDOException $e) {
			echo $e->getMessage();
		}

		$conn2->setAttribute (PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);


		$sql = "SELECT * FROM users";

		try{
			$stmt = $conn2->prepare($sql);
			$stmt->execute();
		}catch(CustomException $e){
			echo  $e->getMessage();
		}

		$result=$stmt->fetchAll(PDO::FETCH_NAMED);

		return $result;
	}

}