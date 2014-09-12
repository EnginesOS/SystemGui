$(document).ready(function(){

    $("#accept-label").click(function() {
      $(this).children().first().next().trigger("click");
    });

    $("#accept-label").children().first().next().click(function() {
      $(this).trigger("click");
    });

});