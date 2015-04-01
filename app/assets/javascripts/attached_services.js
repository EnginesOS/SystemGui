$(document).ready(function() {
  $(".installer_configure_attached_service_button").click(function() {
  	$(this).parent().parent().hide();
  	$(this).parent().parent().siblings(".attached_service_select_create_type").slideDown();
  });
  
  $(".attached_service_select_create_type_button").click(function() {
  	if ($(this).parent().prev().find("input:checked").val() == "active") {
	  	$(this).parent().parent().siblings(".attached_service_active_configure").slideDown();
  	} else if ($(this).parent().prev().find("input:checked").val() == "orphaned") {
	  	$(this).parent().parent().siblings(".attached_service_orphan_configure").slideDown();
  	} else {
	  	$(this).parent().parent().siblings(".attached_service_select").slideDown();
  	};
  	$(this).parent().parent().fadeOut(250);
  });

  $(".attached_service_active_configure_button").click(function() {
  	$("#create_type_input").val("active");
  	$("#service_handle_input").val($(this).parent().parent().find(".attached_service_active_configure_select").val());
 	$(this).parent().parent().siblings(".attached_service_select").slideDown();
  	$(this).parent().parent().fadeOut(250);
  });
  
  $(".attached_service_orphan_configure_button").click(function() {
  	$("#create_type_input").val("orphaned");
  	$("#orphan_parent_name_input").val($(this).parent().parent().find(".attached_service_orphan_configure_select").val());
  	$(this).parent().parent().siblings(".attached_service_select").find(".attached_service_text").html($(this).parent().parent().find(".attached_service_orphan_configure_select").val());
 	$(this).parent().parent().siblings(".attached_service_select").slideDown();
  	$(this).parent().parent().fadeOut(250);
  });
  
});
