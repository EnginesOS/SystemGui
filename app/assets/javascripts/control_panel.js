$(document).ready(function() {

	function bind_control_panel_object_events(obj) {
		obj.find(".modal_menu_item").click(function() {
			load_modal_content($(this));
		});
		obj.find(".object_action").click(function() {
			perform_control_panel_object_action($(this));
		});
		check_for_reload_required(obj);
		bind_trigger_response_modal_events();
	};
	
	function check_for_reload_required(obj){
		if ( $(obj).find('.reload_control_panel_object').length ) {
			setTimeout(function(){
			    load_control_panel_object(obj);
			}, 1000);
		};
	};
	
	function load_modal_content(obj) {

		modal_id = obj.attr("data-target");
		modal_body_id = modal_id + "_body";

		$(modal_body_id).children('.modal_body_content').hide();
		$(modal_body_id).children('.loading_spinner').show();

		url = obj.attr("data-url");

		$.ajax({
			url : url,
			cache : false,
			success : function(html) {
				$(modal_body_id).children('.modal_body_content').html(html);
				$(modal_body_id).children('.loading_spinner').slideUp();
				$(modal_body_id).children('.modal_body_content').slideDown();
				bind_new_window_popup_events();
			},
			error: function(response, status, error){
				if (response.status == 500) {
					document.write(response.responseText);
				} else if (response.status == 401) {
					alert(response.responseText);
					window.location.reload();
				} else {
 				    var msg = '<i class="fa fa-thumbs-down"></i>';
				    obj.find(modal_body_id).html(msg);
				};
			}
		});

	};

	function load_control_panel_objects() {
		$(".control_panel .load_control_panel_object").each(function() {
			var applicationName = $(this).attr('id');
			load_control_panel_object($(this));
		});
	}

	load_control_panel_objects();

	function load_control_panel_object(obj) {
		var url = obj.attr("data-url");
		// obj.next().html(obj.html());
		$.ajax({
			url : url,
			cache : false,
			timeout: 180000,
			success : function(html) {
					obj.html(html);
					do_flash_messages();
					bind_control_panel_object_events(obj);		
			},
			error: function(response, status, error){
				if (response.status == 500) {
					document.write(response.responseText);
				} else if (response.status == 401) {
					alert(response.responseText);
					window.location.reload();
				} else {
 				    var msg = '<i class="fa fa-thumbs-down"></i>';
				    obj.find(".control_panel_object_placeholder").html(msg);
				};
			}
		});

	};

	function perform_control_panel_object_action(obj) {

		var parent_obj = obj.closest(".load_control_panel_object");

		var url = obj.attr("data-url");
		var action = obj.attr("data-action");
		var placeholder = parent_obj.find(".text_holder").find(".object_status");

		placeholder.html('<small><i class="fa fa-spinner fa-pulse"></i> Preparing to ' + action + '</small>');
		
		$.ajax({
			url : url,
			cache : false,
			timeout: 60000,
			success : function(html) {
				parent_obj.html(html);
				bind_control_panel_object_events(parent_obj);
				do_flash_messages();
			},
			error: function(response, status, error){
				if (response.status == 500) {
					document.write(response.responseText);
				} else if (response.status == 401) {
					alert(response.responseText);
					window.location.reload();
				} else {
					var msg = '<i class="fa fa-thumbs-down"></i><small> ' + status.toString() + ' error</small>';
					parent_obj.find(".object_status").html(msg);
				};
			}
		});
		

	}

	function control_panel_call_to_action() {
		setTimeout(function(){
		    $('#click_on_blue_menu_button_message').fadeTo(800,1);
		}, 1500);
	};

	control_panel_call_to_action();


});

