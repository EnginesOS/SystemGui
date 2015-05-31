$(document).ready(function() {

	function bind_control_panel_object_events(obj) {
		obj.find(".advanced_menu_item").click(function() {
			load_advanced_details_modal($(this));
		});
		obj.find(".object_action").click(function() {
			perform_control_panel_object_action($(this));
		});
		bind_trigger_response_modal_events();
	};

	function load_advanced_details_modal(obj) {

		modal_id = obj.attr("data-target");
		modal_body_id = modal_id + "_body";

		url = obj.attr("data-url");

		$.ajax({
			url : url,
			cache : false,
			success : function(html) {
				$(modal_body_id).html(html);
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
			success : function(html) {
				// obj.next().next().text( html );
				obj.html(html);
				bind_control_panel_object_events(obj);
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
		
// alert(url);
		$.ajax({
			url : url,
			cache : false,
			success : function(html) {
				parent_obj.html(html);
				bind_control_panel_object_events(parent_obj);
				// $('#waiting-for-response-modal').modal('hide');
			}
		});
		

	}

});

