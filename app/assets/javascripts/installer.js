$(document).ready(function(){

    // $(".software_installation_form .advanced_fields").hide();

    $("#new_software_form_show_advanced_fields_button").click(function() {
      $(".new_software_form_default_details").toggle();
      $(".advanced_fields").toggle();
    });

    if ($("#installing_progress").length > 0){
		$("#installing_progress").html('Installing...<br>');
		var evtSource = new EventSource("/installs/progress");
		evtSource.addEventListener("message", function(e) {
			new_line = e.data;
			$("#installing_progress").html(new_line + '<br>' + $("#installing_progress").html());
		});
		evtSource.addEventListener("error", function(e) {
			window.location.href="/control_panel";
		}, false);
   };

});

