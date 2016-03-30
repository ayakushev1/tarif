get_accordion_current_page = ->
  filtr={}
  $("[class*=accordion]").each (index, accordion) ->
    if $(accordion).hasClass("accordion")
      accordion_name = $(accordion).attr("name")
      filtr[accordion_name] = -1
      i = 0
      $(accordion).find("[class*=panel-collapse]").each (index, element) ->
#        body_accordion_id = $(element).attr("href")        
#        if $(body_accordion_id).hasClass("in")
        if $(element).hasClass("in")
          filtr[accordion_name] = i
        i += 1
#      alert(filtr[accordion_name])
  filtr  

$(document).on 'click', "[data-toggle*=collapse]", ->
  if $(this).hasClass("my_accordion")
    row_url = '/home/update_tabs'
    accordion_name = $(this).attr("accord_name") 
    if $(this).hasClass("collapsed")
      accordion_id = -1
    else
      accordion_id = $(this).attr("accord_id")   
    filtr = {}
    filtr["current_accordion_page"] = {} 
    filtr["current_accordion_page"][accordion_name] = accordion_id
	
    $.ajax
      url: row_url, 
    #  async: false,
      data: filtr,
      dataType: "script",


