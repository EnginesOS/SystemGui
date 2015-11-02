$(document).ready(function() {

	if ($('#first_run_form').length > 0) {
		
	
		function setup_first_run_form() {
			var submit_button_area = $('#first_run_form').find('.form-button-submit').parent();
			var template = $("#first_run_submit_validation_template").html();
			submit_button_area.before(template);
			var submit_validation_button_area = submit_button_area.prev();
			var submit_validation_button = submit_validation_button_area.find('.btn');
			submit_validation_button.attr('id', 'first_run_submit_validation_button');
			submit_button_area.hide();
			bind_first_form_submit_validation_button_events();
			bind_field_change_events();
		};
	
		function bind_first_form_submit_validation_button_events() {

			$("#first_run_submit_validation_button").click( function () {
				if (first_run_form_validation()) {
					submit_first_run_form();
				} else {
					var first_alert = $('.alert.alert-warning:visible');
					if (first_alert.length > 0) {
							$('html, body').animate({
							    scrollTop: first_alert.offset().top - 60
							}, 500);
					} else {
						alert('Validation error');
					};
				};
			});

		    $(window).keydown(function(event){
			    if(event.keyCode == 13) {
			      event.preventDefault();
			      $("#first_run_submit_validation_button").click();
			    }
			});

		};
	
		function submit_first_run_form() {
			var submit_button = $('#first_run_form').find('.form-button-submit');
			var submit_button_area = submit_button.parent();
			submit_button_area.show();
			submit_button.click();
		};
	
		function first_run_form_validation() {
			var admin_ok = (first_run_admin_password_validation() && first_run_admin_password_confirmation_validation());
			var console_ok = (first_run_console_password_validation() && first_run_console_password_confirmation_validation());
			var email_ok = first_run_admin_email_validation();
			var mysql_ok = (first_run_mysql_password_validation() && first_run_mysql_password_confirmation_validation());
			var domain_ok = first_run_default_domain_validation();
			var ssl_ok = first_run_ssl_validation();
			return (admin_ok && console_ok && email_ok && mysql_ok && domain_ok && ssl_ok);
		};
	
		function show_field_error_message_for(field, message) {
			var template = $("#first_run_field_error_template").html();
			var field_area = $(field).parent().parent();
			field_area.before(template);
			var error_area = field_area.prev();
			var field_id = $(field).attr('id');
			var error_id = field_id + '_field_error';
			error_area.attr('id', error_id);
			error_area.find('.first_run_error_message').text(message);
		};
	
		function clear_field_error_message_for(field) {
			var field_area = $(field).parent().parent();
			var error_area = field_area.prev().children('.alert').parent();
			if (error_area.length > 0) {
				error_area.remove();
			};
		};
	
		function first_run_admin_password_validation() {
			var field = $("#first_run_admin_password");
	 		clear_field_error_message_for(field);
		 	if ( field.val().length == 0 ) {
		 		show_field_error_message_for(field, "Admin password can't be blank.");
		 		return false;
			} else if (field.val().length < 6 || field.val().length > 40) {
		 		show_field_error_message_for(field, "Admin password must be 6 to 40 characters.");
		 		return false;
		 	} else if (field.val() == $("#first_run_console_password").val() ) { 
		 		show_field_error_message_for(field, "Admin password and Console password can't be the same.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_admin_email_validation() {
			var admin_email_field = $("#first_run_admin_email");
			var email_regex = /^([a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
	 		clear_field_error_message_for(admin_email_field);
	 		var email_input_val = admin_email_field.val();
		 	if ( email_regex.test(email_input_val) ) {
		 		return true; 
		 	} else {
		 		show_field_error_message_for(admin_email_field, "Valid email required.");
		 		return false;
		 	};
		};

		function first_run_admin_password_confirmation_validation() {
			var password_confirmation_field = $("#first_run_admin_password_confirmation");
			var password_field = $('#first_run_admin_password');
	 		clear_field_error_message_for(password_field);
		 	if (password_confirmation_field.val() != password_field.val() ) {
		 		show_field_error_message_for(password_field, "Admin password and confirmation do not match.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_console_password_validation() {
			var field = $("#first_run_console_password");
	 		clear_field_error_message_for(field);
		 	if ( field.val().length == 0 ) {
		 		show_field_error_message_for(field, "Console password can't be blank.");
		 		return false;
			} else if (field.val().length < 6 || field.val().length > 40) {
		 		show_field_error_message_for(field, "Admin password must be 6 to 40 characters.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_console_password_confirmation_validation() {
			var password_confirmation_field = $("#first_run_console_password_confirmation");
			var password_field = $('#first_run_console_password');
	 		clear_field_error_message_for(password_field);
		 	if (password_confirmation_field.val() != password_field.val() ) {
		 		show_field_error_message_for(password_field, "Console password and confirmation do not match.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_mysql_password_validation() {
			var field = $("#first_run_mysql_password");
	 		clear_field_error_message_for(field);
		 	if ( field.val().length == 0 ) {
		 		show_field_error_message_for(field, "MySQL password can't be blank.");
		 		return false;
			} else if (field.val().length < 6 || field.val().length > 40) {
		 		show_field_error_message_for(field, "MySQL password must be 6 to 40 characters.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_mysql_password_confirmation_validation() {
			var password_confirmation_field = $("#first_run_mysql_password_confirmation");
			var password_field = $('#first_run_mysql_password');
	 		clear_field_error_message_for(password_field);
		 	if (password_confirmation_field.val() != password_field.val() ) {
		 		show_field_error_message_for(password_field, "MySQL password and confirmation do not match.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function first_run_default_domain_validation() {
			var field = $("#first_run_default_domain");
	 		clear_field_error_message_for(field);
		 	if ( field.val().length == 0 ) {
		 		return true;
			} else if (is_invalid_domain_name(field.val())) {
		 		show_field_error_message_for(field, "Domain name is not valid.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};

		function is_invalid_domain_name(domain_name) {
			var domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/;
			return !domain_name_regex.test(domain_name);
		};


		function first_run_ssl_validation() {
			var first_field = $('#first_run_ssl_person_name');
	 		clear_field_error_message_for(first_field);
		 	if ( $('#first_run_ssl_person_name').val().length == 0 ) {
		 		show_field_error_message_for(first_field, "Person name can't be blank.");
		 		return false;
			} else if ( $('#first_run_ssl_organisation_name').val().length == 0 ) {
		 		show_field_error_message_for(first_field, "Organisation name can't be blank.");
		 		return false;
			} else if ( $('#first_run_ssl_city').val().length == 0 ) {
		 		show_field_error_message_for(first_field, "City can't be blank.");
		 		return false;
			} else if ( $('#first_run_ssl_state').val().length == 0 ) {
		 		show_field_error_message_for(first_field, "State can't be blank.");
		 		return false;
			} else if ( $('#first_run_ssl_country').val().length == 0 ) {
		 		show_field_error_message_for(first_field, "Country can't be blank.");
		 		return false;
		 	} else {
		 		return true;
		 	};
		};
	
	
		function bind_field_change_events() {
	
			 $("#first_run_admin_password").change( function() {
			 	if ($('#first_run_admin_password').val() ==  $('#first_run_form_auto_generated_passwords').find('.admin_password').text()) {
					$('#first_run_form_auto_generated_passwords').find('.admin_password_area').attr('style', 'color: #31708f');
				} else {
					$('#first_run_form_auto_generated_passwords').find('.admin_password_area').attr('style', 'color: #B7CDD8');
				};
			 });
			
			 $("#first_run_console_password").change( function() {
			 	if ($('#first_run_console_password').val() ==  $('#first_run_form_auto_generated_passwords').find('.console_password').text()) {
					$('#first_run_form_auto_generated_passwords').find('.console_password_area').attr('style', 'color: #31708f');
				} else {
					$('#first_run_form_auto_generated_passwords').find('.console_password_area').attr('style', 'color: #B7CDD8');
				};
			 });
			
			 $("#first_run_mysql_password").change( function() {
			 	if ($('#first_run_mysql_password').val() ==  $('#first_run_form_auto_generated_passwords').find('.mysql_password').text()) {
					$('#first_run_form_auto_generated_passwords').find('.mysql_password_area').attr('style', 'color: #31708f');
				} else {
					$('#first_run_form_auto_generated_passwords').find('.mysql_password_area').attr('style', 'color: #B7CDD8');
				};
			 });
		
			$("#first_run_form_auto_generate_passwords_button").click(function() {
			    var admin_password = randomPassword();
			    var console_password = randomPassword();
			    var mysql_password = randomPassword();
			    var passwords_html = $('#first_run_auto_generated_passwords_template').html();
			
			    $("#first_run_form_auto_generated_passwords").html(passwords_html);
			    $("#first_run_form_auto_generated_passwords").find('.admin_password').text(admin_password);
			    $("#first_run_form_auto_generated_passwords").find('.console_password').text(console_password);
			    $("#first_run_form_auto_generated_passwords").find('.mysql_password').text(mysql_password);
			
				$("#first_run_admin_password").val(admin_password);
				$("#first_run_admin_password_confirmation").val(admin_password);
				$("#first_run_console_password").val(console_password);
				$("#first_run_console_password_confirmation").val(console_password);
				$("#first_run_mysql_password").val(mysql_password);
				$("#first_run_mysql_password_confirmation").val(mysql_password);
			
			  });
			};
	
	  function randomPassword() {
	    var chars = "23456789ABCDEFGHJKLMNPQRSTUVWXTZabcdefghikmnpqrstuvwxyz";
	    var string_length = 10;
	    var randomstring = '';
	    for (var i=0; i<string_length; i++) {
	        var rnum = Math.floor(Math.random() * chars.length);
	        randomstring += chars.substring(rnum,rnum+1);
	      };
	    return randomstring;
	  };
	  
	  setup_first_run_form();

	};

});