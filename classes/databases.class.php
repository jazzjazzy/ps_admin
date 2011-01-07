<?php
/*require_once DIR_ROOT.'/classes/db.php';
require_once DIR_ROOT.'/classes/error.class.php';
require_once DIR_ROOT.'/classes/table.class.php';
require_once DIR_ROOT.'/classes/template.class.php';
require_once DIR_ROOT.'/classes/staff.class.php';
require_once DIR_ROOT.'/classes/fund.class.php';
*/
class databases {
	
	private $db_connect;
	private $db;
	public $lastError;
	public $table;
	public $template;
	private $error;
	public $admin;
	private $fields =array('database_id', 'database_host', 'database_port', 'database_os', 'database_os_version', 'database_types', 'database_version', 'database_inservice', 'create_date', 'modify_date', 'delete_date');
	private $fields_required = NULL;
	private $fields_validation_type = array ('database_id'=>'INT', 'database_host'=>'TEXT', 'database_port'=>'TEXT', 'database_os'=>'TEXT', 'database_os_version'=>'TEXT', 'database_types'=>'TEXT', 'database_version'=>'TEXT', 'database_inservice'=>'TEXT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT');
	
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
		
		$sql = "SELECT database_id,
					database_host,
					database_port,
					database_os,
					database_os_version,
					database_types,
					database_version,
					database_inservice,
					create_date,
					modify_date,
					delete_date FROM database_server WHERE (delete_date ='00-00-0000 00:00:00' OR delete_date IS NULL)";
		
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
				
				foreach($source['database_server'] AS $key=>$val){
					$field[] = $key;
					$value[] = ":".$key;
				}

				$sql = "INSERT INTO database_server (".implode(', ',$field).") VALUES (".implode(', ',$value).");";
				
				foreach($source['database_server'] AS $key=>$val){
					$exec[":".$key] = $val;
				}
				
				try{
					$pid = $this->db->insert($sql, $exec); 
				}catch(CustomException $e){
					throw new CustomException($e->queryError($sql));
				}

				$pid = $this->db_connect->lastInsertId();
			}

			catch (CustomException $e) {
				$e->queryError($sql);
				$this->db_connect->rollBack();
				return false;
			}

			return $pid;
	}
	
	
	Private function read($id){
	
		$sql = "SELECT database_id,
					database_host,
					database_port,
					database_os,
					database_os_version,
					database_types,
					database_version,
					database_inservice,
					create_date,
					modify_date,
					delete_date FROM database_server WHERE database_id = ". $id ." AND (delete_date ='00-00-0000 00:00:00' OR delete_date IS NULL)" ;

		
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
				
				foreach($source['database_server'] AS $key=>$val){
					$field[] = $key." = :".$key;
				}

				$sql = "UPDATE database_server SET ".implode(', ',$field)." WHERE database_id =". $id;
				
				$stmt = $this->db_connect->prepare($sql);
				
				foreach($source['database_server'] AS $key=>$val){
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
				$source['database_server']['database_id'] = $id;

			}

			catch (Exception $e) {
				$this->error->set_error($stmt->errorInfo(), $sql);
				$this->error->get_error();
				$this->db_connect->rollBack();
			}
			
			header('Location:databases.php?action=show&id='.$id);
			
	}
	
	Private function remove($id){
			if(empty($id)){
				return false;
			}
			
			$sql = "UPDATE database_server SET delete_date=NOW() WHERE database_id =". $id;

			try{
				$result = $this->db->update($sql);
			}catch(CustomException $e){
				echo $e->queryError($sql);
			}
			return true;
	}
	
	
	/******************* END CRUD METHOD*************************/
	
	public function getDatabasesList($type='TABLE',$orderby=NULL, $direction='ASC', $filter=NULL){
		
		$result = $this->lists($orderby, $direction, $filter);
		
		switch(strtoupper($type)){
		
			case 'AJAX' : $this->table->setRowsOnly(); 
						  $this->table->removeColumn(array('database_id'));
						  $this->table->setIdentifier('database_id');
						  $this->table->setIdentifierPage('databases');
						  echo $this->table->genterateDisplayTable($result);
						  
				BREAK;
			case 'TABLE' :
			DEFAULT :
				$this->table->setHeader(array(
						'database_id'=>'Database Id',
'database_host'=>'Database Host',
'database_port'=>'Database Port',
'database_os'=>'Database Os',
'database_os_version'=>'Database Os Version',
'database_types'=>'Database Types',
'database_version'=>'Database Version',
'database_inservice'=>'Database Inservice',
'create_date'=>'Create Date',
'modify_date'=>'Modify Date',
'delete_date'=>'Delete Date'));
				
				$this->table->setFilter(array(	
						'database_id'=>'TEXT',
'database_host'=>'TEXT',
'database_port'=>'TEXT',
'database_os'=>'TEXT',
'database_os_version'=>'TEXT',
'database_types'=>'TEXT',
'database_version'=>'TEXT',
'database_inservice'=>'TEXT',
'create_date'=>'TEXT',
'modify_date'=>'TEXT',
'delete_date'=>'TEXT'));
				
				$this->table->removeColumn(array('database_id'));
				
				$this->table->setIdentifier('database_id');
				
				$this->template->content($this->table->genterateDisplayTable($result));
				
				$this->template->display();
		}
	}
	
	Public function showDatabasesDetails($id, $return=false){
		$staffMember = $this->read($id);
		
		$this->template->page('databases.tpl.html');
		
		$this->templateDatabasesLayout($staffMember);

		//if($this->checkAdminLevel(1)){
			$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"location.href='databases.php?action=edit&id=".$id."'\">Edit</div>");
		//}
		
		echo $this->template->fetch();	
	}
	
	Public function editDatabasesDetails($id){
		
		$staffMember = $this->read($id);
		
		$name = 'editdatabases';
		
		$this->template->page('databases.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="databases.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
		$this->templateDatabasesLayout($staffMember, true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='databases.php?action=show&id=".$id."'\">Cancel</div>");
		
		$this->template->display();
	}
	
	
	Public function updateDatabasesDetails($id){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'database_server';

				$save[$table]['database_host'] = $request['database_host'];$save[$table]['database_port'] = $request['database_port'];$save[$table]['database_os'] = $request['database_os'];$save[$table]['database_os_version'] = $request['database_os_version'];$save[$table]['database_types'] = $request['database_types'];$save[$table]['database_version'] = $request['database_version'];$save[$table]['database_inservice'] = $request['database_inservice'];
				$save[$table]['modify_date'] = date('Y-m-d h:i:s');
				
				$this->update($save, $id );
				
			}else{
				
				$staffMember = $this->valid_field;
				$error = $this->validation_error;
				
				$name = 'editgrant';
		
				$this->template->page('databases.tpl.html');
				
				foreach($validfields AS $value){
					if(isset($error[$value])){
						$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
					}
				}
				
				$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateDatabasesLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}
	
	
	Public function createDatabasesDetails(){
		
		$name = 'createAdmin';
		
		$this->template->page('databases.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="databases.php?action=save" method="POST" name="'.$name.'">');
		
		$this->templateDatabasesLayout('', true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Save</div><div class=\"button\" onclick=\"location.href='databases.php?action=list'\">Cancel</div>");
		

		$this->template->display();
	} 
	
	Public function saveDatabasesDetails(){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'database_server';

				$save[$table]['database_host'] = $request['database_host'];$save[$table]['database_port'] = $request['database_port'];$save[$table]['database_os'] = $request['database_os'];$save[$table]['database_os_version'] = $request['database_os_version'];$save[$table]['database_types'] = $request['database_types'];$save[$table]['database_version'] = $request['database_version'];$save[$table]['database_inservice'] = $request['database_inservice'];
				$save[$table]['create_date'] = date('Y-m-d h:i:s');
				
				$this->create($save);
				
			}else{
			
				$staffMember = $this->valid_field;

				$error = $this->validation_error;
	
				$name = 'createdatabases';
	
				$this->template->page('databases.tpl.html');
	
				foreach($error AS $key=>$value){
					$this->template->assign('err_'.$key, "<span class=\"error\">".@implode(',', $error[10])."</spam>");
				}

				$this->template->assign('FORM-HEADER', '<form action="databases.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateDatabasesLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='databases.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}

	Public function deleteClientsDetails($id){
		$this->remove($id);
		header('Location: databases.php');
	}
	
	private function templateDatabasesLayout($staffMember, $input = false, $inputArray=array() ){
				
				$id = $staffMember['database_id'];

				@$this->template->assign('database_id', ($input)? $this->template->input('text', 'database_id', $staffMember['database_id']):$staffMember['database_id']);
@$this->template->assign('database_host', ($input)? $this->template->input('text', 'database_host', $staffMember['database_host']):$staffMember['database_host']);
@$this->template->assign('database_port', ($input)? $this->template->input('text', 'database_port', $staffMember['database_port']):$staffMember['database_port']);
@$this->template->assign('database_os', ($input)? $this->template->input('text', 'database_os', $staffMember['database_os']):$staffMember['database_os']);
@$this->template->assign('database_os_version', ($input)? $this->template->input('text', 'database_os_version', $staffMember['database_os_version']):$staffMember['database_os_version']);
@$this->template->assign('database_types', ($input)? $this->template->input('text', 'database_types', $staffMember['database_types']):$staffMember['database_types']);
@$this->template->assign('database_version', ($input)? $this->template->input('text', 'database_version', $staffMember['database_version']):$staffMember['database_version']);
@$this->template->assign('database_inservice', ($input)? $this->template->input('text', 'database_inservice', $staffMember['database_inservice']):$staffMember['database_inservice']);
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
	
	public function getListOfDatabases($name = 'database_id', $sel = NULL){
		$lists = $this->lists();
		
		$html = "<select name=\"$name\">";
		foreach($lists AS $val){
			if($val['database_id'] == $sel){
				$seleced = 'selected';
			}else{
				$seleced = '';
			}
			$html .= "\t<option value=\"".$val['database_id'].'" '.$seleced.'>'.$val['database_host']."</option>\n";
		}
		$html .= "</select>";
		return $html;
	}
	
	public function addClientsConnectionString($id, $client_id){
		$read = $this->read($id);
		
		$sql = "INSERT INTO server_connection (server_host, server_port, server_database, server_type, create_date) 
		VALUES('".$read['database_host']."','".$read['database_port']."','client_".$client_id."','".$read['database_types']."',NOW());";
		
		try{
			$connectionId = $this->db->insert($sql); 
		}catch(CustomException $e){
			 echo $e->queryError($sql);
		}
		
		$sql = "INSERT INTO clients_server_connection (client_id, connection_id) 
		VALUES('".$client_id."','".$connectionId."');";
		
		try{
			$this->db->insert($sql); 
		}catch(CustomException $e){
			 echo $e->queryError($sql);
		}
		
		return true;
	} 
	
}