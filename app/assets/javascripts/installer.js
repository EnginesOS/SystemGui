$(document).ready(function(){

    // function tailScroll() {
    //   var height = $("#waiting-for-response-modal .streamed-text").get(0).scrollHeight;
    //   $("#waiting-for-response-modal .streamed-text").animate({
    //       scrollTop: height
    //   }, 500);
    // };

    // $("#accept-label").click(function() {
    //   $(this).children().first().next().trigger("click");
    // });

    $("#new_software_form_advanced_fields").hide();

    $("#new_software_form_show_advanced_fields_button").click(function() {
      $("#new_software_form_default_details").slideUp();
      $("#new_software_form_show_advanced_fields_button").slideUp();
      $("#new_software_form_advanced_fields").slideDown();
    });

    // $("#new_software_form_show_advanced_fields_button").click(function() {
    //   alert('hi');
    // });


    // $("#accept-label").children().first().next().click(function() {
    //   $(this).trigger("click");
    // });

    // if ($(".softwares").length > 0){
    //   $('.modal').on('shown.bs.modal', function (e) {

    //     // var source = new EventSource('/install_progress');
    //     // source.addEventListener('message', function(event) {
    //     //   $("#waiting-for-response-modal .streamed-text").html(event.data)
    //     // });


    //     // $.ajax({
    //     //   url: "/install_progress",
    //     //   cache: false,
    //     //   success: function(html){
    //     //     $("#waiting-for-response-modal .streamed-text").html(html);
    //     //     tailScroll();
    //     //   }
    //     // });
    //   })
    // }

});

