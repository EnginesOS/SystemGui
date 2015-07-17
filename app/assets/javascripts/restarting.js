$(document).ready(function(){

	if ($("#system_restarting").length > 0) {
		restarting_poll();
	};

	function restarting_poll() {
		$("#restarting_timer_message").append(".");
	   	setTimeout(function() {
	       	$.ajax({ url: "/system/restarting", success: function(data) {
	        	window.location.href = "/control_panel";
	       }, complete: restarting_poll });
	    }, 5000);
	};

});