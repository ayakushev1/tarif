

#change history for browser to correctly replay on refresh and back button after ajax
$(document).on 'click', 'a', (e) ->
#  e.preventDefault
  history.pushState {page: this.href}, '', this.href


$(document).on 'change', "[type=checkbox]", ->
  if $.isEmptyObject($(this).attr('checked'))
    $(this).attr('checked', true)
  else
    $(this).attr('checked', false)

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
      $(":input")[element_before_ajax_index + 1].focus() 
        
$(document).on 'click', "tr[id*=row]", ->
  row_name = $(this).attr("row_name")
  $("[id^=#{row_name}]").not(this).removeClass("current_table_row")
  $(this).addClass("current_table_row")
  row_id_name = $(this).attr("current_id_name")
  row_url = $(this).attr("action_name")
  
  filtr = {}
  filtr["current_id"] = {}
  filtr["current_id"][row_id_name] = $(this).attr("value")
#  filtr["current_accordion_page"] = get_accordion_current_page()

  $.ajax
    url: row_url, 
    async: false,
    data: filtr,
    dataType: "script",
    headers: referer: row_url
    success: (data, textStatus, jqXHR) ->
