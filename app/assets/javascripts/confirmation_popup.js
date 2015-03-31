$.rails.allowAction = function(link) {
	if (!link.attr("data-confirm")) {
		return true;
	}
	$.rails.showConfirmDialog(link);
	return false;
};

$.rails.confirmed = function(link) {
	link.removeAttr('data-confirm');
	link.removeAttr('data-confirmdetail');
	link.trigger('click.rails');
	// if (link.attr('data-method') != 'delete') {
		// return window.location.replace("" + link.context.href + "");
	// };
};

$.rails.showConfirmDialog = function(link) {
	var html,
	    message,
	    message_detail;
	message = link.attr("data-confirm");
	message_detail = link.attr("data-confirmdetail");

	$("#confirmation_popup_title").html(message);
	$("#confirmation_popup_body").html(message_detail);
	$("#confirmation_popup").modal();

	$(document).on('click', '#confirmation_popup_accept_button', function() {
		$('#confirmation_popup').modal('hide');
		$('#waiting-for-response-modal').modal('show');
		$.rails.confirmed(link);
	});
};
