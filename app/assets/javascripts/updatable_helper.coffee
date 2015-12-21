$(document).on 'change', ".updatable", ->
  element_before_ajax_index = $(":input").index(this) 
  filtr_url = $(this).attr("action_name")
  filtr_name = $(this).attr("filtr_name")
      
  filtr = {}
  sub_filtr = {}
  $("[name^=#{filtr_name}]").each (index, element) ->
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
#  filtr["current_accordion_page"] = get_accordion_current_page()

#  unless $.isEmptyObject(filtr_url)
  $.ajax
    url: filtr_url,
    data: filtr,
    dataType: "script"
    success: ->
      if $(":input")[element_before_ajax_index + 1]
      	$(":input")[element_before_ajax_index + 1].focus() 