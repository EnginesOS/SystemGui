$(document).ready(function() {

	load_desktop_objects();

	function load_desktop_objects() {
		$(".desktop-view .desktop_object").each(function() {
			var applicationName = $(this).attr('id');
			load_desktop_object($(this));
		});
	}

	function load_desktop_object(obj) {

		var url = obj.attr("data-url");

		obj.next().html(obj.html());

		$.ajax({
			url : url,
			cache : false,
			success : function(html) {
				obj.replaceWith(html);
			}
		});

	};

});

