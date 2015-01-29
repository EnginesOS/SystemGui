$(document).ready(function(){
  bind_button_events();
  bind_form_button_events();
});

function bind_button_events() {
  $(".trigger-response-modal").click(function(){
    $('#waiting-for-response-modal').modal('show');
  });
};

function bind_form_button_events() {
  $(".form-button-submit").click(function(){
    show_submit_message();
    $('#waiting-for-response-modal').modal('show');
  });
  $(".form-button-cancel").click(function(){
    show_cancel_message();
  });
  function show_submit_message() {
      $('.form-buttons').hide();
      $('.submit-message').show();
  };
  function show_cancel_message() {
      $('.form-buttons').hide();
      $('.cancel-message').show();
  };

};



