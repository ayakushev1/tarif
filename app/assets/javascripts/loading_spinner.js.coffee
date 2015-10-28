$(document).on 'page:fetch', ->
	$("#loading-indicator").show()

$(document).on 'ready page:load', ->
	$("#loading-indicator").hide()


$(document).on 'ajax:before ajaxStart', ->
	$("#loading-indicator-ajax").show()

$(document).on 'ajaxComplete', ->
	$("#loading-indicator-ajax").hide()
