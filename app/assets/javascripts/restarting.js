$(document).ready(function() {

  if ($("#restarting_system_page_reloader").length) {

	var done = 0;

	function get_width_for(selector) {
		return ($(selector).width() / $(selector).parent().width() * 100);
   	};

	function render_restarting_system_page_reloader(width) {
		var total_width = $("#restarting_system_page_reloader_done").parent().width();
		var done_width = (total_width * width/1000).toString() + 'px';
		$("#restarting_system_page_reloader_done").width(done_width);
		$("#restarting_system_page_reloader").show();
	};

	function render_restarting_system_page_text(heading, message) {
		$("#restarting_system_message").text(message);
		$("#restarting_system_page_heading").text(heading);
	};

	function wait_for_system_to_update() {
		render_restarting_system_page_text("Updating", "Waiting for system to update.");
	    setTimeout(function () {
			if (done == 999) {
				done = 1;
				wait_for_system_to_come_up();
				control_panel_up_polling();
			} else {
				done = done + 1;
				render_restarting_system_page_reloader(done);
		        wait_for_system_to_update();
			};
	    }, 100);
	};

	function wait_for_system_to_go_down() {
		render_restarting_system_page_text("Stopping", "Waiting for system to go down.");
	    setTimeout(function () {
			if (done == 999) {
				done = 1;
				wait_for_system_to_come_up();
				control_panel_up_polling();
			} else {
				done = done + 1;
				render_restarting_system_page_reloader(done);
		        wait_for_system_to_go_down();
			};
	    }, 10);
	};

	function control_panel_up_polling() {
	   	setTimeout(function() {
	       	$.ajax({ url: "/control_panel", success: function(data) {
	        	window.location.href = "/control_panel";
	        }, complete: control_panel_up_polling() });
	    }, 2000);
	};


	function wait_for_system_to_come_up() {
		render_restarting_system_page_text("Starting", "Waiting for system to come up.");
	    setTimeout(function () {
			if (done == 999) {
				done = 1;
			} else {
				done = done + 1;
			};
			render_restarting_system_page_reloader(done);
		    wait_for_system_to_come_up();
	    }, 50);
	};

	if (done == 0) {
		if ($("#restarting_system_page_reloader").data('waitforupdate') == true) {
			wait_for_system_to_update();
		} else {
			wait_for_system_to_go_down();
		};
	 };

	
	
	
// 
// 	  	
//   	
  // }
// 
// 
	// if ($("#system_restarting").length > 0) {
		// restarting_poll_progress();
		// do_restarting_poll();
	// };
// 
	// function do_restarting_poll() {
	   	// setTimeout(function() {
	       	// restarting_poll();
	    // }, 10000);
	// };
// 
	// function restarting_poll() {
	   	// setTimeout(function() {
	       	// $.ajax({ url: "/control_panel", success: function(data) {
	        	// window.location.href = "/control_panel";
	       // }, complete: restarting_poll });
	    // }, 2000);
	// };
// 
	// function restarting_poll_progress() {
	   	// setTimeout(function() {
			// $("#restarting_message").append(".");
	        // restarting_poll_progress();
	    // }, 500);
  };

});