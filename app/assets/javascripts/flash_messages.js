$(document).ready(function () {
    // $('body').click(function () {
      // $('.alert').slideUp().delay(5000);
    // });

	do_flash_messages();

// alert('hi');


});




function do_flash_messages() {
	
	// alert('ho');				

	


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

  	


// 
// <div id="flash_message_template" style="display: none;">
	// <div class="alert">
	  // <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  // <div class="message_body" %></div>
	// </div>
// </div>
// 
	// <% flash.each do |name, msg| %>
     // <%= content_tag :div, nil, class:"flash_message_data" data: {alertclass: name.to_s == 'notice' ? 'success' : 'danger', messagebody: msg} %>">
	// <% end %>