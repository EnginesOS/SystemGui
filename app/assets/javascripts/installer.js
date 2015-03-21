$(document).ready(function(){

    // $(".software_installation_form .advanced_fields").hide();

    $("#new_software_form_show_advanced_fields_button").click(function() {
      $(".new_software_form_default_details").toggle();
      $(".advanced_fields").toggle();
    });

    if ($("#installing_progress").length > 0){
		$("#installing_progress").html('Installing...<br>');
		var evtSource = new EventSource("/installs/progress");
		var last_line = '';
		var second_last_line = '';
		evtSource.addEventListener("message", function(e) {
			new_line = e.data;
			second_last_line = last_line;
			last_line = new_line;
			$("#installing_progress").html(new_line + '<br>' + $("#installing_progress").html());
		});
		evtSource.addEventListener("error", function(e) {

alert(second_last_line);

			window.location.href="/control_panel";
		}, false);
   };

});

