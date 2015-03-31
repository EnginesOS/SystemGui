$(document).ready(function() {
  $(".installer_confirgure_attached_service_button").click(function() {
  	$(this).parent().prev().slideDown();
  	$(this).parent().prev().prev().fadeOut(250);
  	$(this).fadeOut(250);
  });

  $(".installer_attach_service_create_type_radios").click(function() {
  	alert('hi');
  });
  
});