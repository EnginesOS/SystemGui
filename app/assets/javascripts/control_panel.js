$(document).ready(function(){


    function load_control_panel_applications(){
	    $(".control_panel .application").each ( function(){
	    	var applicationName = $(this).attr('id');
	      	load_control_panel_application($(this));
	    }); 
	}
    
    load_control_panel_applications(); 
    setInterval(function(){
	    load_control_panel_applications(); 
	}, 10000);
    
    
    
    function load_control_panel_application(obj) {

      var url = obj.attr("data-url");

	  var exisitng_html = obj.html().replace("btn-group open", "btn-group"); 

      $.ajax({
          url: url,
          cache: false,
          success: function(html){
          	$("#html_holder").html( html );
          	html = $("#html_holder").html();
          	// alert(exisitng_html.length);
          	// alert(html.length);
            if ( html != exisitng_html ) {
            	obj.html( html );
            };
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

