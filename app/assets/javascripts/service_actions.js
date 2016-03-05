$(document).ready(function() {

	if ($('#service_action_form_submit_button').length) {
		bind_access_key_download_form_button_events();
	};

	$('.service-action-formless-file-download-button').click(function(){
		setTimeout(function(){
			$('#waiting-for-response-modal').fadeOut(500, function(){
				$('#waiting-for-response-modal').modal('hide');
			});
		}, 2000);
	});

});

function bind_access_key_download_form_button_events() {
  $("#service_action_form_submit_button").click(function(){
    show_submit_message();
		$("#service_action_form_fields").hide();
  });
};
