$(document).ready(function() {
    $('.selectize-single').selectize();

    $('.selectize-multi').selectize(
// selectize needs to be configured for multi-select.
    );

    // $(".software_installation_form .advanced_fields").hide();
    $("#show_advanced_fields_button").click(function() {
      $(".new_software_form_default_details").toggle();
      $(".advanced_fields").toggle();
    });

});
