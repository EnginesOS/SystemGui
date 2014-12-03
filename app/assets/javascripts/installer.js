$(document).ready(function(){

    function tailScroll() {
      var height = $("#waiting-for-response-modal .streamed-text").get(0).scrollHeight;
      $("#waiting-for-response-modal .streamed-text").animate({
          scrollTop: height
      }, 500);
    };

    $("#accept-label").click(function() {
      $(this).children().first().next().trigger("click");
    });

    $("#accept-label").children().first().next().click(function() {
      $(this).trigger("click");
    });

    if ($(".app_installs").length > 0){
      $('.modal').on('shown.bs.modal', function (e) {
        // $.ajax({
        //   url: "/install_progress",
        //   cache: false,
        //   success: function(html){
        //     $("#waiting-for-response-modal .streamed-text").html(html);
        //     tailScroll();
        //   }
        // });
      })
    }

});

