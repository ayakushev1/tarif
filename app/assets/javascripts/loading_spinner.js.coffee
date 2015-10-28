#Turbolinks.enableProgressBar();

$(document).on 'ajaxStart', ->
  $("#loading-indicator-ajax").show()
	
$(document).on 'ajaxComplete', ->
  $("#loading-indicator-ajax").hide()   


$(document).on 'page:fetch', ->  
  $("#loading-indicator").show()

$(document).on 'ready page:load', ->
  $("#loading-indicator").hide()


  