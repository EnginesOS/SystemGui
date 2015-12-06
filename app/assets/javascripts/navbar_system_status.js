$(document).ready(function() {

	check_for_reload_system_status();

});

function check_for_reload_system_status() {
	if ( $("#system_status_area").length ) {
		if ($("#system_status_area").attr('data-reload')) {
			setTimeout(function(){
					reload_system_status();
					do_flash_messages();
					check_for_reload_system_status();
			}, 2000);
		};
	};
};

function reload_system_status() {
	$.ajax({
		url : '/navbar_system_status',
		cache : false,
		timeout: 10000,
		success : function(html) {
				$("#system_status_area").parent().html(html);
		},
		error: function(response, status, error){
			if (response.status == 500) {
				document.write(response.responseText);
			} else {
			};
		}
	});

};
