$(document).ready(function(){

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

