$(document).ready(function() {

	$("input#domain_domain_name").keyup(function(){
		animate_domain_form_checkboxes();
	});

});

function animate_domain_form_checkboxes() {
		if ($("#domain_domain_name").val() == 'local' ) {
			$("#domain_self_hosted").prop('checked', true);
			$("#domain_self_hosted").prop('disabled', true);
			$(".dependent_field_for_domain_self_hosted").show();
			$("#domain_internal_only").prop('checked', true);
			$("#domain_internal_only").prop('disabled', true);
		} else {
			$("#domain_self_hosted").prop('disabled', false);
			$("#domain_internal_only").prop('disabled', false);
		};
};

function scroll_form() {
	var scroll_form_to = ($("#install_from_docker_hub_scroll_form_to").val() || "");
	if (scroll_form_to != "") {
		var scroll_offset = $("." + scroll_form_to).last().offset().top - 100;
		$('html, body').animate({
			scrollTop : scroll_offset
		}, 0);
	};
};
