$(document).ready(function(){

	if ($("#system_restarting").length > 0) {
		restarting_poll_progress();
		do_restarting_poll();
	};

	function do_restarting_poll() {
	   	setTimeout(function() {
	       	restarting_poll();
	    }, 10000);
	};

	function restarting_poll() {
	   	setTimeout(function() {
	       	$.ajax({ url: "/system/restarting", success: function(data) {
	        	window.location.href = "/control_panel";
	       }, complete: restarting_poll });
	    }, 2000);
	};

	function restarting_poll_progress() {
	   	setTimeout(function() {
	       	$.ajax({ url: "/system/restarting", success: function(data) {
				$("#restarting_message").append(".");
	       }, complete: restarting_poll_progress });
	    }, 500);
	};

});