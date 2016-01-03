function update_pagination_link_class() {
   $.each( $('.pagination a'), function(i, obj) {
     $(obj).addClass('trigger-response-modal');
   });
};
