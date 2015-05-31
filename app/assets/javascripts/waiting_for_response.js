



	function bind_trigger_response_modal_events() {

	  $(".trigger-response-modal").click(function(){

	    $('#waiting-for-response-modal').modal('show');
	  });
	
	  $("input").bind("invalid", function(){
	  	alert('hi');
		    $('#waiting-for-response-modal').modal('hide');
		    $('.form-buttons').show();
		    $('.submit-message').hide();
		});
	
	};
	
	// function confirmation_popup(object, message) {
	//   if(confirm(message)){
	//     $("#waiting-for-response-modal").modal("show");
	//   }else{
	//     object.data("method", ""); object[0].href = "";
	//   };
	// };
	
	function bind_form_button_events() {
	  $(".form-button-submit").click(function(){
	    show_submit_message();
	    $('#waiting-for-response-modal').modal('show');
	  });
	  $(".form-button-cancel").click(function(){
	    show_cancel_message();
	    $('#waiting-for-response-modal').modal('show');
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

$(document).ready(function(){

  bind_trigger_response_modal_events();
  bind_form_button_events();


});


