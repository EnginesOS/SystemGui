$(document).ready(function() {

	if ($('#access_key_download_form_submit_button').length) {
		bind_access_key_download_form_button_events();
	};

});

function bind_access_key_download_form_button_events() {
  $("#access_key_download_form_submit_button").click(function(){
		alert("hi");
    show_submit_message();
		$("#access_key_download_form_fields").hide();
  });
};
