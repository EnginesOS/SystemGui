$(document).ready(function() {

	function bind_control_panel_object_events(obj) {
		obj.find(".modal_menu_item").click(function() {
			load_modal_content($(this));
		});
		obj.find(".object_action").click(function() {
			perform_control_panel_object_action($(this));
		});
		bind_trigger_response_modal_events();
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
			}
		});

	};

	function load_control_panel_objects() {
		$(".control_panel .control_panel_object").each(function() {
			var applicationName = $(this).attr('id');
			load_control_panel_object($(this));
		});
	}

	load_control_panel_objects();

	function load_control_panel_object(obj) {
		var url = obj.attr("data-url");

		obj.next().html(obj.html());

		$.ajax({
			url : url,
			cache : false,
			timeout: 20000,
			success : function(html) {
				obj.html(html);
				do_flash_messages();
				bind_control_panel_object_events(obj);			
			},
			error: function(response, status, error){
				if (response.status == 500) {
					document.write(response.responseText);
				} else {
 				    var msg = ['<i class="fa fa-warning"></i> Load error', error].join(' ') + '.<br>Try reloading the page.';
				    obj.find(".control_panel_object_placeholder").html(msg);
				};
			}
		});

	};

	function perform_control_panel_object_action(obj) {

		var parent_obj = obj.closest(".control_panel_object");

		parent_obj.html(parent_obj.next(".placeholder_html").html());

		var url = obj.attr("data-url");
		var action = obj.attr("data-action");
		
		var placeholder = parent_obj.find(".control_panel_object_placeholder");
		placeholder.prepend(action);
		
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
				} else {
					var msg = ['<i class="fa fa-warning"></i> Load error', error].join(' ') + '.<br>Try reloading the page.';
					parent_obj.find(".control_panel_object_placeholder").html(msg);
				};
			}
		});
		

	}

});

