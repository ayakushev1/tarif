load_accordion = ->
  $("[class*=accordion]").each (index, accordion) ->
    if $(accordion).hasClass("accordion")
      active_body_element = $(accordion).attr("active")
      $(accordion).find("[class*=accordion-body]").each (index, element) ->
        if $(active_body_element).attr("id") == $(element).attr("id")
          $(element).addClass('in')
        else
          $(element).removeClass('in')
      $(accordion).collapse
        toggle: false
        
load_tabs = ->
  $("[class*=tabbable]").each (index, tabs) ->
    active_body_element = $(tabs).attr("active")    
    active_body_element = $(tabs).children().children("[class*=tab-pane]").first().attr("id") if active_body_element == ""
      
    $(tabs).children("[class*=nav-tabs]").children().children("[data-toggle=tab]").each (index, element) ->
      if ("#" + active_body_element) == $(element).attr("href")
        $(element).parent().addClass('active')
      else
        $(element).parent().removeClass('active')    
    
    $(tabs).children("[class*=tab-content]").children("[class*=tab-pane]").each (index, element) ->
      if active_body_element == $(element).attr("id")
        $(element).addClass('active')
      else
        $(element).removeClass('active')    
    
    $(tabs).tab("show")

load_datepicker =  ->
  $("[class=datepicker]").each (index, element) ->
    $(element).datepicker
      format: "dd.mm.yy"
      weekStart: 1
      autoclose: true
      todayHighlight: true
      clearBtn: true
      todayBtn: true      
      setDate: $(this).attr("value")
      
do_on_load =  ->
#  load_tabs()
  load_datepicker()
#  load_accordion()
    
$(document).on 'ready page:load ajaxComplete', -> 
  do_on_load()
      
