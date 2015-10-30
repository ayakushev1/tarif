#Turbolinks.enableProgressBar();

$(document).on 'ajaxStart', ->
  $("#loading-indicator-ajax").show()
	
$(document).on 'ajaxComplete', ->
  $("#loading-indicator-ajax").hide()   


$(document).on 'page:fetch', ->  
  $("#loading-indicator").show()

$(document).on 'page:load', -> #ready
  $("#loading-indicator").hide()


  