$(document).ready(function() {

	$(".application_service_select_create_type_radios").each(function() {
		process_application_service_select(this);
	});

	$(".application_service_select_create_type_radios").change(function() {
		process_application_service_select(this);
	});
	
	function process_application_service_select(form) {
		var application_service_panel = $(form).parents(".panel-body");
		var type = $(form).find("input:checked").val();
		application_service_panel.find(".create_type_input").val(type);
		if (type == "active") {
			application_service_panel.find(".application_service_active_configure").show();
			application_service_panel.find(".application_service_orphan_configure").hide();
			application_service_panel.find(".new_application_service_configure").hide();
			application_service_panel.find(".skip_validation_input").val("1");
		} else if (type == "orphan") {
			application_service_panel.find(".application_service_orphan_configure").show();
			application_service_panel.find(".application_service_active_configure").hide();
			application_service_panel.find(".new_application_service_configure").hide();
			application_service_panel.find(".skip_validation_input").val("1");
		} else if (type == "new") { 
			var display_text = "Create new attached service";
			application_service_panel.find(".new_application_service_configure").show();
			application_service_panel.find(".application_service_active_configure").hide();
			application_service_panel.find(".application_service_orphan_configure").hide();
			application_service_panel.find(".skip_validation_input").val("0");
		};
	};

	// $(".application_service_active_configure_select").change(function() {
		// var application_service_panel = $(this).parents(".panel-body");
		// var service_label = $(this).val();
		// var label_array = service_label.split(" - ");
		// var parent_name = label_array[0];
		// var service_handle = label_array[label_array.length - 1];
		// var display_text = "Use existing active attached service<br>" + service_label;
		// application_service_panel.find(".create_type_input").val("active");
		// application_service_panel.find(".orphan_parent_name_input").val(parent_name);
		// application_service_panel.find(".service_handle_input").val(service_handle);
	// });
// 
	// $(".application_service_orphan_configure_select").change(function() {
		// var application_service_panel = $(this).parents(".panel-body");
		// var service_label = $(this).val();
		// var label_array = service_label.split(" - ");
		// var parent_name = label_array[0];
		// var service_handle = label_array[label_array.length - 1];
		// var display_text = "Use existing orphaned attached service<br>" + service_label;
		// application_service_panel.find(".create_type_input").val("orphaned");
		// application_service_panel.find(".orphan_parent_name_input").val(parent_name);
		// application_service_panel.find(".service_handle_input").val(service_handle);
	// });

});
