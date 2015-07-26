$(document).ready(function() {


	// function clear_field_error_message_for(field) {
		// field.popover('hide');
	// };
// 
	// function show_field_error_message_for(field, message) {
		// field.popover('show');
	// };
// 
	// $("#sign-in-page").click( function() {
    // });
// 
// 
 // $("#first_run_admin_password").change( function() {
	// // clear_field_error_message_for(this);
 	// if ( $(this).val().length == 0 ) {
 		// show_field_error_message_for(this, "Admin password should not be blank.");
 	// } else if ($(this).val() == $("#first_run_console_password").val() ) { 
 		// show_field_error_message_for(this, "Admin and console password should not match.");
	// } else if ($(this).val().length < 6 || $(this).val().length > 40) {
 		// show_field_error_message_for(this, "Admin password should be between 6 and 40 characters.");
 	// };
 // });
// 
 // $("#first_run_admin_password_confirmation").change( function() {
 	// if ( $(this).val().length > 0 && $(this).val() != $("#first_run_admin_password").val() ) { 
 		// show_field_error_message_for(this, "Admin password and confirmation do not match.");
	// };
 // });
// 
 // $("#first_run_console_password").change( function() {
 	// if ( $(this).val().length == 0 ) {
 		// show_field_error_message_for(this, "Console password should not be blank.");
 	// } else if ($(this).val() == $("#first_run_admin_password").val() ) { 
 		// show_field_error_message_for(this, "Admin and console password should not match.");
	// } else if ($(this).val().length < 6 || $(this).val().length > 40) {
 		// show_field_error_message_for(this, "Console password should be between 6 and 40 characters.");
 	// };
 // });
// 
 // $("#first_run_console_password_confirmation").change( function() {
 	// if ( $(this).val().length > 0 && $(this).val() != $("#first_run_console_password").val() ) { 
 		// show_field_error_message_for(this, "Console password and confirmation do not match.");
	// };
 // });
// 
 // $("#first_run_mysql_password").change( function() {
 	// if ( $(this).val().length == 0 ) {
 		// show_field_error_message_for(this, "MySQL password should not be blank.");
	// } else if ($(this).val().length < 6 || $(this).val().length > 40) {
 		// show_field_error_message_for(this, "MySQL password should be between 6 and 40 characters.");
 	// };
 // });
// 
 // $("#first_run_mysql_password_confirmation").change( function() {
 	// if ( $(this).val().length > 0 && $(this).val() != $("#first_run_mysql_password").val() ) { 
 		// show_field_error_message_for(this, "MySQL password and confirmation do not match.");
	// };
 // });



  $("#first_run_form_auto_generate_passwords_button").click(function() {
    admin_password = randomPassword();
    console_password = randomPassword();
    mysql_password = randomPassword();

    var passwords_html = '<pre style="font-size: 18px;"><div><label>   Admin password: </label> ' + admin_password +'</div>' +
      '<div><label>   Console password: </label> ' + console_password + '</div>' +
      '<div><label>   MySQL password: </label> ' + mysql_password + '</div>';

    $("#first_run_form_auto_generated_passwords").html(passwords_html);

	$("#first_run_admin_password").val(admin_password);
	$("#first_run_admin_password_confirmation").val(admin_password);
	$("#first_run_console_password").val(console_password);
	$("#first_run_console_password_confirmation").val(console_password);
	$("#first_run_mysql_password").val(mysql_password);
	$("#first_run_mysql_password_confirmation").val(mysql_password);

  });

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

});