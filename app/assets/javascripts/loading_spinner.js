$(document).on('page:fetch', function() {
	  $("#loading-indicator").show();
	});

$(document).ajaxSend(function(event, request, settings) {
    $('#loading-indicator').show();
});

$(document).ajaxComplete(function(event, request, settings) {
    $('#loading-indicator').hide();
});

