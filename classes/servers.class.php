<?php
/*require_once DIR_ROOT.'/classes/db.php';
require_once DIR_ROOT.'/classes/error.class.php';
require_once DIR_ROOT.'/classes/table.class.php';
require_once DIR_ROOT.'/classes/template.class.php';
require_once DIR_ROOT.'/classes/staff.class.php';
require_once DIR_ROOT.'/classes/fund.class.php';
*/
class servers {
	
	private $db_connect;
	private $db;
	public $lastError;
	public $table;
	public $template;
	private $error;
	public $admin;
	private $fields =array('connection_id', 'connection_details', 'server_host', 'server_port', 'server_database', 'server_type', 'create_date', 'modify_date', 'delete_date');
	private $fields_required = NULL;
	private $fields_validation_type = array ('connection_id'=>'INT', 'connection_details'=>'TEXT', 'server_host'=>'TEXT', 'server_port'=>'TEXT', 'server_database'=>'TEXT', 'server_type'=>'TEXT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT');
	
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
		
		$sql = "SELECT connection_id,
					connection_details,
					server_host,
					server_port,
					server_database,
					server_type,
					DATE_FORMAT(create_date, '%d/%m/%Y') AS create_date,
					DATE_FORMAT(modify_date, '%d/%m/%Y') AS modify_date,
					DATE_FORMAT(delete_date, '%d/%m/%Y') AS delete_date
				FROM server_connection WHERE (server_connection.delete_date ='00-00-0000 00:00:00' OR server_connection.delete_date IS NULL)";
		
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
				
				foreach($source['server_connection'] AS $key=>$val){
					$field[] = $key;
					$value[] = ":".$key;
				}

				$sql = "INSERT INTO server_connection (".implode(', ',$field).") VALUES (".implode(', ',$value).");";

				$result = $this->db_connect->prepare($sql);
				
				foreach($source['server_connection'] AS $key=>$val){
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
	
		$sql = "SELECT connection_id,
						connection_details,
						server_host,
						server_port,
						server_database,
						server_type,
						DATE_FORMAT(create_date, '%d/%m/%Y %h:%i:%s') AS create_date,
						DATE_FORMAT(modify_date, '%d/%m/%Y %h:%i:%s') AS modify_date,
						DATE_FORMAT(delete_date, '%d/%m/%Y %h:%i:%s') AS delete_date
				FROM server_connection WHERE connection_id = ". $id;
		
			$stmt = $this->db_connect->prepare($sql);
			$stmt->execute();
			
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
				
				foreach($source['server_connection'] AS $key=>$val){
					$field[] = $key." = :".$key;
				}

				$sql = "UPDATE server_connection SET ".implode(', ',$field)." WHERE connection_id =". $id;
				
				$stmt = $this->db_connect->prepare($sql);
				
				foreach($source['server_connection'] AS $key=>$val){
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
				$source['server_connection']['connection_id'] = $id;

			}

			catch (Exception $e) {
				$this->error->set_error($stmt->errorInfo(), $sql);
				$this->error->get_error();
				$this->db_connect->rollBack();
			}
			
			header('Location:servers.php?action=show&id='.$id);
			
	}
	
	Private function remove($id){
			if(empty($id)){
				return false;
			}
	
			try{
				$this->db_connect->beginTransaction();
				$sql = "UPDATE server_connection SET delete_date=NOW() WHERE connection_id =". $id;
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
	
	public function getServersList($type='TABLE',$orderby=NULL, $direction='ASC', $filter=NULL){
		
		$result = $this->lists($orderby, $direction, $filter);
		
		switch(strtoupper($type)){
		
			case 'AJAX' : $this->table->setRowsOnly(); 
						  $this->table->removeColumn(array('connection_id', 'create_date', 'modify_date', 'delete_date'));
						  $this->table->setIdentifier('connection_id');
						  $this->table->setIdentifierPage('servers');
						  echo $this->table->genterateDisplayTable($result);
						  
				BREAK;
			case 'TABLE' :
			DEFAULT :
				$this->table->setHeader(array(
						'connection_id'=>'Connection Id',
						'connection_details'=>'Connection Details',
						'server_host'=>'Server Host',
						'server_port'=>'Server Port',
						'server_database'=>'Server Database',
						'server_type'=>'Server Type'));
				
				$this->table->setFilter(array(	
						'connection_id'=>'TEXT',
						'connection_details'=>'TEXT',
						'server_host'=>'TEXT',
						'server_port'=>'COMPILED',
						'server_database'=>'TEXT',
						'server_type'=>'COMPILED'));
				
				$this->table->removeColumn(array('connection_id', 'create_date', 'modify_date', 'delete_date'));
				
				$this->table->setIdentifier('connection_id');
				
				$this->template->content(Box($this->table->genterateDisplayTable($result), 'Connection Strings','Shows the current list of server strings used by clients for People Scope, You can filter this list by using the filter fields under each heading or change the sort order by clickng on the heading '));
				
				$this->template->display();
		}
	}
	
	Public function showServersDetails($id, $return=false){
		$staffMember = $this->read($id);
		
		$this->template->page('servers.tpl.html');
		
		$this->templateServersLayout($staffMember);

		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"location.href='servers.php?action=edit&id=".$id."'\">Edit</div>");

		echo $this->template->fetch();	
	}
	
	Public function editServersDetails($id){
		
		$staffMember = $this->read($id);
		
		$name = 'editservers';
		
		$this->template->page('servers.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="servers.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
		$this->templateServersLayout($staffMember, true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='servers.php?action=show&id=".$id."'\">Cancel</div>");
		
		$this->template->display();
	}
	
	
	Public function updateServersDetails($id){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'server_connection';

				$save[$table]['connection_details'] = $request['connection_details'];
				$save[$table]['server_host'] = $request['server_host'];
				$save[$table]['server_port'] = $request['server_port'];
				$save[$table]['server_database'] = $request['server_database'];
				$save[$table]['server_type'] = $request['server_type'];
				$save[$table]['create_date'] = $request['create_date'];
				$save[$table]['modify_date'] = $request['modify_date'];
				$save[$table]['delete_date'] = $request['delete_date'];
				$save[$table]['modify_date'] = date('Y-m-d h:i:s');
				
				$this->update($save, $id );
				
			}else{
				
				$staffMember = $this->valid_field;
				$error = $this->validation_error;
				
				$name = 'editgrant';
		
				$this->template->page('servers.tpl.html');
				
				foreach($validfields AS $value){
					if(isset($error[$value])){
						$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
					}
				}
				
				$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateServersLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}
	
	
	Public function createServersDetails(){
		
		$name = 'createAdmin';
		
		$this->template->page('servers.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="servers.php?action=save" method="POST" name="'.$name.'">');
		
		$this->templateServersLayout('', true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Save</div><div class=\"button\" onclick=\"location.href='servers.php?action=list'\">Cancel</div>");
		

		$this->template->display();
	} 
	
	Public function saveServersDetails(){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'server_connection';

				$save[$table]['connection_details'] = $request['connection_details'];
				$save[$table]['server_host'] = $request['server_host'];
				$save[$table]['server_port'] = $request['server_port'];
				$save[$table]['server_database'] = $request['server_database'];
				$save[$table]['server_type'] = $request['server_type'];
				$save[$table]['create_date'] = $request['create_date'];
				$save[$table]['modify_date'] = $request['modify_date'];
				$save[$table]['delete_date'] = $request['delete_date'];
				
				$this->create($save );
				
			}else{
				
				$staffMember = $this->valid_field;
				$error = $this->validation_error;
				
				$name = 'editgrant';
		
				$this->template->page('servers.tpl.html');
				
				foreach($validfields AS $value){
					if(isset($error[$value])){
						$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
					}
				}
				
				$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateServersLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}


	private function templateServersLayout($staffMember, $input = false, $inputArray=array() ){
				
				//$id = $staffMember['connection_id'];

				/*$this->template->assign('title', $staffMember['industry_sap_account_fund']." - ".$staffMember['industry_source_discription']);*/
				
				@$this->template->assign('connection_id', ($input)? $this->template->input('text', 'connection_id', $staffMember['connection_id']):$staffMember['connection_id']);
				@$this->template->assign('connection_details', ($input)? $this->template->input('text', 'connection_details', $staffMember['connection_details']):$staffMember['connection_details']);
				@$this->template->assign('server_host', ($input)? $this->template->input('text', 'server_host', $staffMember['server_host']):$staffMember['server_host']);
				@$this->template->assign('server_port', ($input)? $this->template->input('text', 'server_port', $staffMember['server_port']):$staffMember['server_port']);
				@$this->template->assign('server_database', ($input)? $this->template->input('text', 'server_database', $staffMember['server_database']):$staffMember['server_database']);
				@$this->template->assign('server_type', ($input)? $this->template->input('text', 'server_type', $staffMember['server_type']):$staffMember['server_type']);
				@$this->template->assign('create_date', ($input)? $this->template->input('text', 'create_date', $staffMember['create_date']):$staffMember['create_date']);
				@$this->template->assign('modify_date', ($input)? $this->template->input('text', 'modify_date', $staffMember['modify_date']):$staffMember['modify_date']);
				@$this->template->assign('delete_date', ($input)? $this->template->input('text', 'delete_date', $staffMember['delete_date']):$staffMember['delete_date']);
				
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
	
	
	/*************************FUNCTION*******************************/
	
	public function getServerByClientId($id){
		$sql = "SELECT server_connection.connection_id,
					connection_details,
					server_host,
					server_port,
					server_database,
					server_type,
					DATE_FORMAT(create_date, '%d/%m/%Y') AS create_date,
					DATE_FORMAT(modify_date, '%d/%m/%Y') AS modify_date,
					DATE_FORMAT(delete_date, '%d/%m/%Y') AS delete_date
				FROM clients_server_connection 
				LEFT JOIN server_connection ON clients_server_connection.connection_id=server_connection.connection_id				
				WHERE (server_connection.delete_date ='00-00-0000 00:00:00' OR server_connection.delete_date IS NULL) AND client_id=".$id;
		try{
			 $result = $this->db->select($sql);
		}catch(CustomException $e){
			 echo $e->queryError($sql);
		}
		return $result; 
	}
	
	
	/************************END FUNCTIONS***************************/
	
}