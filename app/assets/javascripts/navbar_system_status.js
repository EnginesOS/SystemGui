$(document).ready(function() {

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
					do_flash_messages();
					bind_control_panel_object_events(obj);		
			},
			error: function(response, status, error){
				if (response.status == 500) {
					document.write(response.responseText);
				} else if (response.status == 401) {
					alert(response.responseText);
					window.location.reload();
				} else {
				};
			}
		});

	};

	check_for_reload_system_status();
	

});
