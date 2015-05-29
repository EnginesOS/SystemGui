$(document).ready(function(){


    $(".advanced_menu_item").click(function () {

    	alert('hi');
    	
    });

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



    function load_control_panel_objects(){
	    $(".control_panel .control_panel_object").each ( function(){
	    	var applicationName = $(this).attr('id');
	      	load_control_panel_object($(this));
	    }); 
	}
    
    load_control_panel_objects(); 
    setInterval(function(){
	    // load_control_panel_objects(); 
	}, 60000);
    
    
    
    function load_control_panel_object(obj) {

      var url = obj.attr("data-url");

	  var last_load = obj.next().html();

      $.ajax({
          url: url,
          cache: false,
          success: function(html){
          	// html = $("#html_holder").html();
          	// alert(exisitng_html.length);
          	// alert(html.length);
          	obj.next().next().text( html );
            if ( obj.next().next().text() != obj.next().text() ) {
	          	obj.next().text( html );
            	obj.html( html );
            };
          }
      });

    };


});

