var filterTime;

$(document).ready(function(){
	
	$(".table_lists tr:odd").addClass("even");

	$('.table_lists th>div').live('click', function(e) {

	  		var field = ($(this).attr('id'));
	  		var table = ($(this).parents('table').attr('id')); 
	  		var page = ($(this).parents('table').attr('page')); 
	  		var thisField = '#'+table+' #'+field;
	  		var urlString = '';
	  		
	  		var isdirection = $(thisField).attr('class');
	  		
	  		$('#'+table+' th>div').removeClass('asc');
	  		$('#'+table+' th>div').removeClass('desc');
	  		$('#'+table+' th>div>img').remove();
	  
	  		$(thisField).addClass(isdirection);
				$(thisField).append("<img src=\"images/"+isdirection+".png\" alt=\""+isdirection+"\">");
		   
	  		if($(thisField).attr('class') == 'asc'){
	  			$(thisField).removeClass('asc').addClass( 'desc' );
	  			$(thisField+">img").attr('src', 'images/desc.png').attr('alt', 'desc');
	  			var dir = 'desc';
	  		}else{
	  			$(thisField).removeClass('desc').addClass( 'asc' );
	  			$(thisField+">img").attr('src', 'images/asc.png').attr('alt', 'asc');
	  			var dir = 'asc';
	  		}
	  		
	  		var valuesList = getFilterFields(table);
	  		
	  		urlString = "action="+table+"&orderby="+field+"&dir="+dir+"&"+valuesList.join('&');
	  		
	  		rebuild_table(urlString, page, table);
	  		
	  });
	  
	  $('.table_lists th>div').live('dblclick', function(e) {
		  	var field = ($(this).attr('id'));
	  		var table = ($(this).parents('table').attr('id')); 
	  		var page = ($(this).parents('table').attr('page')); 
	  		var thisField = '#'+($(this).attr('id'));
	  		var urlString = '';
	  		
	  		$('.table_lists th>div').removeClass('desc', 'asc');
	  		$(thisField+">img").remove();
	  		
	  		var valuesList = getFilterFields(table);
	  		
	  		urlString = "action="+table+"&"+valuesList.join('&');
	  		
	  		rebuild_table(urlString, page, table);
	  });
	  
	  $('.table_lists input').live('keypress', function(e) {
		  var table = ($(this).parents('table')); 

		  clearTimeout(filterTime);
		  filterTime = setInterval(function(){
												getFilterDetails(table);
												clearTimeout(filterTime);
											}, 500);
	  });
	  
	  $('.table_lists td>select').change(function(){
		  var table = ($(this).parents('table')); 
		  var flt_field  = $(this).attr('name');
		  
		  if (flt_field.substr(0, 4) == 'dir_'){
			  var new_flt = flt_field.replace(/^dir_/, 'flt_');

			  if ($('#'+ table.attr('id') + ' input[name='+new_flt+']').val() == undefined){
				  return false;
			  }
		  }else{
			  if ($('#'+ table.attr('id') + ' select[name='+flt_field+']').val() == undefined){
				  return false;
			  }
		  }
		  
		  clearTimeout(filterTime);
		  filterTime = setInterval(function(){
												getFilterDetails(table);
												clearTimeout(filterTime);
					}, 500);
	  });
	
});

function getFilterDetails(table){
	var table_id = table.attr('id');
	var page = table.attr('page');
	
	var valuesList = getFilterFields(table_id);

	urlString  = "action="+table_id+"&"+valuesList.join('&');

	clearTimeout(filterTime);

	rebuild_table(urlString, page ,table_id);
}


function getFilterFields(table){
	
	var allInputs = $('#'+table+' td>input, #'+table+' td>select');
	var y = new Array();
	var direction = '';
	
	$.each(allInputs, function(key, values){
		if(values.value){
			y.push(values.name+"="+escape(values.value));
		}
	});

	return y;
}
                           


function rebuild_table(field, page, table){
	$("#"+table+' .row').remove();
  	$("#"+table+' .filter').after('<tr><td colspan="10" class="row"><img src="images/ajax-loader.gif" />Loading...</td></tr>');
  	
  	$.ajax({
		   type: "GET",
		   url: "ajax/"+page+".ajax.php",
		   data: field,
		   dataType: "html",
		   success: function(msg){
  			  $("#"+table+' .row').remove();
  			  $("#"+table+' .filter').after(msg);
  			  $(".table_lists tr:even").removeClass("even");
  			  $(".table_lists tr:even").addClass("even");
		   }
		 });
}