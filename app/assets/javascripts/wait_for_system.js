$(document).ready(function() {

  if ($("#wait_for_system").length) {
	var done = 0;
	var poll_url = $("#wait_for_system").data('pollurl');
	var wait = $("#wait_for_system").data('wait');
	var poll_period = $("#wait_for_system").data('pollperiod');
	var poll_message = $("#wait_for_system").data('pollmessage');
	var redirect_url = $("#wait_for_system").data('redirecturl');

	function set_progress_bar_width(width) {
		width = width.toString() + '%';
		$(".wait_for_system_progress_bar .progress-bar").width(width);
	};

	function initial_wait_for_system() {
    function finished() {
      done = 1;
      wait_for_system_polling();
      wait_for_system_to_come_up();
    };
    if (wait == 0) {
      finished();
    } else {
	    setTimeout(function () {
			if (done == 99) {
        finished();
			} else {
				done = done + 1;
				set_progress_bar_width(done);
		        initial_wait_for_system();
			};
	    }, wait * 10);
    };
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
			success: function(data) {
				if (data != 'busy') {
					show_waiting_for_response_modal();
					window.location.href = redirect_url;
				} else {
		        	setTimeout(function() {wait_for_system_polling();}, poll_period * 1000);
				};
			},
			error: function(response, status, error){
        if (response.status == 500) {
  				document.write(response.responseText);
  			} else if (response.status == 401) {
  				alert(response.responseText);
  				window.location.reload();
        } else if (response.status == 0) {
				    setTimeout(function() {wait_for_system_polling();}, poll_period * 1000);
  			} else {
					document.write(response.responseText);
				};
			},

		});
	};

	if (done == 0) {
		initial_wait_for_system();
	 };

  };

});
