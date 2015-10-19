$(document).ready(function() {

	if ($('#access_key_download_from_submit_button').length) {

		bind_access_key_download_form_button_events();

		// $('#access_key_download_from_submit_button').click(function(event){
			// event.preventDefault();
			// alert('do stuff');
		// });

	};
	
});

function bind_access_key_download_form_button_events() {
  $("#access_key_download_from_submit_button").click(function(){
    show_submit_message();
  });
  $(".form-button-cancel").click(function(){
    show_cancel_message();
    show_waiting_for_response_modal();
  });
};
