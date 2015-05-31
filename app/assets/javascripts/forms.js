$(document).ready(function() {
    $('.selectize-single').selectize();

    $('.selectize-multi').selectize(
// selectize needs to be configured for multi-select.
    );

	if ($("#show_advanced_fields_button").length > 0) {
	    $(".advanced_fields").hide();
	    // $(".attach_service_fields .advanced_fields").show();
	    $("#show_advanced_fields_button").click(function() {
	      $(this).hide();
	      // $(".new_software_form_default_details").slideUp();
	      $(".advanced_fields").slideDown();
		  $("#application_installation_advanced_selected").val("1");
	    });
	};

	if ( $("#application_installation_advanced_selected").val() == "1" ) {
		$("#show_advanced_fields_button").click();
	};



});
