$(document).ready(function() {

	$(".attached_service_text").each(function() {
		setup_wizard($(this));
	});
	
	function setup_wizard(text_holder) {
		var attach_service_panel = text_holder.parents(".panel-body");
		var radios = attach_service_panel.find(".attached_service_select_create_type_radios");
		var create_type = attach_service_panel.find(".create_type_input").val();
		// var display_text = "";
		if (create_type == "active") {
			var active_attached_service = attach_service_panel.find(".attached_service_active_configure_select").val();
			var display_text = "Use existing active attached service<br>" + active_attached_service;
			radios.find('input[value="active"]').prop("checked", true);
			attach_service_panel.find(".attached_service_orphan_configure_select").val("");
		} else if (create_type == "orphaned") {
			var orphaned_attached_service = attach_service_panel.find(".attached_service_orphan_configure_select").val();
			var display_text = "Use existing orphaned attached service<br>" + orphaned_attached_service;
			radios.find('input[value="orphaned"]').prop("checked", true);
			attach_service_panel.find(".attached_service_active_configure_select").val("");
		} else {
			var display_text = "Create new attached service";
			radios.find('input[value="new"]').prop("checked", true);
			attach_service_panel.find(".attached_service_active_configure_select").val("");
			attach_service_panel.find(".attached_service_orphan_configure_select").val("");
		};
		text_holder.html(display_text);
	};
	
	$(".installer_configure_attached_service_button").click(function() {
		var attach_service_panel = $(this).parents(".panel-body");
		var create_type = attach_service_panel.find(".create_type_input").val();
		if (create_type == "active") {
			attach_service_panel.find(".attached_service_active_configure").slideDown();
		} else if (create_type == "orphaned") {
			attach_service_panel.find(".attached_service_orphan_configure").slideDown();
		} else {
		};
		attach_service_panel.find(".attached_service_select").slideUp();
		attach_service_panel.find(".attached_service_select_create_type").slideDown();
		attach_service_panel.find(".attached_service_cancel").slideDown();
	});

	$(".attached_service_select_create_type_radios").change(function() {
		var attach_service_panel = $(this).parents(".panel-body");
		if ($(this).find("input:checked").val() == "active") {
			attach_service_panel.find(".attached_service_orphan_configure").hide();
			attach_service_panel.find(".attached_service_active_configure").show();
		} else if ($(this).find("input:checked").val() == "orphaned") {
			attach_service_panel.find(".attached_service_active_configure").hide();
			attach_service_panel.find(".attached_service_orphan_configure").show();
		} else {
			var display_text = "Create new attached service";
			attach_service_panel.find(".create_type_input").val("");
			attach_service_panel.find(".orphan_parent_name_input").val("");
			attach_service_panel.find(".service_handle_input").val("");
			attach_service_panel.find(".attached_service_select").find(".attached_service_text").html(display_text);
			reset_wizard(this);
		};
	});

	$(".attached_service_active_configure_select").change(function() {
		var attach_service_panel = $(this).parents(".panel-body");
		var service_label = $(this).val();
		var label_array = service_label.split(" - ");
		var parent_name = label_array[0];
		var service_handle = label_array[label_array.length - 1];
		var display_text = "Use existing active attached service<br>" + service_label;
		attach_service_panel.find(".create_type_input").val("active");
		attach_service_panel.find(".orphan_parent_name_input").val(parent_name);
		attach_service_panel.find(".service_handle_input").val(service_handle);
		attach_service_panel.find(".attached_service_select .attached_service_text").html(display_text);
		reset_wizard(this);
	});

	$(".attached_service_orphan_configure_select").change(function() {
		var attach_service_panel = $(this).parents(".panel-body");
		var service_label = $(this).val();
		var label_array = service_label.split(" - ");
		var parent_name = label_array[0];
		var service_handle = label_array[label_array.length - 1];
		var display_text = "Use existing orphaned attached service<br>" + service_label;
		attach_service_panel.find(".create_type_input").val("orphaned");
		attach_service_panel.find(".orphan_parent_name_input").val(parent_name);
		attach_service_panel.find(".service_handle_input").val(service_handle);
		attach_service_panel.find(".attached_service_select .attached_service_text").html(display_text);
		reset_wizard(this);
	});

	$(".attached_service_cancel_button").click(function() {
		reset_wizard(this);
	});
	
	function reset_wizard(link) {
		var attach_service_panel = $(link).parents(".panel-body");
		attach_service_panel.find(".attached_service_select").slideDown();
		attach_service_panel.find(".attached_service_select_create_type").slideUp();
		attach_service_panel.find(".attached_service_cancel").slideUp();
		attach_service_panel.find(".attached_service_active_configure").slideUp();
		attach_service_panel.find(".attached_service_orphan_configure").slideUp();
	};

});
