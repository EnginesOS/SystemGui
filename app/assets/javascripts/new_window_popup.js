$(document).ready(function(){

	bind_new_window_popup_events();

});

function bind_new_window_popup_events() {

	$('a[data-popup]').on('click', function(e) {
		e.preventDefault();
		window.open($(this).attr('href'), "engines_popup", "height=600,width=800").focus();
	});
};

