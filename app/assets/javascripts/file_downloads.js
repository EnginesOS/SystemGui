$(document).ready(function() {

	$('.auto-close-response-modal').click(function(){
		setTimeout(function(){
			$('#waiting-for-response-modal').fadeOut(500, function(){
				$('#waiting-for-response-modal').modal('hide');
			});
		}, 2000);
	});

});
