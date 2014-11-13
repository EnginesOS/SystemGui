$(document).ready(function(){

    $(".advanced_menu_item").click(function () {
      modal_id = $(this).attr("data-target");
      modal_body_id = modal_id + "_body";

      container_name = $(this).attr("data-container");
      controller = $(this).attr("data-controller");
      partial_url = "/" + controller + "/" + container_name + "/advanced_detail";

      $.ajax({
          url: partial_url,
          cache: false,
          success: function(html){
            $(modal_body_id).html(html);
          }
      });

    });

});

