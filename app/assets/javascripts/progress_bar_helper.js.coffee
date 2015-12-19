checkProgress = (progresspump) ->
  calculationStatus = false
  $("[id*=progress_bar]").each (index, progress_bar) ->
    if index == 0      
      action = $(progress_bar).attr('action_name')
  #    current_progress_value = $(progress_bar).attr('current_progress_value')
  #    if current_progress_value.to_i > 0.99999
  #      calculationStatus = true    
  #    clearInterval(progresspump) if calculationStatus
      $.ajax
        url: action,
        dataType: "script"             
  
  
$(document).on 'ready page:load ajaxComplete', ->
  progresspump = setTimeout -> 
    checkProgress progresspump
  , 1000