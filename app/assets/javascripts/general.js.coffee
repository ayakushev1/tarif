get_accordion_current_page = ->
  filtr={}
  $("[class*=accordion]").each (index, accordion) ->
    if $(accordion).hasClass("accordion")
      accordion_name = $(accordion).attr("name")
      $(accordion).find("[class*=accordion-toggle]").each (index, element) ->
        body_accordion_id = $(element).attr("href")        
        if $(body_accordion_id).hasClass("in")
          filtr[accordion_name] = body_accordion_id
      filtr[accordion_name] = "" if $.isEmptyObject(filtr[accordion_name])
  filtr  


get_tabs_current_page = ->
  filtr={}
  $("[class*=tabbable]").each (index, tabs) ->
    tabs_name = $(tabs).attr("name")
    current_tabs_page = $(tabs).attr("active") || ""
    
    $(tabs).children("[class*=tab-content]").children("[class*=tab-pane]").each (index, element) ->
      body_tab_id = $(element).attr("id")
      if $(element).hasClass("active")
        filtr[tabs_name] = body_tab_id 
    filtr[tabs_name] = "" if $.isEmptyObject(filtr[tabs_name])

  filtr  


$(document).on 'click', "[type=checkbox]", ->
  if $.isEmptyObject($(this).attr('checked'))
    $(this).attr('checked', true)
  else
    $(this).attr('checked', false)

$(document).on 'change', "[id*=filtr]", ->
  element_before_ajax = this
  filtr_url = $(this).attr("action_name")
  filtr_name = $(this).attr("filtr_name")
      
  filtr = {}
  sub_filtr = {}
  $("[id^=#{filtr_name}]").each (index, element) ->
    filtr[$(element).attr("name")] = $(element).val()
    
    if $(element).attr('type') == 'checkbox'
      if $.isEmptyObject($(element).attr('checked'))
        filtr[$(element).attr("name")] = false
      else
        filtr[$(element).attr("name")] = true
      
    sub_2_filtr = {}
    $(element).children("[id]").each (index_2, element_2) ->
      sub_2_filtr[$(element_2).attr("name")]= $(element_2).val()
    if $(element).val() == ""
      unless $.isEmptyObject(sub_2_filtr)
        filtr[$(element).attr("name")]= sub_2_filtr["date[hour]"] + ":" + sub_2_filtr["date[minute]"]         
  
  filtr[filtr_name] = sub_filtr
  filtr["current_tabs_page"] = get_tabs_current_page()
  filtr["current_accordion_page"] = get_accordion_current_page()

  unless $.isEmptyObject(filtr_url)
    $.ajax
      url: filtr_url,
      data: filtr,
      dataType: "script"
      success: ->
        element_after_ajax = document.getElementById($(element_before_ajax).attr("id") )
        $(":input")[$(":input").index(element_after_ajax)].focus() 
        
$(document).on 'click', "[id*=raw]", ->
  raw_name = $(this).attr("raw_name")
  $("[id^=#{raw_name}]").not(this).removeClass("current_table_raw")
  $(this).addClass("current_table_raw")
  raw_id_name = $(this).attr("current_id_name")
  raw_url = $(this).attr("action_name")
  
  filtr = {}
  filtr["current_id"] = {}
  filtr["current_id"][raw_id_name] = $(this).attr("value")
  filtr["current_tabs_page"] = get_tabs_current_page()
  filtr["current_accordion_page"] = get_accordion_current_page()

  $.ajax
    url: raw_url, 
    data: filtr,
    dataType: "script"
    success: (data, textStatus, jqXHR) ->
