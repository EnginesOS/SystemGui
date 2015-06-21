$(document).ready(function(){
	

	
	if ($(".gallery_software_holder").length > 0) {
		$.each($(".gallery_software_holder"), function(index, gallery) {
				$.get("gallery_software", {gallery_id: $(gallery).data('galleryid'), search: $(gallery).data('search')}, function(data){
					$(gallery).html(data);
					bind_trigger_response_modal_events();
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
				// var html = new_line;
				var new_html = ansi_up.ansi_to_html(new_line);
				if ( overwrite_last_line(new_line) ) {
					var original_html = $("#installation_progress").html();
					// var replacement_html = original_html;
					// alert(replacement_html.split('<br>').slice(0).join('<br>'));
					replacement_html = original_html.substring(original_html.indexOf("<br>") + 4);
					$("#installation_progress").html(replacement_html);
				};
				$("#installation_progress").prepend(new_html + '<br>');
			};

			function overwrite_last_line(string) {
				if (string.charCodeAt(3) == 109 && string.charCodeAt(8) == 109) {
					// alert(  string.charCodeAt(0) + " " + 
							// string.charCodeAt(1) + " " + 
							// string.charCodeAt(2) + " " + 
							// string.charCodeAt(3) + " " + 
							// string.charCodeAt(4) + " " + 
							// string.charCodeAt(5) + " " + 
							// string.charCodeAt(6) + " " + 
							// string.charCodeAt(7) + " " + 
							// string.charCodeAt(8) + " " + 
							// string.charCodeAt(9) + " " + 
							// string.charCodeAt(10) + " " + 
							// string.charCodeAt(11) + " " + 
							// string.charCodeAt(12) + " " + 
							// string.charCodeAt(13) + " " + 
							// string.charCodeAt(14) + " " + 
							// string.charCodeAt(15));
					return true;
				};
			};


			var report_listener = function(e) {
				new_line = e.data;
				if ($("#installation_report").html().includes("Waiting for installation to complete.")) {
					$("#installation_report").html('');
					};
				var html = ansi_up.ansi_to_html(new_line);
				$("#installation_report").append(html + '<br>');
			};
			
			var complete_listener = function(e) {
				if ($("#installation_report").html().includes("Waiting for installation to complete.")) {
					$("#installation_report").html('No report');
					};
				if (e.data == 'close') {
					var flash_message = second_last_line_in_build_progress_log;
					evtSource.close();
					$("#installation_done_button").slideDown();
					if ((/^ERROR/).test(flash_message)) {
						var flash_alert_class = 'danger';
					} else {
						var flash_alert_class = 'success';
					};
					var flash_message_data_html = '<div class="flash_message_data" data-messagebody="' + flash_message + '" data-alertclass="' + flash_alert_class + '" >';
					$("body").append(flash_message_data_html);
					do_flash_messages();
					$("#installation_report_tab_button").click();
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
