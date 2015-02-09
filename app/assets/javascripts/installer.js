$(document).ready(function(){

    $(".software_installation_form .advanced_fields").hide();

    $("#new_software_form_show_advanced_fields_button").click(function() {
      $(".new_software_form_default_details").toggle();
      $(".advanced_fields").toggle();
    });

});

