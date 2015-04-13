$(document).ready(function() {
    $('.selectize-single').selectize();

    $('.selectize-multi').selectize(
// selectize needs to be configured for multi-select.
    );

    $(".advanced_fields").hide();
    $(".attach_service_fields .advanced_fields").show();
    $("#show_advanced_fields_button").click(function() {
      $("#show_advanced_fields_button").hide();
      $(".new_software_form_default_details").slideUp();
      $(".advanced_fields").slideDown();
    });

});
