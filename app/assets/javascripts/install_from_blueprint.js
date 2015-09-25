$(document).ready(function() {
	if ($("#show_advanced_fields_button").length > 0) {
	    $(".advanced_fields").hide();
	    // $(".attach_service_fields .advanced_fields").show();
	    $("#show_advanced_fields_button").click(function() {
	      $(this).hide();
	      // $(".new_software_form_default_details").slideUp();
	      $(".advanced_fields").slideDown();
		  $("#install_from_blueprint_advanced_selected").val("1");
	    });
	};

	if ( $("#install_from_blueprint_advanced_selected").val() == "1" ) {
		$("#show_advanced_fields_button").click();
	};
});
