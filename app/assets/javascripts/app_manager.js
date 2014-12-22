$(document).ready(function(){

    $(".advanced_menu_item").click(function () {
      modal_id = $(this).attr("data-target");
      modal_body_id = modal_id + "_body";

      engine_name = $(this).attr("data-engine");
      controller = $(this).attr("data-controller");
      partial_url = "/" + controller + "/" + engine_name + "/advanced_detail";

      $.ajax({
          url: partial_url,
          cache: false,
          success: function(html){
            $(modal_body_id).html(html);
          }
      });

    });

});

