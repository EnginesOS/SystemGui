$(document).ready(function() {

	$(".docker_hub_install_new_attach_services_menu_button").click(function() {

		var publisher_namespace = $(this).attr("data-publishernamespace");
		var type_path = $(this).attr("data-typepath");

		$("#software_docker_hub_install_attributes_new_attached_service_publisher_namespace").val(publisher_namespace);
		$("#software_docker_hub_install_attributes_new_attached_service_type_path").val(type_path);
		$("#new_software").submit();

	});

	$("#docker_hub_install_new_eport_button").click(function() {
		$("#software_docker_hub_install_attributes_new_eport").val("1");
		$("#new_software").submit();
	});

	$("#docker_hub_install_new_environment_variable_button").click(function() {
		$("#software_docker_hub_install_attributes_new_environment_variable").val("1");
		$("#new_software").submit();
	});

	var scroll_form_to = ($("#software_docker_hub_install_attributes_scroll_form_to").val() || "");
	if (scroll_form_to != "") {
		$('body').animate({
			scrollTop : ($(scroll_form_to).offset().top - 500)
		}, 500);
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