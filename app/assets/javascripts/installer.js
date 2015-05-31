$(document).ready(function(){
	
	if ($(".gallery_software_holder").length > 0) {
		$.each($(".gallery_software_holder"), function(index, gallery) {
				$.get("gallery_software", {gallery_id: $(gallery).data('galleryid'), search: $(gallery).data('search')}, function(data){
					$(gallery).html(data);
					bind_button_events();
				});
			});
	};
	
	
    if ($("#installation_status").length > 0){
    	if ($("#installation_progress").html() == '') {
			$("#installation_progress").html('Starting installation.');
			var asciiart = "  ______                   _                      \n |  ____|                 (_)                     \n | |__     _ __     __ _   _   _ __     ___   ___ \n |  __|   | '_ \\   / _` | | | | '_ \\   / _ \\ / __|\n | |____  | | | | | (_| | | | | | | | |  __/ \\__ \\\n |______| |_| |_|  \\__, | |_| |_| |_|  \\___| |___/\n                    __/ |                         \n                   |___/\n\n";
			$("#installation_report").html(asciiart + '       Waiting for installation to complete.');
			var progress_path = $("#installation_status").data("progresspath");
			var evtSource = new EventSource(progress_path);
			var last_line_in_build_progress_log = '';
			var second_last_line_in_build_progress_log = '';
			var new_line;
			
			var progress_listener = function(e) {
				new_line = e.data;
				second_last_line_in_build_progress_log = last_line_in_build_progress_log;
				last_line_in_build_progress_log = new_line;
				$("#installation_progress").prepend(new_line + '<br>');
			};

			var report_listener = function(e) {
				new_line = e.data;
				if ($("#installation_report").html().includes("Waiting for installation to complete.")) {
					$("#installation_report").html('');
					};
				$("#installation_report").append(new_line + '<br>');
			};
			
			var complete_listener = function(e) {
				if ($("#installation_report").html().includes("Waiting for installation to complete.")) {
					$("#installation_report").html('No report');
					};
				if (e.data == 'close') {
    		    	// evtSource.removeEventListener("installation_report", report_listener, false);
					// alert(second_last_line_in_build_progress_log);
					var build_result = second_last_line_in_build_progress_log;
					evtSource.close();
					$("#installation_done_button").slideDown();
					$("#installation_result_notifier").slideDown();
					if ((/^ERROR/).test(build_result)) {
						$("#installation_result_notifier").addClass("alert-danger");
					} else {
						$("#installation_result_notifier").addClass("alert-success");
						$("#installation_report_tab_button").click();
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
