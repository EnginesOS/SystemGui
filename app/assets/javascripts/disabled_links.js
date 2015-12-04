$(document).ready(function() {
   $("li.disabled a").removeClass('trigger-response-modal');
   $("li.disabled a").click(function() {
     return false;
   });
});
