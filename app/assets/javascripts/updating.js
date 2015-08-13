$(document).ready(function() {

  if ($("#updating_system_page_reloader").length) {

	var done = 0;


	function get_width_for(selector) {
		return ($(selector).width() / $(selector).parent().width() * 100);
   	};


	function render_updating_system_page_reloader(width) {
		var total_width = $("#updating_system_page_reloader_done").parent().width();
		var done_width = (total_width * width/1000).toString() + 'px';
		$("#updating_system_page_reloader_done").width(done_width);
		$("#updating_system_page_reloader").show();
	};

	function wait_for_system_update() {


	    setTimeout(function () {

			if (done == 999) {
				render_updating_system_page_reloader(1000);
				window.location.replace("/control_panel");
			} else {
				done = done + 1;
				render_updating_system_page_reloader(done);
		        wait_for_system_update();
			};




	    }, 100);
	};

	if (done == 0) { wait_for_system_update(); };

	  	
  	
  }

});