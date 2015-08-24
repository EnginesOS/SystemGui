$(document).ready(function() {

  if ($("#wait_for_system").length) {
	var done = 0;
	var poll_url = $("#wait_for_system").data('pollurl');
	var wait = $("#wait_for_system").data('wait');
	var poll_period = $("#wait_for_system").data('pollperiod');
	var poll_message = $("#wait_for_system").data('pollmessage');
	var redirect_url = $("#wait_for_system").data('redirecturl');

	function set_progress_bar_width(width) {
		var total_width = $(".wait_for_system_progress_bar_done").parent().width();
		var done_width = (total_width * width/100).toString() + 'px';
		$(".wait_for_system_progress_bar_done").width(done_width);
	};

	function initial_wait_for_system() {
	    setTimeout(function () {
			if (done == 99) {
				done = 1;
				wait_for_system_polling();
				wait_for_system_to_come_up();
			} else {
				done = done + 1;
				set_progress_bar_width(done);
		        initial_wait_for_system();
			};
	    }, wait * 10);
	};

	function wait_for_system_to_come_up() {
		$(".wait_for_system_progress_bar_message").text(poll_message);
	    setTimeout(function () {
			if (done == 99) {
				done = 1;
			} else {
				done = done + 1;
			};
			set_progress_bar_width(done);
		    wait_for_system_to_come_up();
	    }, 600);
	};

	function wait_for_system_polling() {
       	$.ajax({ url: poll_url,
			success: function(data) { if (data != 'busy') { show_waiting_for_response_modal(); window.location.href = redirect_url; }; }, 
        	complete: setTimeout(function() {wait_for_system_polling();}, poll_period * 1000)
		});
	};

	if (done == 0) {
		initial_wait_for_system();
	 };
	
  };

});