$(document).ready(function() {

	$(".docker_hub_install_new_attach_services_menu_button").click(function() {
		var type_path = $(this).attr("data-typepath");
		var publisher_namespace = $(this).attr("data-publishernamespace");
		$("#docker_hub_installation_new_application_service_publisher_namespace").val(publisher_namespace);
		$("#docker_hub_installation_new_application_service_type_path").val(type_path);
		$("#new_docker_hub_installation").submit();
	});

	$("#docker_hub_install_new_eport_button").click(function() {
		$("#docker_hub_installation_new_eport").val("1");
		$("#new_docker_hub_installation").submit();
	});

	$("#docker_hub_install_new_environment_variable_button").click(function() {
		$("#docker_hub_installation_new_environment_variable").val("1");
		$("#new_docker_hub_installation").submit();
	});

	var scroll_form_to = ($("#docker_hub_installation_scroll_form_to").val() || "");
	if (scroll_form_to != "") {
		$('body').animate({
			scrollTop : ($("." + scroll_form_to).last().offset().top - 100)
		}, 0);
	};

});

function remove_fields(link) {
	if ($(link).attr("data-confirm") == undefined) {
		$(link).prev().val("1");
		var selector_to_remove = "." + $(link).attr("data-holderclass");
		$(link).parentsUntil(selector_to_remove).hide();
	  };
     $('#waiting-for-response-modal').modal('hide');
};