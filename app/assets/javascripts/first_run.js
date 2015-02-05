$(document).ready(function() {

  $("#first_run_form_auto_generate_passwords_button").click(function() {
    admin_password = randomPassword();
    ssh_password = randomPassword();
    mysql_password = randomPassword();
    psql_password = randomPassword();

    var passwords_html = '<pre style="font-size: 18px;"><div><label>   Admin password: </label> ' + admin_password +'</div>' +
      '<div><label>     SSH password: </label> ' + ssh_password + '</div>' +
      '<div><label>   MySQL password: </label> ' + mysql_password + '</div>' +
      '<div><label>Postgres password: </label> ' + psql_password + '</div></pre>';

    $("#first_run_form_auto_generated_passwords").html(passwords_html);

$("#first_run_admin_password").val(admin_password);
$("#first_run_admin_password_confirmation").val(admin_password);
$("#first_run_ssh_password").val(ssh_password);
$("#first_run_ssh_password_confirmation").val(ssh_password);
$("#first_run_mysql_password").val(mysql_password);
$("#first_run_mysql_password_confirmation").val(mysql_password);
$("#first_run_psql_password").val(psql_password);
$("#first_run_psql_password_confirmation").val(psql_password);


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