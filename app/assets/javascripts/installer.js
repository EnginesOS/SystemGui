$(document).ready(function(){

    // $(".software_installation_form .advanced_fields").hide();

    $("#new_software_form_show_advanced_fields_button").click(function() {
      $(".new_software_form_default_details").toggle();
      $(".advanced_fields").toggle();
    });

    if ($("#installation_status").length > 0){
    	if ($("#installation_progress").html() == '') {
			$("#installation_progress").html('Starting installation.');
			$("#installation_report").html('Waiting for installation to complete.');
			var engine_name = $("#installation_status").data("enginename");
			var evtSource = new EventSource("/installs/progress/" + engine_name);
			var last_line_in_build_progress_log = '';
			var second_last_line_in_build_progress_log = '';
			
			var progress_listener = function(e) {
				new_line = e.data;
				second_last_line_in_build_progress_log = last_line_in_build_progress_log;
				last_line_in_build_progress_log = new_line;
				$("#installation_progress").html(new_line + '<br>' + $("#installation_progress").html());
			};
			
			var report_listener = function(e) {
				new_line = e.data;
				if ($("#installation_report").html() == "Waiting for installation to complete.") {
					$("#installation_report").html('');
					};
				$("#installation_report").html($("#installation_report").html() + new_line + '<br>');
					// evtSource.stop();
			};
			
			var complete_listener = function(e) {
				if (e.data == 'installation_complete') {
    		    	// evtSource.removeEventListener("installation_report", report_listener, false);
					// alert(second_last_line_in_build_progress_log);
					var build_result = second_last_line_in_build_progress_log;
					evtSource.close();
					$("#installation_done_button").slideDown();
					$("#installation_report_tab_button").click();
					$("#installation_result_notifier").slideDown();
					if ((/^ERROR/).test(build_result)) {
						$("#installation_result_notifier").addClass("alert-danger");
					} else {
						$("#installation_result_notifier").addClass("alert-success");
					};
					$("#installation_result_notifier_message").html(build_result);
				};
			};
			
			evtSource.addEventListener("installation_report", report_listener);
			evtSource.addEventListener("installation_progress", progress_listener);
	    	evtSource.addEventListener("message", complete_listener);
	
			evtSource.addEventListener("error", function(e) {
				evtSource.close();
			});
		};
   };

});

