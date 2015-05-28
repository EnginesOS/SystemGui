$(document).ready(function(){

    $(".control_panel .application").each ( function(){
    	var applicationName = $(this).attr('id');

    	
    	
    	
    	
    	
      	load_control_panel_application($(this));
    }); 
    
    
    
    function load_control_panel_application(obj) {

      var url = obj.attr("data-url");

      $.ajax({
          url: url,
          cache: false,
          success: function(html){
            obj.html(html);
          }
      });

    };




    $(".advanced_menu_item").click(function () {
      modal_id = $(this).attr("data-target");
      modal_body_id = modal_id + "_body";

      url = $(this).attr("data-url");

      $.ajax({
          url: url,
          cache: false,
          success: function(html){
            $(modal_body_id).html(html);
          }
      });

    });

});

