get_tabs_current_page = ->
  filtr={}
  $("[class*=tabbable]").each (index, tabs) ->
    tabs_name = $(tabs).attr("name")
    filtr[tabs_name] = -1
    i = 0
    $(tabs).children("[class*=tab-pane]").each (index, element) ->
      body_tab_id = $(element).attr("id")
      if $(element).hasClass("active")
        filtr[tabs_name] = i 
      i += 1
  filtr  

$(document).on 'hidden.bs.tab', "[data-toggle*=tab]", ->
  row_url = '/home/update_tabs'
  
  filtr = {}
  filtr["current_tabs_page"] = get_tabs_current_page()

  $.ajax
    url: row_url, 
#    async: false,
    data: filtr,
    dataType: "script",
