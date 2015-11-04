getUrlMain = (string) ->
  string.slice(0, string.indexOf('?'))

getUrlVars = (string1) ->
  string = string1.replace(/%5B/g,'[').replace(/%5D/g,']')
  vars = {}  
  hashes = string.slice(string.indexOf('?') + 1).split('&')
  $.each hashes, (i, v)->
      hash = hashes[i].split('=')
      vars[hash[0]] = hash[1]
#  alert(hashes[0])
  vars


#$(document).on 'ready page:load ajaxComplete', -> 
#$(document).on 'ajaxComplete', -> 
$(document).on 'click', '[class*=pagination] a', ->
  a = $(this).attr('href')
  unless $.isEmptyObject(a)
    b = getUrlMain(a)
    c = getUrlVars(a)
#    alert(c.keys)
#    c = {}
#    c['pagination'] = {}
#    c['pagination']['price_list_page'] = 1
#    pagination = c['pagination']
  #  $(this).attr('href', null)
  #  $('[id=games_search_activities_]').html(null)
    $.ajax
      url: b#null,#'/games/search_activities'
      data: c,
      dataType: "script"        
  #    success: (data, textStatus, jqXHR) ->
  #      $('[id=games_search_activities_]').html(data)
  #      alert(data)
  false         
