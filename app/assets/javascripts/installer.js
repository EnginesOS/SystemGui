$(document).ready(function(){
	
	if ($("#find_by_tags_list_loader").length > 0) {
		var gallery_id = $("#find_by_tags_list_loader").data('galleryid');
		$.get("gallery_software/tags_list", {gallery_id: gallery_id}, function(tags_list){
			if (tags_list) {			
				$("#find_by_tags_list_holder").html(tags_list);
				$('#installer_find_button').html($('#find_button_when_tags_present').html()); 
				$('#search_result_summary').html($('#search_result_summary_when_tags_present').html()); 
				bind_trigger_response_modal_events();
			}
			$("#find_by_tags_list_loader").remove();
		});
	};
	
	if ($("#gallery_software_loader").length > 0 ) {
		var gallery_id = $("#gallery_software_loader").data('galleryid');
		var search = $("#gallery_software_loader").data('search');
		var tags = $("#gallery_software_loader").data('tags');
		var page = $("#gallery_software_loader").data('page');
		$.get("gallery_software", {gallery_id: gallery_id, search: search, tags: tags, page: page}, function(data){
			$("#gallery_software_holder").html(data);
			$("#gallery_software_holder").show();
			$("#gallery_software_loader").remove();
			bind_trigger_response_modal_events();
			});
	};


    if ($("#installation_status").length > 0) {
    	if ($("#installation_progress").html() == '') {
			$("#installation_progress").html('Starting installation.');
			var asciiart = "  ______                   _                      \n |  ____|                 (_)                     \n | |__     _ __     __ _   _   _ __     ___   ___ \n |  __|   | '_ \\   / _` | | | | '_ \\   / _ \\ / __|\n | |____  | | | | | (_| | | | | | | | |  __/ \\__ \\\n |______| |_| |_|  \\__, | |_| |_| |_|  \\___| |___/\n                    __/ |                         \n                   |___/\n\n";
			$("#installation_report").html(asciiart + '       Waiting for installation to complete.');
			var progress_path = $("#installation_status").data("progresspath");
			var evtSource = new EventSource(progress_path);
			var build_progress_log_result_message = '';
			var new_line;
			
			var progress_listener = function(e) {
				new_line = e.data;
				if (new_line.substring(0, 13) == "Build Result:") {
					build_progress_log_result_message = new_line.substring(13);
				};

				var new_html = ansi_up.ansi_to_html(new_line);
				$("#installation_progress").prepend(new_html + '\n');
			};

			var report_listener = function(e) {
				new_line = e.data;
				if ($("#installation_report").html().indexOf("Waiting for installation to complete.") > -1 ) {
					$("#installation_report").html('');
					};
				var html = ansi_up.ansi_to_html(new_line);
				$("#installation_report").append(html + '<br>');
			};
			
			var complete_listener = function(e) {
				if ($("#installation_report").html().indexOf("Waiting for installation to complete.") > -1 ) {
					$("#installation_report").html('No report');
					};
				if (e.data == 'close') {
					var flash_message = "Done. " + build_progress_log_result_message;
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
					$("#open_installation_report_in_new_tab").show();
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
