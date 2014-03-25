getUrlMain = (string) ->
  string.slice(0, string.indexOf('?'))

getUrlVars = (string1) ->
  string = string1.replace(/%5B/g,'[').replace(/%5D/g,']')
  alert(string)
  vars = {}  
  hashes = string.slice(string.indexOf('?') + 1).split('&')
  $.each hashes, (i, v)->
    hash = hashes[i].split('=')
    vars[hash[0]] = hash[1]
  vars


#$(document).on 'ready page:load ajaxComplete', -> 
#$(document).on 'ajaxComplete', -> 
$(document).on 'click', '[class*=___pagination] a', ->
  a = $(this).attr('href')
  unless $.isEmptyObject(a)
    b = getUrlMain(a)
    c = getUrlVars(a)
  #  $(this).attr('href', null)
  #  $('[id=games_search_activities_]').html(null)
    $.ajax
      url: null,#'/games/search_activities'
      data: c,
      dataType: "script"        
  #    success: (data, textStatus, jqXHR) ->
  #      $('[id=games_search_activities_]').html(data)
  #      alert(data)
  false         
