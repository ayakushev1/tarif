$(document).on 'click', "tr[id*=row], .panel[id*=row]", ->
  row_name = $(this).attr("row_name")
  row_id_name = $(this).attr("current_id_name")
  row_url = $(this).attr("action_name")
  
  filtr = {}
  filtr["current_id"] = {}
  filtr["current_id"][row_id_name] = $(this).attr("value")
#  filtr["current_accordion_page"] = get_accordion_current_page()

  $.ajax
    url: row_url, 
    async: true,
    data: filtr,
    dataType: "script",
    headers: referer: row_url
    success: (data, textStatus, jqXHR) ->
