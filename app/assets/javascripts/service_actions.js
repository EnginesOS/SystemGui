$(document).ready(function() {

	if ($('#service_action_form_submit_button').length) {
		bind_service_action_download_form_button_events();
	};

});

function bind_service_action_download_form_button_events() {
  $("#service_action_form_submit_button").click(function(){
    show_submit_message();
		$("#service_action_form_fields").hide();
  });
};
