<?php
/*require_once DIR_ROOT.'/classes/db.php';
require_once DIR_ROOT.'/classes/error.class.php';
require_once DIR_ROOT.'/classes/table.class.php';
require_once DIR_ROOT.'/classes/template.class.php';
require_once DIR_ROOT.'/classes/staff.class.php';
require_once DIR_ROOT.'/classes/fund.class.php';
*/
class accounts {
	
	private $db_connect;
	private $db;
	public $lastError;
	public $table;
	public $template;
	private $error;
	public $admin;
	private $fields =array('account_id', 'account_name', 'account_cost', 'account_advertising_numbers', 'create_date', 'modify_date', 'delete_date');
	private $fields_required = NULL;
	private $fields_validation_type = array ('account_id'=>'INT', 'account_name'=>'TEXT', 'account_cost'=>'DOUBLE', 'account_advertising_numbers'=>'INT', 'create_date'=>'TEXT', 'modify_date'=>'TEXT', 'delete_date'=>'TEXT');
	
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
		
		$sql = "SELECT account_id,
					account_name,
					account_cost,
					account_advertising_numbers,
					create_date,
					modify_date,
					delete_date 
				FROM accounts 
				WHERE (delete_date ='00-00-0000 00:00:00' OR delete_date IS NULL)";
		
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
				
				foreach($source['accounts'] AS $key=>$val){
					$field[] = $key;
					$value[] = ":".$key;
				}

				$sql = "INSERT INTO accounts (".implode(', ',$field).") VALUES (".implode(', ',$value).");";

				$result = $this->db_connect->prepare($sql);
				
				foreach($source['accounts'] AS $key=>$val){
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
	
		$sql = "SELECT account_id,
					account_name,
					account_cost,
					account_advertising_numbers,
					create_date,
					modify_date,
					delete_date 
				FROM accounts 
				WHERE account_id = ". $id ." 
					AND (delete_date ='00-00-0000 00:00:00' OR delete_date IS NULL)" ;

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
				
				foreach($source['accounts'] AS $key=>$val){
					$field[] = $key." = :".$key;
				}

				$sql = "UPDATE accounts SET ".implode(', ',$field)." WHERE account_id =". $id;
				
				$stmt = $this->db_connect->prepare($sql);
				
				foreach($source['accounts'] AS $key=>$val){
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
				$source['accounts']['account_id'] = $id;

			}

			catch (Exception $e) {
				$this->error->set_error($stmt->errorInfo(), $sql);
				$this->error->get_error();
				$this->db_connect->rollBack();
			}
			
			header('Location:accounts.php?action=show&id='.$id);
			
	}
	
	Private function remove($id){
			if(empty($id)){
				return false;
			}
			
			$sql = "UPDATE accounts SET delete_date=NOW() WHERE account_id =". $id;

			try{
				$result = $this->db->update($sql);
			}catch(CustomException $e){
				echo $e->queryError($sql);
			}
			return true;
	}
	
	
	/******************* END CRUD METHOD*************************/
	
	public function getAccountsList($type='TABLE',$orderby=NULL, $direction='ASC', $filter=NULL){
		
		$result = $this->lists($orderby, $direction, $filter);
		
		switch(strtoupper($type)){
		
			case 'AJAX' : $this->table->setRowsOnly(); 
						  $this->table->removeColumn(array('account_id'));
						  $this->table->setIdentifier('account_id');
						  $this->table->setIdentifierPage('accounts');
						  echo $this->table->genterateDisplayTable($result);
						  
				BREAK;
			case 'TABLE' :
			DEFAULT :
				$this->table->setHeader(array(
						'account_id'=>'Account Id',
						'account_name'=>'Account Name',
						'account_cost'=>'Account Cost',
						'account_advertising_numbers'=>'Account Advertising Numbers',
						'create_date'=>'Create Date',
						'modify_date'=>'Modify Date',
						'delete_date'=>'Delete Date'));
				
				$this->table->setFilter(array(	
						'account_id'=>'TEXT',
						'account_name'=>'TEXT',
						'account_cost'=>'TEXT',
						'account_advertising_numbers'=>'TEXT',
						'create_date'=>'TEXT',
						'modify_date'=>'TEXT',
						'delete_date'=>'TEXT'));
				
				$this->table->removeColumn(array('account_id'));
				
				$this->table->setIdentifier('account_id');
				
				$this->template->content($this->table->genterateDisplayTable($result));
				
				$this->template->display();
		}
	}
	
	Public function showAccountsDetails($id, $return=false){
		$staffMember = $this->read($id);
		
		$this->template->page('accounts.tpl.html');
		
		$this->templateAccountsLayout($staffMember);

		//if($this->checkAdminLevel(1)){
			$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"location.href='accounts.php?action=edit&id=".$id."'\">Edit</div>");
		//}
		
		echo $this->template->fetch();	
	}
	
	Public function editAccountsDetails($id){
		
		$staffMember = $this->read($id);
		
		$name = 'editaccounts';
		
		$this->template->page('accounts.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="accounts.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
		$this->templateAccountsLayout($staffMember, true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='accounts.php?action=show&id=".$id."'\">Cancel</div>");
		
		$this->template->display();
	}
	
	
	Public function updateAccountsDetails($id){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'accounts';

				$save[$table]['account_name'] = $request['account_name'];$save[$table]['account_cost'] = $request['account_cost'];$save[$table]['account_advertising_numbers'] = $request['account_advertising_numbers'];
				$save[$table]['modify_date'] = date('Y-m-d h:i:s');
				
				$this->update($save, $id );
				
			}else{
				
				$staffMember = $this->valid_field;
				$error = $this->validation_error;
				
				$name = 'editgrant';
		
				$this->template->page('accounts.tpl.html');
				
				foreach($validfields AS $value){
					if(isset($error[$value])){
						$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
					}
				}
				
				$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateAccountsLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}
	
	
	Public function createAccountsDetails(){
		
		$name = 'createAdmin';
		
		$this->template->page('accounts.tpl.html');
		$this->template->assign('FORM-HEADER', '<form action="accounts.php?action=save" method="POST" name="'.$name.'">');
		
		$this->templateAccountsLayout('', true);
		
		$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Save</div><div class=\"button\" onclick=\"location.href='admin.php?action=list'\">Cancel</div>");
		

		$this->template->display();
	} 
	
	Public function saveAccountsDetails(){

		if ($this->Validate($_REQUEST)){
				
				$request = $_REQUEST;
				$table = 'accounts';

				$save[$table]['account_name'] = $request['account_name'];$save[$table]['account_cost'] = $request['account_cost'];$save[$table]['account_advertising_numbers'] = $request['account_advertising_numbers'];
				$save[$table]['create_date'] = date('Y-m-d h:i:s');
				
				$this->create($save);
				
			}else{
				
				$staffMember = $this->valid_field;
				$error = $this->validation_error;
				
				$name = 'editgrant';
		
				$this->template->page('accounts.tpl.html');
				
				foreach($validfields AS $value){
					if(isset($error[$value])){
						$this->template->assign('err_'.$value, "<span class=\"error\">".implode(',', $error[$value])."</spam>");
					}
				}
				
				$this->template->assign('FORM-HEADER', '<form action="fund.php?action=update&id='.$id.'" method="POST" name="'.$name.'">');
		
				$this->templateAccountsLayout($staffMember, true);
				
				if($this->admin->checkAdminLevel(1)){
					$this->template->assign('FUNCTION', "<div class=\"button\" onclick=\"document.$name.submit(); return false\">Update</div><div class=\"button\" onclick=\"location.href='fund.php?action=show&id=".$id."'\">Cancel</div>");
				}
				$this->template->assign('FORM-FOOTER', '</form>');
				
				$this->template->display();
		}
	}

	Public function deleteClientsDetails($id){
		$this->remove($id);
		header('Location: accounts.php');
	}
	
	private function templateAccountsLayout($staffMember, $input = false, $inputArray=array() ){
				
				$id = $staffMember['account_id'];

				/*$this->template->assign('title', $staffMember['industry_sap_account_fund']." - ".$staffMember['industry_source_discription']);*/
				
				@$this->template->assign('account_id', ($input)? $this->template->input('text', 'account_id', $staffMember['account_id']):$staffMember['account_id']);
				@$this->template->assign('account_name', ($input)? $this->template->input('text', 'account_name', $staffMember['account_name']):$staffMember['account_name']);
				@$this->template->assign('account_cost', ($input)? $this->template->input('text', 'account_cost', $staffMember['account_cost']):$staffMember['account_cost']);
				@$this->template->assign('account_advertising_numbers', ($input)? $this->template->input('text', 'account_advertising_numbers', $staffMember['account_advertising_numbers']):$staffMember['account_advertising_numbers']);
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
	
	public function getSelectListOfAccounts($name='accounts', $sel = NULL){
		$lists = $this->lists();
		
		$html = "<select name=\"$name\">";
		foreach($lists AS $val){
			if($sel == $val['account_id']){
				$selected = 'selected'; 
			}else{
				$selected = '';
			}
			$html .= "\t<option value=\"".$val['account_id'].'" '.$selected.'>'.$val['account_name']."</option>\n";
		}
		$html .= "</select>";
		return $html;
	}
	
	public function getAccountTypeByClientId($id){
		$sql = "SELECT account_name,
					account_cost,
					account_advertising_numbers
		 		FROM clients LEFT JOIN accounts ON clients.account_id = accounts.account_id WHERE clients.client_id = ".$id;
		
		try{
			 $result = $this->db->select($sql);
		}catch(CustomException $e){
			 echo $e->queryError($sql);
		}
		return $result[0];
	}
}