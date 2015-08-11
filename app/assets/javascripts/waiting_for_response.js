function show_waiting_for_response_modal() {
  $('#waiting-for-response-modal').modal('show');
  $('#big_waiting_for_response_spinner').fadeIn(1000);
};

function bind_trigger_response_modal_events() {
  $(".trigger-response-modal").click(function(){
    show_waiting_for_response_modal();
  });
};

function show_submit_message() {
    $('.form-buttons').hide();
    $('.submit-message').show();
};
function show_cancel_message() {
    $('.form-buttons').hide();
    $('.cancel-message').show();
};

function bind_form_button_events() {
  $(".form-button-submit").click(function(){
    show_submit_message();
    show_waiting_for_response_modal();
  });
  $(".form-button-cancel").click(function(){
    show_cancel_message();
    show_waiting_for_response_modal();
  });
};

$(document).ready(function(){
  bind_trigger_response_modal_events();
  bind_form_button_events();
});

$(window).unload( function() {
  $('#waiting-for-response-modal').hide();
});
