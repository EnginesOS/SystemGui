$(document).ready(function() {

	$(".attached_service_text").each(function() {
		set_display_text($(this));
	});
	
	function set_display_text(text_holder) {
		var create_type = text_holder.parents(".panel-body").find(".create_type_input").val();
		// var display_text = "";
		if (create_type == "active") {
			var active_attached_service = text_holder.parents(".panel-body").find(".service_handle_input").val();
			alert(active_attached_service);
			var display_text = "Use existing active attached service<br>" + active_attached_service;
		} else if (create_type == "orphaned") {
			var orphaned_attached_service = text_holder.parents(".panel-body").find(".orphan_parent_name_input").val();
			var display_text = "Use existing orphaned attached service<br>" + orphaned_attached_service;
		} else {
			var display_text = "Create new attached service";
		};
		text_holder.html(display_text);
	};
	
	$(".installer_configure_attached_service_button").click(function() {
		var attach_service_panel = $(this).parents(".panel-body");
		var radios = attach_service_panel.find(".attached_service_select_create_type_radios");
		var create_type = $(this).parents(".panel-body").find(".create_type_input").val();
		if (create_type == "active") {
			radios.find('input[value="active"]').prop("checked", true);
			var service_handle = $(this).parents(".panel-body").find(".service_handle_input").val();
			attach_service_panel.find(".attached_service_active_configure_select").val(service_handle);
			attach_service_panel.find(".attached_service_orphan_configure_select").val("");
			$(this).parents(".panel-body").find(".attached_service_active_configure").slideDown();
		} else if (create_type == "orphaned") {
			radios.find('input[value="orphaned"]').prop("checked", true);
			attach_service_panel.find(".attached_service_active_configure_select").val("");
			var parent_engine_name = $(this).parents(".panel-body").find(".orphan_parent_name_input").val();
			attach_service_panel.find(".attached_service_orphan_configure_select").val(parent_engine_name);
			$(this).parents(".panel-body").find(".attached_service_orphan_configure").slideDown();
		} else {
			radios.find('input[value="new"]').prop("checked", true);
			attach_service_panel.find(".attached_service_active_configure_select").val("");
			attach_service_panel.find(".attached_service_orphan_configure_select").val("");
		};
		$(this).parents(".panel-body").find(".attached_service_select").slideUp();
		$(this).parents(".panel-body").find(".attached_service_select_create_type").slideDown();
		$(this).parents(".panel-body").find(".attached_service_cancel").slideDown();
	});

	$(".attached_service_select_create_type_radios").change(function() {
		if ($(this).find("input:checked").val() == "active") {
			$(this).parents(".panel-body").find(".attached_service_orphan_configure").hide();
			$(this).parents(".panel-body").find(".attached_service_active_configure").show();
		} else if ($(this).find("input:checked").val() == "orphaned") {
			$(this).parents(".panel-body").find(".attached_service_active_configure").hide();
			$(this).parents(".panel-body").find(".attached_service_orphan_configure").show();
		} else {
			var display_text = "Create new attached service";
			$(this).parents(".panel-body").find(".create_type_input").val("new");
			$(this).parents(".panel-body").find(".attached_service_select").find(".attached_service_text").html(display_text);
			reset_wizard(this);
		};
		// $(this).parents(".panel-body").find(".attached_service_select_create_type").slideUp();
	});

	$(".attached_service_active_configure_select").change(function() {
		var active_attached_service_value = $(this).val();
		var active_attached_service_text = $(this).text();
		var display_text = "Use existing active attached service<br>" + active_attached_service_value;
		$(this).parents(".panel-body").find(".create_type_input").val("active");
		$(this).parents(".panel-body").find(".service_handle_input").val(active_attached_service_text);
		$(this).parents(".panel-body").find(".orphan_parent_name_input").val("");
		$(this).parents(".panel-body").find(".attached_service_select").find(".attached_service_text").html(display_text);
		reset_wizard(this);
	});

	$(".attached_service_orphan_configure_select").change(function() {
		var orphaned_attached_service = $(this).val();
		var display_text = "Use existing orphaned attached service<br>" + orphaned_attached_service;
		$(this).parents(".panel-body").find(".create_type_input").val("orphaned");
		$(this).parents(".panel-body").find(".orphan_parent_name_input").val(orphaned_attached_service);
		$(this).parents(".panel-body").find(".service_handle_input").val("");
		$(this).parents(".panel-body").find(".attached_service_select").find(".attached_service_text").html(display_text);
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
