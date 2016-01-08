$(document).ready(function() {

 if ($(".control_panel").length) {
	 load_control_panel_objects();
 	 control_panel_call_to_action();
 };

});

function bind_control_panel_object_events(obj) {
	obj.find(".modal_menu_item").click(function() {
		load_modal_content($(this));
	});
	obj.find(".object_action").click(function() {
		perform_control_panel_object_action($(this));
	});
	check_for_object_reload_required(obj);
	bind_trigger_response_modal_events();
};

function check_for_object_reload_required(obj){
	if ( $(obj).find('.reload_control_panel_object').length ) {
		setTimeout(function(){
				load_control_panel_object(obj);
		}, 1000);
	};
};

function monitor_object_states(){
	setTimeout(function(){
			monitor_object_states_ajax_call();
	}, 5000);
};

function monitor_object_states_ajax_call(){
	if ( $('.control_panel.applications').length ) {
		url = '/control_panel_applications_states';
	} else {
		url = '/control_panel_services_states';
	};

	$.ajax({
		url : url,
		cache : false,
		timeout: 10000,
		success : function(response) {
			monitor_object_states_success(response)
		},
		error: function(response, status, error){
			if (response.status == 500) {
				document.write(response.responseText);
			} else if (response.status == 401) {
				alert(response.responseText);
				show_waiting_for_response_modal();
				window.location.reload();
			};
		},
		complete: function(){	monitor_object_states();}
	});
};

function monitor_object_states_success(container_states_json) {
	var container_states = JSON.parse(container_states_json);
	$.each(container_states, function(container_name, container_state) {
		var control_panel_object = $('#control_panel_object_' + container_name );
		if ( !control_panel_object.find('.reload_control_panel_object').length ) {
			var displayed_state = control_panel_object.find('.engine-gadget').data('state');
			if ((displayed_state != 'error') && (container_state != displayed_state)){
				load_control_panel_object(control_panel_object);
			};
		};
	});
};

// function check_all_objects_for_reload_required(container_states_json) {
//
// };
//
//
// function reload_object_unless_already_working() {
// 	if ( $(obj).find('.reload_control_panel_object').length ) {
// 		setTimeout(function(){
// 				load_control_panel_object(obj);
// 		}, 1000);
// 	};
// };

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
					var msg = '<small><i class="fa fa-thumbs-o-down"></i> Error. ' + response.status.toString() + '</small>';
					obj.find(modal_body_id).html(msg);
			};
		}
	});

};

function load_control_panel_objects() {
	$(".control_panel .control_panel_object").each(function() {
		// var applicationName = $(this).attr('id');
		load_control_panel_object($(this));
	});
	monitor_object_states();
}

function close_modals_for(obj) {
  obj.find(".modal .close").click();
};

function load_control_panel_object(obj) {
  close_modals_for(obj);
	var url = obj.attr("data-url");
	// obj.next().html(obj.html());
	$.ajax({
		url : url,
		cache : false,
		timeout: 10000,
		success : function(html) {
				obj.html(html);
				do_flash_messages();
				bind_control_panel_object_events(obj);
		},
		error: function(response, status, error){
			if (response.status == 500) {
        obj.remove();
				document.write(response.responseText);
			} else if (response.status == 0) {
				var msg = '<small><i class="fa fa-spinner fa-spin"></i> Reloading</small>';
				obj.find(".object_status").html(msg);
				setTimeout(function(){
					load_control_panel_object(obj);
				}, 5000);
			} else {
					var msg = '<small><i class="fa fa-thumbs-o-down"></i> ' + response.status.toString() + ' load error</small>';
					obj.find(".object_status").html(msg);
			};
		}
	});

};

function perform_control_panel_object_action(obj) {

	var parent_obj = obj.closest(".control_panel_object");

	var url = obj.attr("data-url");
	var action = obj.attr("data-action");
	var placeholder = parent_obj.find(".text_holder").find(".object_status");

	placeholder.html('<small><i class="fa fa-spinner fa-spin"></i> Preparing to ' + action + '</small>');

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
			} else if (response.status == 0) {
				var msg = '<small><i class="fa fa-spinner fa-spin"></i> Reloading</small>';
				parent_obj.find(".object_status").html(msg);
				setTimeout(function(){
					load_control_panel_object(parent_obj);
				}, 5000);
			} else {
				var msg = '<small><i class="fa fa-thumbs-o-down"></i> ' + response.status.toString() + ' action error</small>';
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
