$(document).ready(function () {
	do_flash_messages();
});

function do_flash_messages() {
	$(".flash_message_data").each( function () {
		var message = $(this).attr('data-messagebody');
		var alertClass = $(this).attr('data-alertclass');
		show_flash_message(message, alertClass);
		$(this).remove();
	});
};

function show_flash_message(message, alertClass) {
	if ( message != "null" ) {
		var template = $("#flash_message_template").html();
		flash_area = $("#flash_message_display_area").append(template);
		flash_area.find(".alert").last().addClass("alert-" + alertClass);
		flash_area.find(".message_body").last().text(message);
		$('body').scrollTop(0);
	};
};
