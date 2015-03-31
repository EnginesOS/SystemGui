jQuery(document).ready(function($) {
  $(".clickable-table-row").click(function() {
    window.document.location = $(this).attr("href");
  });
  $(".clickable-table-row").css('cursor', 'pointer');
  $(".clickable-table-row").addClass('trigger-response-modal');
});