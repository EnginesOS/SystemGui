$(document).ready(function () {
	if ($('#display_properties_set_icon_radios').length > 0) {

		function setup_display_properties_set_icon_radios() {
			 set_icon_radios_update_form();
			 $('#display_properties_set_icon_radios').change(function() {
				 set_icon_radios_update_form();
			 });
		
		};
		
		function set_icon_radios_update_form() {
				var radio_selected = $("input:radio[name='application_display_properties[set_icon]']:checked").val();
				// alert(radio_selected);
				if (radio_selected == "Upload icon") {
					$("#display_properties_existing_icon").hide();
					$("#display_properties_upload_icon").show();
					$("#display_properties_no_icon").hide();
					$("#display_properties_installer_icon").hide();
					$("#display_properties_blueprint_icon").hide();
				 } else if (radio_selected == "Keep existing icon") {
					$("#display_properties_existing_icon").show();
					$("#display_properties_upload_icon").hide();
					$("#display_properties_no_icon").hide();
					$("#display_properties_installer_icon").hide();
					$("#display_properties_blueprint_icon").hide();
				 } else if (radio_selected == "No icon") {
					$("#display_properties_existing_icon").hide();
					$("#display_properties_upload_icon").hide();
					$("#display_properties_no_icon").show();
					$("#display_properties_installer_icon").hide();
					$("#display_properties_blueprint_icon").hide();
				 } else if (radio_selected == "Installer icon") {
					$("#display_properties_existing_icon").hide();
					$("#display_properties_upload_icon").hide();
					$("#display_properties_no_icon").hide();
					$("#display_properties_installer_icon").show();
					$("#display_properties_blueprint_icon").hide();
				 } else if (radio_selected == "Blueprint icon") {
					$("#display_properties_existing_icon").hide();
					$("#display_properties_upload_icon").hide();
					$("#display_properties_no_icon").hide();
					$("#display_properties_installer_icon").hide();
					$("#display_properties_blueprint_icon").show();
				};
		};
		

		 setup_display_properties_set_icon_radios();
		};
});

