$(document).ready(function(){



	function collapse_system_status_message() {
			if ($("#status_message_area_when_menu_collpased").html().length) {

			};
			if ($("#status_message_area_when_menu_not_collpased").html().length) {

			};
	};



	function position_status_message() {

		if ($('.navbar-collapse').is(':visible') && !$('.navbar-toggle').is(':visible')) {
			if ($.trim($("#status_message_area_when_menu_collpased").html()).length) {
				var from_area = $("#status_message_area_when_menu_collpased");
				$("#status_message_area_when_menu_not_collpased").html(from_area.html());
				from_area.empty();
			};
		} else {
			if ($.trim($("#status_message_area_when_menu_not_collpased").html()).length) {
				var from_area = $("#status_message_area_when_menu_not_collpased");
				$("#status_message_area_when_menu_collpased").html(from_area.html());
				from_area.empty();
			};


				//
			// collapse_system_status_message();
		};


		// $('.navbar').on('hidden', function() {
		// 	alert("hi");
		// });
	};

	$( window ).resize(function() {
      position_status_message();
    });

    position_status_message();

});
